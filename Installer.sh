#!/bin/bash

: ' CREATIVE COMMONS CORPORATION IS NOT A LAW FIRM AND DOES NOT PROVIDE
    LEGAL SERVICES. DISTRIBUTION OF THIS DOCUMENT DOES NOT CREATE AN
    ATTORNEY-CLIENT RELATIONSHIP. CREATIVE COMMONS PROVIDES THIS
    INFORMATION ON AN "AS-IS" BASIS. CREATIVE COMMONS MAKES NO WARRANTIES
    REGARDING THE USE OF THIS DOCUMENT OR THE INFORMATION OR WORKS
    PROVIDED HEREUNDER, AND DISCLAIMS LIABILITY FOR DAMAGES RESULTING FROM
    THE USE OF THIS DOCUMENT OR THE INFORMATION OR WORKS PROVIDED
    HEREUNDER. '

set -euo pipefail

DEPENDENCIES=("curl" "unzip" "tar" "jq")
JDK_URL="https://cdn.azul.com/zulu/bin/zulu8.72.0.17-ca-fx-jdk8.0.382-win_x64.zip"
JDK_ZIP="$(pwd)/$(basename "$JDK_URL")"
JDK_DIR="${JDK_ZIP%.zip}"

echo "Augustus Installer"

echo "Checking for required dependencies..."
for dependency in "${DEPENDENCIES[@]}"; do
    if ! command -v "$dependency" &> /dev/null; then
        echo "$dependency is not installed. Please install it and try again."
        exit 1
    fi
done

WINE_URL="$(curl -fsSL https://api.github.com/repos/GloriousEggroll/wine-ge-custom/releases/latest | jq -r '.assets[] | select(.name | test("x86_64.tar.xz$")) | .browser_download_url' || true)"
if [[ -z "$WINE_URL" || "$WINE_URL" == "null" ]]; then
    echo "Error: Failed to determine the Wine-GE download URL. Check your network connection and try again later."
    exit 1
fi
WINE_TAR="$(pwd)/$(basename "$WINE_URL")"
WINE_DIR="$(pwd)/$(basename "$WINE_URL" | sed 's/^wine-//;s/\.tar\.xz$//')"

download_and_extract() {
    local url=$1
    local output_file=$2
    local extract_cmd=$3

    echo "Downloading from $url..."
    if ! curl -fLo "$output_file" "$url"; then
        echo "Error: Failed to download $url"
        exit 1
    fi

    echo "Extracting $output_file..."
    if ! $extract_cmd "$output_file" &> /dev/null; then
        echo "Failed to extract $output_file"
        exit 1
    fi
    rm "$output_file"
}

download_and_extract "$JDK_URL" "$JDK_ZIP" "unzip -qq"
download_and_extract "$WINE_URL" "$WINE_TAR" "tar -xf"

echo "Creating launch script..."
printf '#!/bin/bash\nexec "%s/bin/wine" "%s/bin/javaw.exe" -jar "%s/Launcher.jar"\n' "$WINE_DIR" "$JDK_DIR" "$(pwd)" > Launcher.sh
chmod +x Launcher.sh

echo "All done! Download the Augustus .jar Launcher (the alternative download) and place it here!"
