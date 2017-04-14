#!/bin/bash

pushd $APP_HOME > /dev/null
node $@
popd > /dev/null
