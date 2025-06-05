import os
import json
import requests

# --- Configuration ---
BASE_PROMPT_FILE = "hdl_coder/descriptions/prompt.txt"
VHD_FILES_RELATIVE_TO_WORKSPACE = [
    "hdl_coder/descriptions/hdlcoder_row2.vhd",
    "hdl_coder/descriptions/hdlcoder_row12.vhd",
    "hdl_coder/descriptions/hdlcoder_row13.vhd",
]
OUTPUT_DIR_RELATIVE_TO_WORKSPACE = "hdl_coder/descriptions/out"

# Ollama Configuration
OLLAMA_BASE_URL = "http://localhost:11434"  # Default Ollama URL
OLLAMA_MODEL = "llama3:latest"  # You can change this to any model you have installed
# Available models: "mistral:latest", "python-expert:latest", "llama3:latest"

OLLAMA_OPTIONS = {
    "temperature": 0.7,
    "top_p": 1.0,
    "top_k": 40,
    "num_predict": 8192,  # Maximum tokens to generate
}

# --- Helper Functions ---
def get_absolute_path(relative_to_workspace_path):
    """Converts a path relative to the workspace root to an absolute path."""
    script_dir = os.path.dirname(os.path.abspath(__file__))
    # Workspace root is assumed to be two levels up from the script's directory
    # (Data/hdl_coder/descriptions/ -> Data/)
    workspace_root = os.path.abspath(os.path.join(script_dir, "..", ".."))
    return os.path.join(workspace_root, relative_to_workspace_path)

def read_file_content(file_path):
    """Reads the entire content of a file."""
    try:
        with open(get_absolute_path(file_path), 'r', encoding='utf-8') as f:
            return f.read()
    except FileNotFoundError:
        print(f"Error: File not found at {get_absolute_path(file_path)}")
        return None
    except Exception as e:
        print(f"Error reading file {get_absolute_path(file_path)}: {e}")
        return None

def call_ollama_api(prompt_text):
    """Calls the Ollama API with the given prompt and returns the JSON response."""
    try:
        print(f"Sending request to Ollama API with model {OLLAMA_MODEL}...")
        
        # Prepare the request payload
        payload = {
            "model": OLLAMA_MODEL,
            "prompt": prompt_text,
            "stream": False,
            "options": OLLAMA_OPTIONS
        }
        
        # Make the API call
        response = requests.post(
            f"{OLLAMA_BASE_URL}/api/generate",
            json=payload,
            timeout=300  # 5 minutes timeout
        )
        
        if response.status_code != 200:
            print(f"Error: Ollama API returned status code {response.status_code}")
            print(f"Response: {response.text}")
            return None
            
        response_data = response.json()
        response_text = response_data.get("response", "")
        
        if not response_text:
            print("Error: Empty response from Ollama API")
            return None

        # Attempt to find and parse JSON block
        json_start_index = response_text.find('{')
        json_end_index = response_text.rfind('}')
        if json_start_index != -1 and json_end_index != -1 and json_end_index > json_start_index:
            json_str = response_text[json_start_index : json_end_index + 1]
            try:
                parsed_json = json.loads(json_str)

                # --- Apply desired formatting to the description strings ---
                SYS_MSG_CONTENT = "You only complete chats with syntax-correct VHDL code. End the VHDL architecture code with end <architecture_name>;. Include all required entities, ports, signals, and logic to ensure compilable code."
                
                for key in ["block_summary", "detailed_global_summary", "high_level_global_summary"]:
                    if key in parsed_json and isinstance(parsed_json[key], str):
                        plain_description_from_llm = parsed_json[key]
                        
                        # --- Simple formatting with actual newlines ---
                        formatted_string = (
                            "\n <s>[INST] <<SYS>>\n" +
                            SYS_MSG_CONTENT +
                            "\n <</SYS>>\n\n" +
                            plain_description_from_llm +
                            "\n [/INST]\n"
                        )
                        parsed_json[key] = formatted_string
                # --- End of formatting ---
                return parsed_json
            except json.JSONDecodeError as e:
                print(f"Error: Could not decode JSON from API response: {e}")
                print(f"Problematic JSON string: {json_str}")
                return None
        else:
            print("Error: Could not find a valid JSON object in the API response.")
            print(f"Full response: {response_text}")
            return None

    except requests.exceptions.ConnectionError:
        print(f"Error: Could not connect to Ollama at {OLLAMA_BASE_URL}")
        print("Make sure Ollama is running locally. You can start it with: ollama serve")
        return None
    except requests.exceptions.Timeout:
        print("Error: Request to Ollama API timed out")
        return None
    except Exception as e:
        print(f"Error calling Ollama API: {e}")
        return None

