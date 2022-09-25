#! /bin/sh

# TODO - build this into the makefile
set -xe

BUILD_DIR=../build
SCHEMATICS_DIR=../schematics
SRC_DIR=../rtl

if [[ ! -e $BUILD_DIR ]]; then
    mkdir $BUILD_DIR
fi

if [[ ! -e $SCHEMATICS_DIR ]]; then
    mkdir $SCHEMATICS_DIR
fi

for SRC_FILE in $SRC_DIR/*.sv ; do
    MODULE=$(basename -s .sv $SRC_FILE)
    PREP_FILE=$BUILD_DIR/$MODULE.prep.json
    SVG=$SCHEMATICS_DIR/$MODULE.prep.svg
    yosys -q -p "read_verilog -sv -DSIMULATION $SRC_DIR/*.sv; prep -top $MODULE; write_json $PREP_FILE" $SRC_DIR/*.sv
    netlistsvg $PREP_FILE -o $SVG 
done

set +xe