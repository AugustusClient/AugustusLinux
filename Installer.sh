#!/bin/bash

: ' CREATIVE COMMONS CORPORATION IS NOT A LAW FIRM AND DOES NOT PROVIDE
    LEGAL SERVICES. DISTRIBUTION OF THIS DOCUMENT DOES NOT CREATE AN
    ATTORNEY-CLIENT RELATIONSHIP. CREATIVE COMMONS PROVIDES THIS
    INFORMATION ON AN "AS-IS" BASIS. CREATIVE COMMONS MAKES NO WARRANTIES
    REGARDING THE USE OF THIS DOCUMENT OR THE INFORMATION OR WORKS
    PROVIDED HEREUNDER, AND DISCLAIMS LIABILITY FOR DAMAGES RESULTING FROM
    THE USE OF THIS DOCUMENT OR THE INFORMATION OR WORKS PROVIDED
    HEREUNDER. '

DEPENDENCIES=("wget" "unzip" "curl" "jq")
JDK_URL="https://cdn.azul.com/zulu/bin/zulu8.72.0.17-ca-fx-jdk8.0.382-win_x64.zip"
JDK_ZIP="$(pwd)/$(basename "$JDK_URL")"
JDK_DIR="${JDK_ZIP%.zip}"

WINE_URL=$(curl -s -q https://api.github.com/repos/GloriousEggroll/wine-ge-custom/releases/latest | jq -r '.assets[] | select(.name | test("x86_64.tar.xz$")) | .browser_download_url')
WINE_TAR="$(pwd)/$(basename "$WINE_URL")"
WINE_DIR="${WINE_TAR%.tar.xz}"

echo "Augustus Installer"
sleep 1

echo "Checking for required dependencies..."
for dependency in "${DEPENDENCIES[@]}"; do
    if ! command -v "$dependency" &> /dev/null; then
        echo "$dependency is not installed. Please install it and try again."
        exit 1
    fi
done
sleep 1

download_and_extract() {
    local url=$1
    local output_zip=$2
    local output_dir=$3
    local extract_cmd=$4

    echo "Downloading from $url..."
    wget -nv "$url" -O "$output_zip"
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to download $url"
        exit 1
    fi
    sleep 1

    echo "Extracting $output_zip..."
    $extract_cmd "$output_zip" &> /dev/null
    if [[ $? -ne 0 ]]; then
        echo "Failed to extract $output_zip"
        exit 1
    fi
    rm "$output_zip"
    sleep 1
}

download_and_extract "$JDK_URL" "$JDK_ZIP" "$JDK_DIR" "unzip -qq"
download_and_extract "$WINE_URL" "$WINE_TAR" "$WINE_DIR" "tar -xf"

echo "Creating launch script..."
echo "$WINE_DIR/bin/wine $JDK_DIR/bin/javaw.exe -jar $(pwd)/Launcher.jar" > Launcher.sh
chmod +x Launcher.sh

echo "All done! Download the Augustus .jar Launcher (the alternative download) and place it here!"
