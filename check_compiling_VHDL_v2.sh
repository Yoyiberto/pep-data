#!/bin/bash

SUCCESSFUL_FILES=()
FAILED_FILES=()
OUTPUT_FILE="successful_compilations.txt"

# Clear the output file if it exists, or create it
> "$OUTPUT_FILE"

echo "Starting GHDL compilation..."

for vhd_file in *.vhd; do
    if [ -f "$vhd_file" ]; then # Check if it's actually a file
        echo "Compiling $vhd_file..."
        # Using ghdl -a for analysis, or ghdl -c if you want to generate .o files
        # You can add -P (library path) or --work (work library name) if needed
        ghdl -a "$vhd_file"

        if [ $? -eq 0 ]; then
            echo "SUCCESS: $vhd_file compiled successfully."
            SUCCESSFUL_FILES+=("$vhd_file")
            echo "$vhd_file" >> "$OUTPUT_FILE" # Append to the output file
        else
            echo "ERROR: $vhd_file compilation failed."
            FAILED_FILES+=("$vhd_file")
        fi
    else
        echo "Skipping '$vhd_file': Not a regular file."
    fi
done

---

## Compilation Summary

echo ""
echo "--- Compilation Summary ---"
echo "Successful files (also listed in $OUTPUT_FILE):"
for file in "${SUCCESSFUL_FILES[@]}"; do
    echo "- $file"
done

echo ""
echo "Failed files:"
for file in "${FAILED_FILES[@]}"; do
    echo "- $file"
done

echo ""
echo "Compilation process complete. Check '$OUTPUT_FILE' for the list of successfully compiled VHDL files."