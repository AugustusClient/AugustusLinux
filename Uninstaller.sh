#!/bin/bash

WHITELISTED_FILES=("LICENSE" "README.md" "Installer.sh" "Uninstaller.sh")

for file in *; do 
  if [[ ! "${WHITELISTED_FILES[@]}" =~ "$file" ]]; then
    rm -rf "$file"
  fi 
done
