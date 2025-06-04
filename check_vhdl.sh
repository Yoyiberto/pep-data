#!/bin/bash

echo "Starting GHDL VHDL syntax check..."

# Check if any files were provided as arguments
if [ $# -eq 0 ]; then
    echo "No VHDL files provided for checking."
    echo "Usage: ./check_vhdl.sh your_file1.vhd [your_file2.vhd ...]"
    echo "Alternatively, to check all .vhd files in the current directory (and subdirectories):"
    echo "find . -name '*.vhd' -print0 | xargs -0 -I {} ./check_vhdl.sh {}" 
    echo "Or, more simply for just the current directory: ./check_vhdl.sh *.vhd"
    exit 1
fi

HAS_ERRORS=0

for vhdl_file in "$@"; do
    if [ ! -f "$vhdl_file" ]; then
        echo "----------------------------------------"
        echo "SKIPPING: File not found: $vhdl_file"
        echo "----------------------------------------"
        continue # Skip to the next file
    fi

    echo ""
    echo "----------------------------------------"
    echo "Analyzing: $vhdl_file"
    echo "----------------------------------------"
    # The -a command analyzes and compiles the VHDL file.
    # It will report syntax errors to standard output/error.
    ghdl -a "$vhdl_file"
    
    # Check the exit status of the last command (ghdl -a)
    # A non-zero exit status usually indicates an error.
    if [ $? -ne 0 ]; then
        echo ">>> Errors found in $vhdl_file <<<"
        HAS_ERRORS=1
    else
        echo ">>> $vhdl_file syntax OK <<<"
    fi
done

echo ""
echo "----------------------------------------"
if [ $HAS_ERRORS -ne 0 ]; then
    echo "VHDL syntax check completed. ERRORS WERE FOUND."
    exit 1 # Exit with an error code
else
    echo "VHDL syntax check completed. All checked files are syntactically OK."
    exit 0 # Exit with success
fi 