#!/bin/bash

set -euo pipefail

WHITELISTED_FILES=("LICENSE" "README.md" "Installer.sh" "Uninstaller.sh")

printf 'WARNING! THIS SCRIPT WILL REMOVE ALL FILES FROM THIS DIRECTORY (%s).\nDO YOU WANT TO PROCEED? [y/n]: ' "$(pwd)"
read -r warn
case "$warn" in
    [Yy]) ;;
    *)
        echo "Aborted."
        exit 1
        ;;
esac

for file in *; do
    keep=0
    for whitelisted in "${WHITELISTED_FILES[@]}"; do
        if [[ "$file" == "$whitelisted" ]]; then
            keep=1
            break
        fi
    done
    if [[ $keep -eq 0 ]]; then
        rm -rf "$file"
    fi
done
