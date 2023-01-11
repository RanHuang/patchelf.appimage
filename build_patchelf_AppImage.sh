#!/bin/bash
##
# build patchelf.AppImage for Python by appimagetool and patchelf
# clean after build: git clean -dxf
## 
set -euo pipefail

cd $(dirname ${BASH_SOURCE[0]})
SHELL_FOLDER=$(pwd)

ARCH=$(uname -i)
echo -e "CPU Archicture: \033[32m$ARCH\033[0m"

echo "download [appimagetool](https://github.com/AppImage/AppImageKit)"
FILE_APPIMAGETOOL=appimagetool-$ARCH.AppImage
VERSION_APPIMAGETOOL=13
BASE_URL_APPIMAGETOOL=https://github.com/AppImage/AppImageKit/releases/download
if [ ! -f $FILE_APPIMAGETOOL ]; then
    wget $BASE_URL_APPIMAGETOOL/$VERSION_APPIMAGETOOL/$FILE_APPIMAGETOOL
else 
    md5sum $FILE_APPIMAGETOOL
fi
chmod +x $FILE_APPIMAGETOOL

echo "download [patchelf](https://github.com/NixOS/patchelf)"
VERSION_PATCHELF=0.15.0
FILE_PATCHELF=patchelf-$VERSION_PATCHELF-$ARCH.tar.gz
BASE_URL_PATCHELF=https://github.com/NixOS/patchelf/releases/download
if [ ! -f $FILE_PATCHELF ]; then
    wget $BASE_URL_PATCHELF/$VERSION_PATCHELF/$FILE_PATCHELF
else
    md5sum $FILE_PATCHELF
fi

echo "clean output directory and files after build"
rm -rf AppDir/usr
rm -f AppDir/AppRun AppDir/.DirIcon
rm -f patchelf-$ARCH.AppImage

echo "Prepare build materials"
mkdir AppDir/usr
tar zxvf $FILE_PATCHELF -C AppDir/usr/

cd AppDir
ln -s usr/bin/patchelf AppRun
ln -s patchelf.png .DirIcon

echo "build patchelf.AppImage"
cd $SHELL_FOLDER
./appimagetool-$ARCH.AppImage AppDir

ls -alh AppDir
echo "PATCHELF_APPIMAGE=$(ls patchelf-*.AppImage)"
