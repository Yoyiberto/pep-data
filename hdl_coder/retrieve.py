import os
from datasets import load_dataset
import pandas as pd

def retrieve_hdl_dataset():
    """
    Retrieve the first 100 rows from the ai-hdlcoder-dataset and save 
    the content column as separate .vhd files.
    """
    print("Loading dataset from Hugging Face...")
    
    # Load the dataset
    dataset = load_dataset("AWfaw/ai-hdlcoder-dataset", split="train")
    
    # Convert to pandas DataFrame for easier manipulation
    df = dataset.to_pandas()
    
    # Take only the first 100 rows
    df_subset = df.head(100)
    
    # Create the output directory if it doesn't exist
    output_dir = "hdl_coder/100"
    os.makedirs(output_dir, exist_ok=True)
    
    print(f"Saving {len(df_subset)} files to {output_dir}...")
    
    # Save each content as a separate .vhd file
    for idx, row in df_subset.iterrows():
        filename = f"row{idx + 1}.vhd"
        filepath = os.path.join(output_dir, filename)
        
        # Get the content from the row
        content = row['content']
        
        # Handle cases where content might be None or empty
        if content is None:
            content = ""
        
        # Write content to file
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(str(content))
        
        print(f"Saved {filename}")
    
    print(f"Successfully saved {len(df_subset)} .vhd files!")
    
    # Print some statistics
    print(f"\nDataset info:")
    print(f"Total rows in dataset: {len(df)}")
    print(f"Columns: {list(df.columns)}")
    print(f"Files saved in: {os.path.abspath(output_dir)}")

if __name__ == "__main__":
    retrieve_hdl_dataset()
