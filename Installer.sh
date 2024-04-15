#!/bin/bash

: ' CREATIVE COMMONS CORPORATION IS NOT A LAW FIRM AND DOES NOT PROVIDE
    LEGAL SERVICES. DISTRIBUTION OF THIS DOCUMENT DOES NOT CREATE AN
    ATTORNEY-CLIENT RELATIONSHIP. CREATIVE COMMONS PROVIDES THIS
    INFORMATION ON AN "AS-IS" BASIS. CREATIVE COMMONS MAKES NO WARRANTIES
    REGARDING THE USE OF THIS DOCUMENT OR THE INFORMATION OR WORKS
    PROVIDED HEREUNDER, AND DISCLAIMS LIABILITY FOR DAMAGES RESULTING FROM
    THE USE OF THIS DOCUMENT OR THE INFORMATION OR WORKS PROVIDED
    HEREUNDER. '

# Augustus Launcher for Linux

dpn=("wget" "unzip" "curl" "jq")
jdkurl="https://cdn.azul.com/zulu/bin/zulu8.72.0.17-ca-fx-jdk8.0.382-win_x64.zip"
jdkzip="$(pwd)/$(basename "$jdkurl")"
jdkfp=${jdkzip//".zip"/}

wineurl=$(curl -s -q https://api.github.com/repos/GloriousEggroll/wine-ge-custom/releases/latest | jq -r '.assets[] | select(.name | test("x86_64.tar.xz$")) | .browser_download_url')
winetar="$(pwd)/$(basename "$wineurl")"
winefp=${winetar//"wine-"/}; winefp=${winefp//".tar.xz"/}

echo "Augustus Installer" 
sleep 1

echo "Checking for required dependencies..."

for dependency in "${dpn[@]}"; do
    if ! command -v "$dependency" &> /dev/null; then
        echo "$dependency is not installed!"
    fi
done
sleep 3

echo "Downloading AzulJDK..."
wget -nv "$jdkurl" &> /dev/null
sleep 3

echo "Unzipping AzulJDK..."
unzip -qq "$jdkzip" &> /dev/null
rm "$jdkzip"
sleep 3

echo "Downloading WineGE..."
wget -nv "$wineurl" &> /dev/null
sleep 3

echo "Unpacking WineGE..."
tar -xf "$winetar" &> /dev/null
rm "$winetar"
sleep 3

echo "Making Launch script..."
echo "$winefp/bin/wine $jdkfp/bin/javaw.exe -jar $(pwd)/Launcher.jar" > Launcher.sh
chmod +x Launcher.sh
sleep 1

echo "All done! Download the Augustus .jar Launcher (the alternative download) and place it here!"


