#!/bin/bash
dpn=("wget" "unzip")
jdkurl="https://cdn.azul.com/zulu/bin/zulu8.72.0.17-ca-fx-jdk8.0.382-win_x64.zip"
jdkzip=${jdkurl//"https://cdn.azul.com/zulu/bin/"/}
jdkfp=${jdkzip//".zip"/}
wineurl="https://github.com/GloriousEggroll/wine-ge-custom/releases/download/GE-Proton8-17/wine-lutris-GE-Proton8-17-x86_64.tar.xz"
winetar=${wineurl//"https://github.com/GloriousEggroll/wine-ge-custom/releases/download/GE-Proton8-17/"}
winefp=${winetar//"wine-"/}; winefp=${winefp//".tar.xz"/}

echo "Augustus Linux Installer" 
sleep 1

echo "Checking for wget and unzip..."

for dependency in "${dpn[@]}"; do
	if [ ! -f "/usr/bin/$dependency" ]; then
		echo "$dependency is not installed!"
	fi
done
sleep 3

echo "Downloading AzulJDK..."
wget -nv $jdkurl 
sleep 3

echo "Unzipping AzulJDK..."
unzip -qq $jdkzip
rm $jdkzip
sleep 3

echo "Downloading WineGE..."
wget -nv $wineurl
sleep 3

echo "Unpacking WineGE..."
tar -xf $winetar
rm $winetar
sleep 3

echo "Making Launch script..."
echo "$winefp/bin/wine $jdkfp/bin/javaw.exe -jar Launcher.jar" > Launcher.sh
sleep 1

echo "All done! Download the Augustus .jar Launcher (the alternative download) and place it here!"
