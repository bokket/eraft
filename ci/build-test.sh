#!/bin/bash

set -xe

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
SRCPATH=$(cd $SCRIPTPATH/..; pwd -P)
NPROC=$(nproc || grep -c ^processor /proc/cpuinfo)

if [ -d "$SRCPATH/Protocol" ]; then
  cd "$SRCPATH/Protocol"
  ./scripts/generate_cpp.sh
  cd -
fi

build_dir="$SRCPATH/build"
mkdir -p $build_dir && cd $build_dir
cmake "$SRCPATH" \
    -DENABLE_TESTS=on
make -j 2

if [ ! -d "$SRCPATH/output" ]; then
  mkdir $SRCPATH/output
  mkdir $SRCPATH/output/logs
fi

cp $build_dir/Logger/test/LoggerTests $SRCPATH/output

# run test
$build_dir/Logger/test/LoggerTests
