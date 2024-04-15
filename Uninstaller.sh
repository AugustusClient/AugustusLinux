#!/bin/bash

WHITELISTED_FILES=("LICENSE" "README.md" "Installer.sh" "Uninstaller.sh")

printf "WARNING! THIS SCRIPT WILL REMOVE ALL FILES FROM THIS DIRECTORY ($(pwd)).\nDO YOU WANT TO PROCEED? [y/n]: "
read warn 

if [[ $(echo "$warn" | awk '{print tolower($0)}') = "y" ]]; then
  for file in *; do 
    if [[ ! "${WHITELISTED_FILES[@]}" =~ "$file" ]]; then
      rm -rf "$file"
    fi 
  done
fi
