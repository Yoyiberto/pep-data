import os
import google.generativeai as genai
from dotenv import load_dotenv
import json

# --- Configuration ---
# Assumes the .env file is in a directory named 'flash2.5_verilog' at the same level as this script's parent directory
# Adjust an_env_file_path if your .env file is located elsewhere.
# For example, if .env is in the same directory as this script, set: an_env_file_path = ".env"
# If .env is in the parent directory, set: an_env_file_path = "../.env"
ENV_FILE_PATH = "../../flash2.5_verilog/.env" # Path to .env file, relative to this script file

BASE_PROMPT_FILE = "hdl_coder/descriptions/prompt.txt"
VHD_FILES_RELATIVE_TO_WORKSPACE = [
    "hdl_coder/descriptions/hdlcoder_row2.vhd",
    "hdl_coder/descriptions/hdlcoder_row12.vhd",
    "hdl_coder/descriptions/hdlcoder_row13.vhd",
]
OUTPUT_DIR_RELATIVE_TO_WORKSPACE = "hdl_coder/descriptions/out"
#GEMINI_API_MODEL = "gemini-2.5-flash-preview-05-20" # Using 1.5 flash as 2.5 is not a valid model name
GEMINI_API_MODEL = "gemini-2.0-flash-lite" # Using 1.5 flash as 2.5 is not a valid model name

# Safety settings for the Gemini API call
GENERATION_CONFIG = {
    "temperature": 0.7,
    "top_p": 1,
    "top_k": 1,
    "max_output_tokens": 8192,
}

SAFETY_SETTINGS = [
    {"category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_MEDIUM_AND_ABOVE"},
    {"category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_MEDIUM_AND_ABOVE"},
    {"category": "HARM_CATEGORY_SEXUALLY_EXPLICIT", "threshold": "BLOCK_MEDIUM_AND_ABOVE"},
    {"category": "HARM_CATEGORY_DANGEROUS_CONTENT", "threshold": "BLOCK_MEDIUM_AND_ABOVE"},
]

# --- Helper Functions ---
def get_absolute_path(relative_to_workspace_path):
    """Converts a path relative to the workspace root to an absolute path."""
    script_dir = os.path.dirname(os.path.abspath(__file__))
    # Workspace root is assumed to be two levels up from the script's directory
    # (Data/hdl_coder/descriptions/ -> Data/)
    workspace_root = os.path.abspath(os.path.join(script_dir, "..", ".."))
    return os.path.join(workspace_root, relative_to_workspace_path)

def load_api_key(env_path_relative_to_script):
    """Loads the Google API key from the specified .env file, path relative to this script."""
    script_dir = os.path.dirname(os.path.abspath(__file__))
    absolute_env_path = os.path.abspath(os.path.join(script_dir, env_path_relative_to_script))

    if not os.path.exists(absolute_env_path):
        print(f"Error: API key file not found at {absolute_env_path}")
        print(f"Script directory: {script_dir}")
        print(f"Relative path used for .env: {env_path_relative_to_script}")
        return None
    load_dotenv(dotenv_path=absolute_env_path)
    api_key = os.getenv("GOOGLE_API_KEY")
    if not api_key:
        print(f"Error: GOOGLE_API_KEY not found in {absolute_env_path}")
    return api_key

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

def call_gemini_api(api_key, prompt_text):
    """Calls the Gemini API with the given prompt and returns the JSON response."""
    if not api_key:
        print("API key not loaded. Cannot call Gemini API.")
        return None

    genai.configure(api_key=api_key)
    model = genai.GenerativeModel(
        model_name=GEMINI_API_MODEL,
        generation_config=GENERATION_CONFIG,
        safety_settings=SAFETY_SETTINGS,
    )
    try:
        print(f"Sending request to Gemini API with model {GEMINI_API_MODEL}...")
        response = model.generate_content([prompt_text])
        # Assuming the response.text contains the JSON string as described in the prompt
        # Extract the JSON part carefully, as the API might add backticks or "json" prefix
        response_text = response.text
        # print(f"Raw API Response Text:\\n{response_text}") # For debugging

        # Attempt to find and parse JSON block
        json_start_index = response_text.find('{')
        json_end_index = response_text.rfind('}')
        if json_start_index != -1 and json_end_index != -1 and json_end_index > json_start_index:
            json_str = response_text[json_start_index : json_end_index + 1]
            try:
                return json.loads(json_str)
            except json.JSONDecodeError as e:
                print(f"Error: Could not decode JSON from API response: {e}")
                print(f"Problematic JSON string: {json_str}")
                return None
        else:
            print("Error: Could not find a valid JSON object in the API response.")
            print(f"Full response: {response_text}")
            return None

    except Exception as e:
        print(f"Error calling Gemini API: {e}")
        # print(f"Response object: {response}") # For debugging complex errors
        return None


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
    print("Starting VHDL description generation script...")
    script_dir = os.path.dirname(os.path.abspath(__file__))
    workspace_root = os.path.abspath(os.path.join(script_dir, "..", ".."))
    print(f"Script location: {script_dir}")
    print(f"Determined workspace root: {workspace_root}")
    print(f"Current working directory: {os.getcwd()}")

    # ENV_FILE_PATH is now relative to the script file itself.
    # load_api_key function handles resolving this.
    api_key = load_api_key(ENV_FILE_PATH)
    if not api_key:
        print("Exiting due to API key loading failure.")
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
        print(f"\\nProcessing VHD file: {vhd_file_relative_path}...")
        vhd_content = read_file_content(vhd_file_relative_path)
        if not vhd_content:
            print(f"Skipping {vhd_file_relative_path} due to read error.")
            continue

        # Construct the full prompt
        full_prompt = base_prompt_content + "\\n\\n```vhdl\\n" + vhd_content + "\\n```"
        # print(f"\\n--- Combined Prompt for {vhd_file_relative_path} ---")
        # print(full_prompt[:500] + "..." if len(full_prompt) > 500 else full_prompt) # Print a snippet
        # print("--- End of Combined Prompt Snippet ---")


        api_response_json = call_gemini_api(api_key, full_prompt)

        if api_response_json:
            # Determine output file name
            base_vhd_filename = os.path.basename(vhd_file_relative_path) # e.g., hdlcoder_row2.vhd
            # Replace "hdlcoder_" with "hdlcoder_dscpt_" and ".vhd" with ".txt"
            if base_vhd_filename.startswith("hdlcoder_") and base_vhd_filename.endswith(".vhd"):
                output_filename_base = "hdlcoder_dscpt_" + base_vhd_filename[len("hdlcoder_"):-len(".vhd")]
                output_filename = output_filename_base + ".txt"
            else: # Fallback for unexpected filenames
                output_filename = os.path.splitext(base_vhd_filename)[0] + "_dscpt.txt"

            output_file_path = os.path.join(OUTPUT_DIR_RELATIVE_TO_WORKSPACE, output_filename)
            write_output(output_file_path, api_response_json)
        else:
            print(f"Failed to get a valid response from API for {vhd_file_relative_path}. Skipping output.")

    print("\\nScript finished.")

if __name__ == "__main__":
    main() 