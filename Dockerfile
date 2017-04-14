## Docker Image Base
FROM marceloagmelo/centos7:latest

## Maintainer
MAINTAINER Marcelo Melo <mmelo@produban.com.br> 

USER root

ENV GID 23550
ENV UID 23550 

## ENV NODEJS
ENV NODEJS_TMP /tmp/nodejs
ENV NODE_ENV production
ENV NODEJS_PORT 8080
ENV VCAP_APP_PORT $NODEJS_PORT
ENV NODE_VERSION v6.5.0

RUN mkdir -p $NODEJS_TMP && \
    mkdir -p $IMAGE_SCRIPTS_HOME/express-prom-bundle

ADD app $APP_HOME
COPY Dockerfile $IMAGE_SCRIPTS_HOME/Dockerfile
COPY express-prom-bundle $IMAGE_SCRIPTS_HOME/express-prom-bundle

# NODEJS binaries
COPY bin/node-$NODE_VERSION-linux-x64.tar $NODEJS_TMP

RUN tar -xf $NODEJS_TMP/node-$NODE_VERSION-linux-x64.tar -C /usr/local --strip-components=1 && \
    rm -rf  $NODEJS_TMP/node-$NODE_VERSION-linux-x64.tar

# USER nodejs
RUN groupadd --gid $GID nodejs && useradd --uid $UID -m -g nodejs nodejs

# Scripts
ADD scripts $IMAGE_SCRIPTS_HOME
RUN chown -R nodejs:nodejs $APP_HOME && \
    chown -R nodejs:nodejs $IMAGE_SCRIPTS_HOME

# To modify a hosts
RUN cp /etc/hosts /tmp/hosts && \
    mkdir -p -- /lib-override && cp /lib64/libnss_files.so.2 /lib-override && \
    sed -i 's:/etc/hosts:/tmp/hosts:g' /lib-override/libnss_files.so.2 && \
    chmod 755 /tmp/hosts && \
    chown nodejs:nodejs /tmp/hosts
ENV LD_LIBRARY_PATH /lib-override

#PORT
EXPOSE  $NODEJS_PORT

#######################################################################
##### We have to expose image metada as label and ENV
#######################################################################
LABEL com.produban.imageowner="Corporate Techonology" \
      com.produban.description="NodeJS runtime for node microservices" \
      com.produban.components="NodeJS, NPM, APM Node.js Agent" \
      com.prpoduban.image="marceloagmelo/nodejs-6.5.0:latest"

ENV com.produban.imageowner="Corporate Techonology"
ENV com.produban.description="NodeJS runtime for node microservices"
ENV com.produban.components="NodeJS, NPM, APM Node.js Agent"
ENV com.prpoduban.image="marceloagmelo/nodejs-6.5.0:latest"

USER nodejs

WORKDIR $IMAGE_SCRIPTS_HOME
ENTRYPOINT [ "./control.sh" ]
CMD [ "start" ]