#-----------------------------------------------------------
# xgboost: Configuration for MinGW(Windows 64bit)
# This allows to compile xgboost on windows by using mingw.
# You will need to get install an mingw toolchain.
# g++-4.6 or later is required.
#
# see config.mk for template.
#-----------------------------------------------------------
#export PATH="/tmp/my-android-toolchain/bin:$PATH"

# Whether enable openmp support, needed for multi-threading.
USE_OPENMP = 0

# whether use HDFS support during compile
USE_HDFS = 0

# whether use AWS S3 support during compile
USE_S3 = 0

# whether use Azure blob support during compile
USE_AZURE = 0

# Rabit library version,
# - librabit.a Normal distributed version.
# - librabit_empty.a Non distributed mock version,
LIB_RABIT = librabit_empty.a

ADD_CFLAGS = -DDMLC_ENABLE_STD_THREAD=0

# NOTE: Remove for other architectures.
# TODO: Add a conditional directive to add flags based on architecture.
# armv7a flags
ADD_LDFLAGS += -march=armv7-a -Wl,--fix-cortex-a8
ADD_CFLAGS += -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16 -mthumb

DMLC_CFLAGS = $(ADD_CFLAGS)
DMLC_LDFLAGS = $(ADD_LDFLAGS)
