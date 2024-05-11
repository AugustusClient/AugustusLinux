#!/bin/bash

WHITELISTED_FILES=("LICENSE" "README.md" "Installer.sh" "Uninstaller.sh")

printf "WARNING! THIS SCRIPT WILL REMOVE ALL FILES FROM THIS DIRECTORY ($(pwd)).\nDO YOU WANT TO PROCEED? [y/n]: "
read -r warn 
if [[ ! $warn ]]; then
  exit 1;
fi
warn="${warn,,}"
if [[ $warn = "y" ]]; then
  for file in *; do 
    if [[ ! "${WHITELISTED_FILES[@]}" =~ "$file" ]]; then
      rm -rf "$file"
    fi 
  done
fi
