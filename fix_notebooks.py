"""
Fix Jupyter notebook metadata to ensure proper GitHub rendering.
Addresses the "state key is missing from metadata.widgets" error.
"""
import json
import os

def fix_notebook_metadata(notebook_path):
    """Remove problematic widget metadata that prevents GitHub rendering"""
    if not os.path.exists(notebook_path):
        print(f"❌ File not found: {notebook_path}")
        return False
    
    try:
        with open(notebook_path, 'r', encoding='utf-8') as f:
            nb = json.load(f)
        
        # Fix widget metadata if it exists and is causing issues
        if 'metadata' in nb and 'widgets' in nb['metadata']:
            # Ensure widgets has proper state structure
            if 'state' not in nb['metadata']['widgets']:
                print(f"  Adding missing 'state' key to widgets metadata")
                nb['metadata']['widgets']['state'] = {}
            
            # If there's a widget-state without state, move it
            if 'widget-state' in nb['metadata']['widgets']:
                nb['metadata']['widgets']['state'] = nb['metadata']['widgets'].pop('widget-state')
        
        # Ensure nbformat is correct
        nb['nbformat'] = 4
        if 'nbformat_minor' not in nb:
            nb['nbformat_minor'] = 0
        
        # Write back with proper formatting
        with open(notebook_path, 'w', encoding='utf-8') as f:
            json.dump(nb, f, indent=1, ensure_ascii=False)
        
        print(f"✅ Fixed: {notebook_path}")
        return True
        
    except Exception as e:
        print(f"❌ Error fixing {notebook_path}: {e}")
        return False

def main():
    print("=" * 60)
    print("Fixing Jupyter Notebook Metadata for GitHub Rendering")
    print("=" * 60)
    
    notebooks = [
        'Llama3_2_VHDL_2.ipynb',
        'inferenceUnsloth.ipynb'
    ]
    
    fixed_count = 0
    for notebook in notebooks:
        print(f"\nProcessing: {notebook}")
        if fix_notebook_metadata(notebook):
            fixed_count += 1
    
    print("\n" + "=" * 60)
    print(f"✅ Successfully fixed {fixed_count}/{len(notebooks)} notebooks!")
    print("=" * 60)
    print("\nNext steps:")
    print("1. git add *.ipynb")
    print("2. git commit -m 'Fix notebook metadata for GitHub rendering'")
    print("3. git push")

if __name__ == "__main__":
    main()
