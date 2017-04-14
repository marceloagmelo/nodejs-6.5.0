# Docker image for NodeJS (v6.5.0) Microservice

This image is based on CentOS 7 Image.
The image exposes the port 8080 and the node process is executed by the "nodejs" user.
All the componentes write logs entries to the standard output and standard error.

### How to download the image

docker pull marceloagmelo/nodejs-6.5.0:latest

### How to use image

The image contains a control.sh script, this script has several operations.

#### help

docker run --rm -ti marceloagmelo/nodejs-6.5.0:latest help

```
=============================================================================   
USAGE: ./control.sh COMMAND [args]                                              
  Command list:                                                                 
    - info        : execute info scripts                                        
    - shell       : execute shell scripts                                       
    - start       : execute start scripts                                       
    - status      : execute status scripts                                      
    - test        : execute test scripts 
    - node        : JavaScript runtime built on Chrome's V8 JavaScript engine                                  
    - npm         : Package manager for JavaScript                            
    
=============================================================================
```


#### info

The info operation shows only image's metadafa information.

docker run --rm -ti marceloagmelo/nodejs-6.5.0:latest info

#### shell

This operation starts the /bin/bash shell
```
docker run --rm -ti marceloagmelo/nodejs-6.5.0:latest shell
```

#### start

The start operation initialize the node process by running `npm install && npm start` in the /opt/app directory. If no application files are found the start operation will use the default application, this application can be used for testing.

```
docker run -d -p 0.0.0.0:8080:8080 marceloagmelo/nodejs-6.5.0:latest start
```

In this example the default application is executed.

> NOTE: In the Environment Variables section we will see all the environment variables available. In order to change the process behaviour we have to configure some environment variable when the container/pod is started.

#### status

The status operation shows information about the running proccess

docker run --rm -ti marceloagmelo/nodejs-6.5.0:latest status


#### npm

The npm operation runs a wrapper to npm command.

docker run --rm -ti marceloagmelo/nodejs-6.5.0:latest npm

#### node

The node operation runs a wrapper to node command.

docker run --rm -ti marceloagmelo/nodejs-6.5.0:latest node



#### Environment Variables



APP_HOME

        Default path where we are deploying our  nodejs default application.

NPM_REGISTRY

	The JavaScripts Package Registry. By default we use "https://nexus.ci.gsnet.corp/nexus/content/groups/npm-all/".

NPM_LOGLEVEL

	Default info.

NODE_ENV

	Defatult value "production".

NODE_PATH

	If you artifact have the below structure you must fill up with "sample-nodejs-master".

	artifact.zip
	       ├──package
		     ├──package.json
		     ├──app.js

ARTIFACT_URL

	This docker image is able to download an artifact from any https/http web server, the articaft can be zip/tar (We recomend tar file to avoid issues with long paths).

```
docker run  -e ARTIFACT_URL="https://github.com/dcortesf/sample-nodejs/archive/master.zip" -e http_proxy="http://fqdn:port" -e https_proxy="http://fqdn:port" -e no_proxy=.corp -e NPM_REGISTRY="https://registry.npmjs.org/" -e NPM_CONFIG_LEVEL=debug -e NODE_ENV=production -e EPAGENT="http://fqdn:port" -p marceloagmelo/nodejs-6.5.0:latest start
```

## How to create new images from NodeJS imagen

In this example we will create new nodejs application using produban-br/nodejs-6.5.0:latest as the base image.

Dockerfile

```
FROM marceloagmelo/nodejs-6.5.0:latest
ADD myapp.zip /opt/app
```

```
docker build .
```

** Please ensure that you only add production dependencies to you package or your image **: You can achieve this
by running `npm prune --production` before generating the package or the image.

## Time Zone
By default this image uses the time zone "Europe/Madrid", if you want to change the default time zone, you should specify the environment variable TZ.