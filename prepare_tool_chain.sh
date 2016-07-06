#/bin/bash
export PATH="/home/csegura/Android/Sdk/ndk-bundle/:${PATH}"



/home/csegura/Android/Sdk/ndk-bundle/build/tools/make-standalone-toolchain.sh --platform=android-12 --install-dir=/tmp/my-android-toolchain
cd /tmp/my-android-toolchain


export PATH=/tmp/my-android-toolchain/bin:$PATH
export CC="arm-linux-androideabi-gcc"
export CXX="arm-linux-androideabi-g++"