#!/usr/bin/env bash
echo "build java wrapper"

# cd to script's directory
pushd `dirname $0` > /dev/null

#settings according to os
dl="so"
dis_omp=0

if [ $(uname) == "Darwin" ]; then
    export JAVA_HOME=$(/usr/libexec/java_home)
    if [ $ABI == "" ]; then
        export ABI="darwin"
        dl="dylib"
    fi
    #change this to 0 if your compiler support openmp
    dis_omp=1
fi

cd ..
make jvm no_omp=${dis_omp}
cd jvm-packages
echo "move native lib"

libPath="xgboost4j/src/main/resources/lib"
if [ ! -d "$libPath" ]; then
  mkdir -p "$libPath"
fi

TARGET=$libPath/libxgboost4j.${ABI}.${dl}
SOURCE=lib/libxgboost4j.so

rm -f $TARGET
mv $SOURCE $TARGET
# copy python to native resources
cp ../dmlc-core/tracker/dmlc_tracker/tracker.py xgboost4j/src/main/resources/tracker.py
# copy test data files
mkdir -p xgboost4j-spark/src/test/resources/
cp ../demo/data/agaricus.* xgboost4j-spark/src/test/resources/
popd > /dev/null
echo "complete"
