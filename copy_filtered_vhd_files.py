import os
import shutil
from pathlib import Path

# Import the array from our previous file
from count.row_numbers_array import array

def copy_filtered_vhd_files():
    """
    Copy only the rowXXX.vhd files that correspond to numbers in our array
    from the source directory to the filtered directory
    """
    
    # Define source and destination directories
    source_dir = Path("vhld_from_xlsx_data")
    dest_dir = Path("vhld_from_xlsx_data/filtered")
    
    # Create destination directory if it doesn't exist
    dest_dir.mkdir(parents=True, exist_ok=True)
    
    # Statistics
    files_copied = 0
    files_not_found = 0
    
    print(f"Source directory: {source_dir}")
    print(f"Destination directory: {dest_dir}")
    print(f"Looking for {len(array)} row files...")
    print("=" * 60)
    
    # Check if source directory exists
    if not source_dir.exists():
        print(f"Error: Source directory '{source_dir}' does not exist!")
        return
    
    # Copy files for each number in the array
    for row_number in array:
        source_file = source_dir / f"row{row_number}.vhd"
        dest_file = dest_dir / f"row{row_number}.vhd"
        
        if source_file.exists():
            try:
                shutil.copy2(source_file, dest_file)
                files_copied += 1
                if files_copied <= 10 or files_copied % 50 == 0:  # Show progress
                    print(f"Copied: row{row_number}.vhd")
            except Exception as e:
                print(f"Error copying row{row_number}.vhd: {e}")
        else:
            files_not_found += 1
            if files_not_found <= 10:  # Show first 10 missing files
                print(f"Not found: row{row_number}.vhd")
            elif files_not_found == 11:
                print("... (more missing files)")
    
    print("=" * 60)
    print(f"Copy operation completed!")
    print(f"Files successfully copied: {files_copied}")
    print(f"Files not found: {files_not_found}")
    print(f"Total files expected: {len(array)}")
    
    if files_copied > 0:
        print(f"\nFiltered files are now available in: {dest_dir}")
    
    return files_copied, files_not_found

def list_source_files():
    """
    List all .vhd files in the source directory for verification
    """
    source_dir = Path("vhld_from_xlsx_data")
    
    if not source_dir.exists():
        print(f"Source directory '{source_dir}' does not exist!")
        return
    
    vhd_files = list(source_dir.glob("*.vhd"))
    row_files = [f for f in vhd_files if f.name.startswith("row") and f.name.endswith(".vhd")]
    
    print(f"Total .vhd files in source: {len(vhd_files)}")
    print(f"Row files (rowXXX.vhd) in source: {len(row_files)}")
    
    if len(row_files) <= 20:
        print("Row files found:")
        for f in sorted(row_files):
            print(f"  {f.name}")
    else:
        print("First 10 row files found:")
        for f in sorted(row_files)[:10]:
            print(f"  {f.name}")
        print("  ...")
        print("Last 10 row files found:")
        for f in sorted(row_files)[-10:]:
            print(f"  {f.name}")

def main():
    print("VHD File Filter and Copy Script")
    print("=" * 60)
    
    # First, let's see what's in the source directory
    print("Checking source directory...")
    list_source_files()
    print()
    
    # Then copy the filtered files
    print("Starting copy operation...")
    copy_filtered_vhd_files()

if __name__ == "__main__":
    main() 