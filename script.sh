#!/bin/bash

# Debug: Current working directory from within script:
echo "Debug: Current working directory from within script: $(pwd)"

# Debug: Attempt to list .vs files using ls
echo "Debug: Listing .vs files with ls: $(ls -A -- *.vs 2>/dev/null || echo 'ls found no .vs files')"

# Debug: Attempt to list .vs files using find
echo "Debug: Listing .vs files with find: $(find . -maxdepth 1 -type f -name '*.vs' -print || echo 'find found no .vs files')"

# Set nullglob to ensure that if no files match *.vs, the 'files' array will be empty
# instead of containing the literal string "*.vs".
shopt -s nullglob
files=(*.vs)
# It's good practice to unset nullglob if it's not needed for the rest of the script's scope,
# or if other parts of a larger script might depend on the default behavior.
shopt -u nullglob

# Debug: Show what the files array contains
echo "Debug: files array content after globbing: |${files[@]}|"
echo "Debug: Number of files found in array: ${#files[@]}"

# Check if any .vs files were found
if [ ${#files[@]} -eq 0 ]; then
  echo "No .vs files found in the current directory."
  echo "Please make sure you are in the directory containing your SystemVerilog (.vs) files."
  exit 1
fi

echo "Starting conversion of .vs files to .vhd files..."

for file in "${files[@]}"; do
  # Extract the base name of the file (without the .vs extension)
  base=$(basename "$file" .vs)
  output_file="${base}.vhd"

  echo "Processing '$file' -> '$output_file'"

  # Corrected iverilog command: use '-t vhdl' (with a space)
  iverilog -t vhdl -o "$output_file" "$file"

  # Check the exit status of the iverilog command
  if [ $? -eq 0 ]; then
    echo "Successfully converted '$file' to '$output_file'"
  else
    echo "Error converting '$file'. iverilog exited with status $?."
    # You might want to uncomment the next line to stop the script on the first error
    # exit 1
  fi
done

echo "Batch conversion finished."