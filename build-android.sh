#!/bin/bash
# This is a simple script to make xgboost in MAC and Linux
# Basically, it first try to make with OpenMP, if fails, disable OpenMP and make it again.
# This will automatically make xgboost for MAC users who don't have OpenMP support.
# In most cases, type make will give what you want.

# See additional instruction in doc/build.md

set -a

function init(){
    NDK=${NDK:-$ANDROID_NDK_HOME}
    # For ABI options see https://developer.android.com/ndk/guides/standalone_toolchain.html#syt
    ABI=arm-linux-androideabi
    # ABI=x86
    # ABI=mipsel-linux-android
    # ABI=aarch64-linux-android
    # ABI=x86_64
    # ABI=mips64el-linux-android
    GCC_VERSION=4.6
    ABI_CC=$ABI-$GCC_VERSION

    # For platform version see https://source.android.com/source/build-numbers.html
    PLATFORM=android-9

    MYTOOLCHAIN_PATH=/tmp/tc-$ABI
}

function setup(){
    init
    setup_toolchain
}

function setup_toolchain(){
    echo "setup_toolchain..."
    $NDK/build/tools/make-standalone-toolchain.sh --verbose \
    --toolchain=$ABI_CC \
    --platform=$PLATFORM \
    --install-dir=$MYTOOLCHAIN_PATH \
    --force
}

function clean(){
    make clean
    cd dmlc-core; make clean; cd -
    cd rabit; make clean; cd -
}

function build_lib(){
    echo "build_lib..."
    export PATH=$MYTOOLCHAIN_PATH/bin:$PATH
    export CC="$ABI-gcc"
    export CXX="$ABI-g++"
    export AR="$ABI-ar"
    cp make/android-armv7a.mk config.mk
    clean
    make -j 4 lib/libxgboost.so
}

function build_java(){
    echo "build_lib..."
    export PATH=$MYTOOLCHAIN_PATH/bin:$PATH
    export CC="$ABI-gcc"
    export CXX="$ABI-g++"
    export AR="$ABI-ar"

    cd jvm-packages/
    ./create_jni.sh
    cd -
}

function build(){
    build_lib && build_java
}

init
if setup && build; then
    echo "Successfully build android xgboost"
fi
