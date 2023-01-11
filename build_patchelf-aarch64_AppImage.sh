#!/bin/bash
##
# build patchelf.AppImage for Python by appimagetool and patchelf
# clean after build: git clean -dxf
## 
set -euo pipefail

cd $(dirname ${BASH_SOURCE[0]})
SHELL_FOLDER=$(pwd)

echo "download [appimagetool](https://github.com/AppImage/AppImageKit)"
FILE_APPIMAGETOOL=appimagetool-aarch64.AppImage
VERSION_APPIMAGETOOL=13
BASE_URL_APPIMAGETOOL=https://github.com/AppImage/AppImageKit/releases/download
if [ ! -f $FILE_APPIMAGETOOL ]; then
    wget $BASE_URL_APPIMAGETOOL/$VERSION_APPIMAGETOOL/$FILE_APPIMAGETOOL
else 
    md5sum $FILE_APPIMAGETOOL
fi
chmod +x $FILE_APPIMAGETOOL

echo "download [patchelf](https://github.com/NixOS/patchelf)"
FILE_PATCHELF=patchelf-0.15.0-aarch64.tar.gz
VERSION_PATCHELF=0.15.0
BASE_URL_PATCHELF=https://github.com/NixOS/patchelf/releases/download
if [ ! -f $FILE_PATCHELF ]; then
    wget $BASE_URL_PATCHELF/$VERSION_PATCHELF/$FILE_PATCHELF
else
    md5sum $FILE_PATCHELF
fi

echo "clean output directory and files after build"
rm -rf AppDir/usr
rm -f AppDir/AppRun AppDir/.DirIcon
rm -f patchelf-aarch64.AppImage

echo "Prepare build materials"
mkdir AppDir/usr
tar zxvf $FILE_PATCHELF -C AppDir/usr/

cd AppDir
ln -s usr/bin/patchelf AppRun
ln -s patchelf.png .DirIcon

echo "build patchelf.AppImage"
cd $SHELL_FOLDER
./appimagetool-aarch64.AppImage AppDir

ls -alh AppDir
echo "PATCHELF_APPIMAGE=$(ls patchelf-*.AppImage)"
