#!/usr/bin/env python3
import os
import sys
import subprocess
from pathlib import Path

def find_vhdl_files(directory):
    """Find all .vhd files in the given directory and its subdirectories."""
    vhdl_files = []
    # Normalize the input directory path first to ensure os.walk behaves as expected
    # with mixed/MSYS paths and results in absolute, canonical paths.
    normalized_directory = os.path.abspath(os.path.normpath(directory))

    for root, _, files_in_dir in os.walk(normalized_directory):
        for file_name in files_in_dir: # Renamed 'file' to 'file_name'
            if file_name.lower().endswith('.vhd'):
                # root is already an absolute, canonical path from os.walk(normalized_directory)
                vhdl_files.append(os.path.join(root, file_name))
    vhdl_files.sort() # Ensure consistent order
    return vhdl_files

def run_ghdl_syntax_check_batch(file_paths):
    """Run GHDL syntax check on a batch of VHDL files and return the output."""
    if not file_paths:
        return "", "", 0 # No files to check

    cmd = ['ghdl', '-s'] + file_paths
    try:
        result = subprocess.run(cmd,
                                capture_output=True,
                                text=True,
                                timeout=60, # Increased timeout for potentially more files
                                check=False)
        return result.stderr, result.stdout, result.returncode
    except FileNotFoundError:
        return "Error: ghdl not found. Please ensure GHDL is installed and in your PATH.", "", 1
    except subprocess.TimeoutExpired:
        return "Error: GHDL timed out processing the batch.", "", 1

def main():
    if len(sys.argv) != 2:
        print("Usage: python check_vhdl.py <directory_path>")
        print("\nMake sure to:")
        print("1. Run setup_vhdllint.bat first to install vhdllint")
        print("2. Activate the virtual environment: .venv\\Scripts\\activate.bat")
        print("\nMake sure GHDL is installed and accessible in your PATH.")
        sys.exit(1)

    directory = sys.argv[1]
    if not os.path.isdir(directory):
        print(f"Error: {directory} is not a valid directory")
        sys.exit(1)

    vhdl_files = find_vhdl_files(directory)
    if not vhdl_files:
        print(f"No VHDL files found in {directory}")
        sys.exit(0)

    total_files = len(vhdl_files)
    print(f"\nChecking {total_files} VHDL files in {directory} as a batch...\n")
    print("=" * 80)

    files_with_issues = 0
    total_issues = 0
    
    stderr_output, stdout_output, returncode = run_ghdl_syntax_check_batch(vhdl_files)
    
    if "ghdl not found" in stderr_output:
        print(f"Error: {stderr_output}")
        sys.exit(1)

    if returncode != 0 and stderr_output.strip():
        print("Syntax Errors Found in Batch:")
        error_lines = stderr_output.strip().split('\\n')
        
        unique_files_with_actual_errors = set()
        
        # vhdl_files contains absolute paths. Normcase them for the set and map keys/values.
        # Ensure paths are normcased for case-insensitive comparison on Windows.
        normcased_vhdl_file_abs_paths = {os.path.normcase(f) for f in vhdl_files}
        # For basename matching, keys are normcased basenames, values are normcased full paths.
        normcased_vhdl_file_basenames = {
            os.path.normcase(os.path.basename(f)): os.path.normcase(f) for f in vhdl_files
        }

        primary_error_indicator = ":error:" # GHDL typically uses this for actual errors
        actual_error_messages_count = 0

        for line_content in error_lines:
            print(line_content) # Print each error line from GHDL's stderr
            
            if primary_error_indicator in line_content:
                actual_error_messages_count += 1

                # Try to extract what looks like a file path from the start of the line
                # GHDL format: path/to/file.vhd:line:column: message
                parts = line_content.split(':', 1) 
                if len(parts) > 0:
                    reported_filename_part = parts[0].strip()

                    # Normalize the reported path fully for comparison:
                    # 1. Make it absolute (os.path.abspath handles if it's already absolute, useful if GHDL gives relative)
                    # 2. Normalize slashes (os.path.normpath)
                    # 3. Normalize case (os.path.normcase)
                    normcased_reported_abs = os.path.normcase(os.path.normpath(os.path.abspath(reported_filename_part)))
                    
                    if normcased_reported_abs in normcased_vhdl_file_abs_paths:
                        unique_files_with_actual_errors.add(normcased_reported_abs)
                        continue # Found by absolute path, move to next error line

                    # Strategy 2: Match by normcased basename if GHDL reports a relative/basename
                    # (e.g., if CWD for GHDL was different or it outputs only basename for some errors)
                    normcased_reported_basename = os.path.normcase(os.path.basename(reported_filename_part))
                    if normcased_reported_basename in normcased_vhdl_file_basenames:
                        unique_files_with_actual_errors.add(normcased_vhdl_file_basenames[normcased_reported_basename])
                        continue # Found by basename
        
        files_with_issues = len(unique_files_with_actual_errors)
        total_issues = actual_error_messages_count # Update total_issues to count primary error messages

    elif stderr_output.strip():
        print("GHDL Output (stderr, but no errors reported by exit code):")
        print(stderr_output)
    elif stdout_output.strip():
        print("GHDL Output (stdout):")
        print(stdout_output)
    else:
        print("✓ No syntax issues found in the batch.")

    # Summary
    print("\n" + "=" * 80)
    print(f"SUMMARY:")
    print(f"Total files checked: {total_files}")
    print(f"Files with issues: {files_with_issues}")
    print(f"Files clean: {total_files - files_with_issues}")
    if total_issues > 0:
        print(f"Total issues found: {total_issues}")
    print("=" * 80)

if __name__ == "__main__":
    main() 