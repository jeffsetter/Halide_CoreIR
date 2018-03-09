#!/bin/bash

HALIDE_PATH="Halide_CoreIR"
MAPPER_PATH="CGRAMapper"

if [ ! -d ${HALIDE_PATH} ]; then
    echo "Specified Halide path does not exist."
    exit 1
fi
if [ ! -d ${MAPPER_PATH} ]; then
    echo "Specified mapper path does not exist."
    exit 1
fi

#make -C ${HALIDE_PATH}/apps/coreir_tests cleanall 
make -C ${HALIDE_PATH}/apps/coreir_tests test_all && echo "Completed creating json tests"
#make -C ${HALIDE_PATH}/apps/coreir_examples cleanall 
make -C ${HALIDE_PATH}/apps/coreir_examples test_all && echo "Completed creating json apps"


APPS=${HALIDE_PATH}/apps/coreir_examples/*
echo $APPS

for app in $APPS
do
if [[ -f "${app}/design_prepass.json" ]]; then
    appname=`basename $app`
    echo "copied json from $appname"
    cp ${app}/design_prepass.json ${MAPPER_PATH}/examples/${appname}.json
else
    appname=`basename $app`
    echo "$appname does not have a json"
fi
done
TESTS=${HALIDE_PATH}/apps/coreir_tests/*
echo $TESTS

for app in $TESTS
do
if [[ -f "${app}/design_prepass.json" ]]; then
    appname=`basename $app`
    echo "copied json from $appname"
    cp ${app}/design_prepass.json ${MAPPER_PATH}/examples/${appname}.json
else
    appname=`basename $app`
    echo "$appname does not have a json"
fi
done
