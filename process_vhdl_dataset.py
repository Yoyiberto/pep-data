import pandas as pd
import os

def process_excel_to_files(excel_file_path, output_folder):
    """
    Reads an Excel file, extracts VHDL code from the first column
    and descriptions from a 'description' column, then saves them
    into .vhd and .txt files respectively.

    Args:
        excel_file_path (str): Path to the input Excel file.
        output_folder (str): Path to the folder where output files will be saved.
    """
    try:
        # Read the Excel file
        # Assuming the VHDL code is in the first column (index 0)
        # and descriptions are in a column named 'description'
        df = pd.read_excel(excel_file_path, header=0) # header=0 to use first row as column names
        
        # Ensure the output directory exists
        if not os.path.exists(output_folder):
            os.makedirs(output_folder)
            print(f"Created output directory: {output_folder}")

        # Check if 'description' column exists
        if 'description' not in df.columns:
            print(f"Error: Column 'description' not found in {excel_file_path}.")
            print(f"Available columns are: {df.columns.tolist()}")
            # Attempt to use the second column if 'description' is not found,
            # assuming it might be the intended column.
            if len(df.columns) > 1:
                description_col_name = df.columns[1]
                print(f"Trying to use the second column '{description_col_name}' for descriptions.")
            else:
                print("Not enough columns to infer a description column.")
                return
        else:
            description_col_name = 'description'
            
        # Identify the VHDL code column (first column by default)
        if df.empty or len(df.columns) == 0:
            print(f"Error: The Excel file '{excel_file_path}' is empty or has no columns.")
            return
        vhdl_code_col_name = df.columns[0]

        print(f"Processing VHDL code from column: '{vhdl_code_col_name}'")
        print(f"Processing descriptions from column: '{description_col_name}'")

        # Iterate through each row of the DataFrame
        for index, row in df.iterrows():
            # Get VHDL code (from the first column)
            vhdl_code = str(row[vhdl_code_col_name])
            
            # Get description
            description_text = ""
            if description_col_name in df.columns: # Check again in case it was inferred
                 description_text = str(row[description_col_name])
            elif len(df.columns) > 1 : # if description_col_name was from df.columns[1]
                 description_text = str(row[df.columns[1]])


            # Define file names
            # Adding 1 to index because iterrows() provides 0-based index
            file_base_name = f"row{index + 1}"
            vhdl_file_name = os.path.join(output_folder, f"{file_base_name}.vhd")
            txt_file_name = os.path.join(output_folder, f"{file_base_name}.txt")

            # Write VHDL code to .vhd file
            try:
                with open(vhdl_file_name, 'w', encoding='utf-8') as f_vhd:
                    f_vhd.write(vhdl_code)
                print(f"Successfully created {vhdl_file_name}")
            except Exception as e:
                print(f"Error writing VHDL file {vhdl_file_name}: {e}")

            # Write description to .txt file
            try:
                with open(txt_file_name, 'w', encoding='utf-8') as f_txt:
                    f_txt.write(description_text)
                print(f"Successfully created {txt_file_name}")
            except Exception as e:
                print(f"Error writing TXT file {txt_file_name}: {e}")
                
        print("\nProcessing complete.")

    except FileNotFoundError:
        print(f"Error: The file {excel_file_path} was not found.")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

if __name__ == "__main__":
    excel_file = "vhdl_dataset.xlsx"
    output_dir = "vhld_from_xlsx_data"
    
    # Note: Make sure 'pandas' and 'openpyxl' (or other Excel engine) are installed.
    # You can install them using: pip install pandas openpyxl
    
    print(f"Starting script to process {excel_file} into {output_dir}...")
    process_excel_to_files(excel_file, output_dir) 