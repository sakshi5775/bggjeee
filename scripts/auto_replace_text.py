#!/usr/bin/env python3
"""
Auto Text Replacement Script
Replaces Text( with AutoTranslateText( in Dart files

Usage:
    python scripts/auto_replace_text.py

Note: Review changes before committing!
"""

import os
import re
from pathlib import Path

def should_skip_line(line):
    """Check if line should be skipped (user input, dynamic content)"""
    skip_patterns = [
        r'TextField',
        r'TextFormField',
        r'Text\(.*\.toString\(\)',
        r'Text\(.*DateFormat',
        r'Text\(.*controller\.',
        r'Text\(.*product\.',
        r'Text\(.*category\.',
        r'Text\(.*address\.',
        r'Text\(.*order\.',
        r'Text\(.*user\.',
        r'Text\(.*\$\{',  # String interpolation
    ]
    for pattern in skip_patterns:
        if re.search(pattern, line):
            return True
    return False

def process_file(file_path):
    """Process a single Dart file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            original_content = content
        
        # Check if AutoTranslateText is already imported
        has_import = 'auto_translate_text.dart' in content
        
        # Replace Text( with AutoTranslateText( (but not if it's already AutoTranslateText)
        lines = content.split('\n')
        modified = False
        new_lines = []
        
        for line in lines:
            original_line = line
            # Skip if already AutoTranslateText
            if 'AutoTranslateText(' in line:
                new_lines.append(line)
                continue
            
            # Skip user input and dynamic content
            if should_skip_line(line):
                new_lines.append(line)
                continue
            
            # Replace Text( with AutoTranslateText(
            if re.search(r'\bText\s*\(', line) and not re.search(r'TextField|TextFormField', line):
                line = re.sub(r'\bText\s*\(', 'AutoTranslateText(', line)
                modified = True
            
            new_lines.append(line)
        
        if modified:
            content = '\n'.join(new_lines)
            
            # Add import if needed
            if not has_import and modified:
                # Find the last import statement
                import_pattern = r"(import\s+['\"].*['\"];)"
                imports = list(re.finditer(import_pattern, content))
                if imports:
                    last_import = imports[-1]
                    insert_pos = last_import.end()
                    import_line = "\nimport 'package:astrobharataiuser/widgets/auto_translate_text.dart';"
                    content = content[:insert_pos] + import_line + content[insert_pos:]
            
            return content, True
        
        return original_content, False
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return None, False

def main():
    """Main function"""
    print("=== Auto Text Replacement Script ===")
    print("This script replaces Text( with AutoTranslateText( in Dart files")
    print("Review all changes before committing!\n")
    
    # Get all Dart files in lib/screens
    screens_dir = Path('lib/screens')
    dart_files = list(screens_dir.rglob('*.dart'))
    
    print(f"Found {len(dart_files)} Dart files in lib/screens/")
    print("\nProcessing files...\n")
    
    modified_count = 0
    for file_path in dart_files:
        new_content, was_modified = process_file(file_path)
        if was_modified:
            print(f"Modified: {file_path}")
            # Uncomment to actually write changes:
            # with open(file_path, 'w', encoding='utf-8') as f:
            #     f.write(new_content)
            modified_count += 1
    
    print(f"\n=== Summary ===")
    print(f"Files that would be modified: {modified_count}")
    print(f"\n⚠️  IMPORTANT: Uncomment the write line in the script to actually apply changes!")
    print("Review all changes before committing!")

if __name__ == '__main__':
    main()










