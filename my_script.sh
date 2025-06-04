INPUT_DIR="D:/Proyectos/EMINENT_D/2025-01/PEP/Data/verilog-eval/dataset_code-complete-iccad2023"
OUTPUT_DIR="${INPUT_DIR}/VHDL"

# Create the output directory if it doesn't exist
mkdir -p "${OUTPUT_DIR}"

# Change to the input directory to find .sv files
cd "${INPUT_DIR}" || exit 1

for file in *.sv; do
  if [[ -f "$file" ]]; then
    base=$(basename "$file" .sv)
    # If you know the top module name, replace 'top_module' below
    echo "Processing $file..."
    iverilog -tvhdl -o "${OUTPUT_DIR}/${base}.vhd" "$file"
  fi
done
echo "Conversion complete. VHDL files are in ${OUTPUT_DIR}"