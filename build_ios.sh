#!/bin/sh

git submodule update --init --recursive

# 'Prepare Python'
python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install jsonschema jinja2

# 'Install Qt'
python3 -m pip install aqtinstall
mkdir -p ./Qt
cd ./Qt
export QT_MIRROR=https://mirrors.ocf.berkeley.edu/qt/
export QT_VERSION=6.8.0

aqt install-qt mac desktop $QT_VERSION clang_64 -m qtremoteobjects qt5compat qtshadertools qtmultimedia
aqt install-qt mac ios $QT_VERSION ios -m qtremoteobjects qt5compat qtshadertools qtmultimedia
cd ..

export QT_BIN_DIR=$(pwd)/Qt/$QT_VERSION/ios/bin
export QT_MACOS_ROOT_DIR=$(pwd)/Qt/$QT_VERSION/macos
export QT_IOS_BIN=$QT_BIN_DIR

# 'Setup Go'
brew install go
export PATH=$PATH:~/go/bin
go install golang.org/x/mobile/cmd/gomobile@latest
gomobile init

# 'Build'
mkdir -p build-ios

# $QT_IOS_BIN/qt-cmake . -B build-ios -GXcode -DQT_HOST_PATH=$QT_MACOS_ROOT_DIR
# sh deploy/build_ios.sh

#        IOS_TRUST_CERT_BASE64: ${{ secrets.IOS_TRUST_CERT_BASE64 }}
#        IOS_SIGNING_CERT_BASE64: ${{ secrets.IOS_SIGNING_CERT_BASE64 }}
#        IOS_SIGNING_CERT_PASSWORD: ${{ secrets.IOS_SIGNING_CERT_PASSWORD }}
#        APPSTORE_CONNECT_KEY_ID: ${{ secrets.APPSTORE_CONNECT_KEY_ID }}
#        APPSTORE_CONNECT_ISSUER_ID: ${{ secrets.APPSTORE_CONNECT_ISSUER_ID }}
#        APPSTORE_CONNECT_PRIVATE_KEY: ${{ secrets.APPSTORE_CONNECT_PRIVATE_KEY }}
#        IOS_APP_PROVISIONING_PROFILE: ${{ secrets.IOS_APP_PROVISIONING_PROFILE }}
#        IOS_NE_PROVISIONING_PROFILE: ${{ secrets.IOS_NE_PROVISIONING_PROFILE }}