def check_ollama_connection():
    """Check if Ollama is running and the model is available."""
    try:
        # Check if Ollama is running
        response = requests.get(f"{OLLAMA_BASE_URL}/api/tags", timeout=5)
        if response.status_code != 200:
            print(f"Error: Could not connect to Ollama at {OLLAMA_BASE_URL}")
            return False
            
        # Check if the specified model is available
        models = response.json().get("models", [])
        model_names = [model["name"] for model in models]
        
        if not any(OLLAMA_MODEL in name for name in model_names):
            print(f"Error: Model '{OLLAMA_MODEL}' not found in Ollama")
            print(f"Available models: {model_names}")
            print(f"You can install the model with: ollama pull {OLLAMA_MODEL}")
            return False
            
        print(f"Successfully connected to Ollama. Using model: {OLLAMA_MODEL}")
        return True
        
    except requests.exceptions.ConnectionError:
        print(f"Error: Could not connect to Ollama at {OLLAMA_BASE_URL}")
        print("Make sure Ollama is running locally. You can start it with: ollama serve")
        return False
    except Exception as e:
        print(f"Error checking Ollama connection: {e}")
        return False

def write_output(file_path, data):
    """Writes data to a file, creating directories if they don't exist."""
    try:
        abs_file_path = get_absolute_path(file_path)
        os.makedirs(os.path.dirname(abs_file_path), exist_ok=True)
        with open(abs_file_path, 'w', encoding='utf-8') as f:
            if isinstance(data, dict) or isinstance(data, list):
                json.dump(data, f, indent=2)
            else:
                f.write(data)
        print(f"Successfully wrote output to {abs_file_path}")
    except Exception as e:
        print(f"Error writing output to {abs_file_path}: {e}")

# --- Main Script ---
def main():
    print("Starting VHDL description generation script with Ollama...")
    script_dir = os.path.dirname(os.path.abspath(__file__))
    workspace_root = os.path.abspath(os.path.join(script_dir, "..", ".."))
    print(f"Script location: {script_dir}")
    print(f"Determined workspace root: {workspace_root}")
    print(f"Current working directory: {os.getcwd()}")

    # Check Ollama connection and model availability
    if not check_ollama_connection():
        print("Exiting due to Ollama connection failure.")
        return

    base_prompt_content = read_file_content(BASE_PROMPT_FILE)
    if not base_prompt_content:
        print("Exiting due to base prompt loading failure.")
        return

    # Ensure output directory exists
    abs_output_dir = get_absolute_path(OUTPUT_DIR_RELATIVE_TO_WORKSPACE)
    if not os.path.exists(abs_output_dir):
        os.makedirs(abs_output_dir)
        print(f"Created output directory: {abs_output_dir}")

    for vhd_file_relative_path in VHD_FILES_RELATIVE_TO_WORKSPACE:
        print(f"\nProcessing VHD file: {vhd_file_relative_path}...")
        vhd_content = read_file_content(vhd_file_relative_path)
        if not vhd_content:
            print(f"Skipping {vhd_file_relative_path} due to read error.")
            continue

        # Construct the full prompt with explicit JSON requirement
        full_prompt = (base_prompt_content + "\n\n```vhdl\n" + vhd_content + "\n```\n\n" +
                      "IMPORTANT: You must respond with ONLY a valid JSON object. Do not include any explanatory text before or after the JSON. " +
                      "Start your response with { and end with }.")

        api_response_json = call_ollama_api(full_prompt)

        if api_response_json:
            # Determine output file name
            base_vhd_filename = os.path.basename(vhd_file_relative_path) # e.g., hdlcoder_row2.vhd
            # Replace "hdlcoder_" with "hdlcoder_dscpt_ollama_" and ".vhd" with ".txt"
            if base_vhd_filename.startswith("hdlcoder_") and base_vhd_filename.endswith(".vhd"):
                output_filename_base = "hdlcoder_dscpt_ollama_" + base_vhd_filename[len("hdlcoder_"):-len(".vhd")]
                output_filename = output_filename_base + ".txt"
            else: # Fallback for unexpected filenames
                output_filename = os.path.splitext(base_vhd_filename)[0] + "_dscpt_ollama.txt"

            output_file_path = os.path.join(OUTPUT_DIR_RELATIVE_TO_WORKSPACE, output_filename)
            write_output(output_file_path, api_response_json)
        else:
            print(f"Failed to get a valid response from Ollama API for {vhd_file_relative_path}. Skipping output.")

    print("\nScript finished.")

if __name__ == "__main__":
    main() 