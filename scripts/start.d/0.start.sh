#!/bin/bash

echo "========================================="
echo "Starting application"
echo "========================================="
env | sort

if [ -n $NODE_PATH ]
then
  APP_HOME="$APP_HOME/$NODE_PATH"
fi

  pushd $APP_HOME

if [ ! -d "node_modules" ]
then
  if [ -n "$NPM_REGISTRY" ]
  then
     npm config set strict-ssl false
     npm config set registry $NPM_REGISTRY
  fi
  if [ -n "$NPM_LOGLEVEL" ]
  then
     npm config set loglevel $NPM_LOGLEVEL
  fi

  npm i
fi

echo "Copiando modulos do prometheus"
cp -r $IMAGE_SCRIPTS_HOME/express-prom-bundle $APP_HOME/node_modules

echo "Configurando chamada ao prometheus"
echo '' >> $APP_HOME/app.js
echo 'var promBundle = require("express-prom-bundle");' >> $APP_HOME/app.js
echo '' >> $APP_HOME/app.js
echo 'app.use(promBundle({' >> $APP_HOME/app.js
echo '    prefix: "prometheus:fecbackend"' >> $APP_HOME/app.js
echo '}));' >> $APP_HOME/app.js

echo "Iniciando node..."
exec npm start

popd