#!/usr/bin/env python3
"""
Add AutoTranslateText import to all Dart files
This script adds the import statement to all Dart files that don't have it
"""

import os
import re
from pathlib import Path

def has_import(content):
    """Check if file already has the import"""
    return 'auto_translate_text.dart' in content

def add_import(content):
    """Add the import statement after Flutter imports"""
    import_line = "import 'package:astrobharataiuser/widgets/auto_translate_text.dart';"
    
    # If already has import, return unchanged
    if has_import(content):
        return content, False
    
    # Find the last import statement
    lines = content.split('\n')
    last_import_index = -1
    
    for i, line in enumerate(lines):
        if re.match(r'^\s*import\s+', line):
            last_import_index = i
    
    # If no imports found, add at the top
    if last_import_index == -1:
        # Find first non-comment line
        for i, line in enumerate(lines):
            if line.strip() and not line.strip().startswith('//'):
                lines.insert(i, import_line)
                return '\n'.join(lines), True
        # If all comments, add at beginning
        lines.insert(0, import_line)
        return '\n'.join(lines), True
    
    # Add after last import
    lines.insert(last_import_index + 1, import_line)
    return '\n'.join(lines), True

def process_file(file_path):
    """Process a single Dart file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        new_content, was_modified = add_import(content)
        
        if was_modified:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(new_content)
            return True
        return False
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return False

def main():
    """Main function"""
    print("=== Adding AutoTranslateText Import to All Dart Files ===\n")
    
    # Get all Dart files in lib directory
    lib_dir = Path('lib')
    dart_files = list(lib_dir.rglob('*.dart'))
    
    print(f"Found {len(dart_files)} Dart files")
    print("Processing files...\n")
    
    modified_count = 0
    skipped_count = 0
    
    for file_path in dart_files:
        # Skip the auto_translate_text.dart file itself
        if 'auto_translate_text.dart' in str(file_path):
            skipped_count += 1
            continue
            
        was_modified = process_file(file_path)
        if was_modified:
            print(f"✅ Added import to: {file_path}")
            modified_count += 1
        else:
            skipped_count += 1
    
    print(f"\n=== Summary ===")
    print(f"Files modified: {modified_count}")
    print(f"Files skipped (already has import or auto_translate_text.dart): {skipped_count}")
    print(f"Total files: {len(dart_files)}")
    print(f"\n✅ Import added to all Dart files!")

if __name__ == '__main__':
    main()










