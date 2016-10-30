#!/bin/bash
#
# ESP8266 C SDK project creation template
# Copyright (C) 2016 Sven Gregori
#
# Sets up a basic project structure to use the ESP8266 native C SDK on either
# command line or Eclipse (well, it gives instructions for that, not really
# setting up anything for that).
#
# Usage: ./mkproject.sh /path/to/project/destination
#
# Note, the script requires $ESP_SDK_ROOT environment variable to be set to
# the esp-open-sdk toolchain main directory!
#

SCRIPT_PATH=$(readlink -f $0)
SCRIPT_DIR=$(dirname $SCRIPT_PATH)
TEMPLATE_DIR="${SCRIPT_DIR}/template/"

if [ $# -lt 1 ] ; then
    echo "usage: $0 /path/to/project"
    exit 1
fi

TARGET="$1"

if [ -z "$ESP_SDK_ROOT" ] ; then
    echo "ESP_SDK_ROOT env variable not set, please source setenv.sh first."
    exit 1
fi

if [ ! -d "$ESP_SDK_ROOT" ] ; then
    echo "\$ESP_SDK_ROOT env variable doesn't point to an existing directory."
    echo "Check setenv.sh and adjust SDK base directory accordingly."
    exit 1
fi

if [ -e $TARGET ] ; then
    echo "Target dir '$TARGET' already exists, not gonna touch that."
    exit 1
fi

mkdir -p $TARGET
mkdir ${TARGET}/user
mkdir ${TARGET}/driver
touch ${TARGET}/user/user_config.h
#cp ${TEMPLATE_DIR}/Makefile $TARGET
sed s/{ESP_SDK_ROOT}/$(echo $ESP_SDK_ROOT | sed 's/[\/&]/\\&/g')/g ${TEMPLATE_DIR}/Makefile > ${TARGET}/Makefile
cp ${TEMPLATE_DIR}/main.c ${TARGET}/user

cat << EOF
Project template successfully created.

To create an Eclipse project:
    1: File -> New -> C Project
    2: Select "Empty project" and "Cross GCC"
    3: Next, Next
    4: Cross compiler setup.
        Prefix: xtensa-lx106-elf-
        Path: $ESP_SDK_ROOT/xtensa-lx106-elf/bin
    5: Finish
    6: Go to project properties, "C/C++ Build", "Builder Settings" tab:
        untick "Generate Makefile automatically"
        Adjust build directory
    7: copy the files (this might be improved..?)

To create a command line project:
    1: source setenv,sh
    2: edit files and compile with make

EOF

