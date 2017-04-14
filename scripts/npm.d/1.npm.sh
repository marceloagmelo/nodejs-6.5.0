#!/bin/bash

pushd $APP_HOME> /dev/null
npm $@
popd > /dev/null
