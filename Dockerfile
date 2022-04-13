FROM jetty:10-jre11 as builder
MAINTAINER Camptocamp "info@camptocamp.com"

# Latest stable as of april 2022
ENV GEOWEBCACHE_VERSION 1.20
ENV GEOWEBCACHE_MINOR_VERSION 1
ENV XMS=512M XMX=1G
ENV GWC_SEED_RETRY_COUNT 3
ENV GWC_SEED_RETRY_WAIT 100
ENV GWC_SEED_ABORT_LIMIT 1000

USER root

# create dirs
RUN mkdir -p /mnt/geowebcache_datadir /mnt/geowebcache_tiles /tmp/geowebcache
RUN chown jetty:jetty /mnt/geowebcache_datadir /mnt/geowebcache_tiles /tmp/geowebcache

USER jetty

RUN sed -i 's/threads.max=200/threads.max=2000/g' $JETTY_BASE/start.d/server.ini

# Install geowebcache
RUN curl -L https://freefr.dl.sourceforge.net/project/geowebcache/geowebcache/${GEOWEBCACHE_VERSION}.${GEOWEBCACHE_MINOR_VERSION}/geowebcache-${GEOWEBCACHE_VERSION}.${GEOWEBCACHE_MINOR_VERSION}-war.zip > /tmp/geowebcache.zip && \
    unzip -o /tmp/geowebcache.zip -d /tmp/geowebcache && \
    unzip -o /tmp/geowebcache/geowebcache.war -d $JETTY_BASE/webapps/geowebcache && \
    rm -r /tmp/geowebcache*

# the servlets jetty module contains CORS filters
RUN java -jar "$JETTY_HOME/start.jar" --add-module=servlets

# since we are on JDK11 and inside a container, see also option -XX:MaxRAMPercentage instead of Xms/Xmx
ENV JAVA_OPTIONS "-Xms$XMS -Xmx$XMX \
 -DGEOWEBCACHE_CONFIG_DIR=/mnt/geowebcache_datadir \
 -DGEOWEBCACHE_CACHE_DIR=/mnt/geowebcache_tiles \
 -DGWC_SEED_RETRY_COUNT=$GWC_SEED_RETRY_COUNT \
 -DGWC_SEED_RETRY_WAIT=$GWC_SEED_RETRY_WAIT \
 -DGWC_SEED_ABORT_LIMIT=$GWC_SEED_ABORT_LIMIT \
 -Djetty.httpConfig.sendServerVersion=false \
 -XX:-UsePerfData "

USER root

VOLUME [ "/mnt/geowebcache_datadir", "/mnt/geowebcache_tiles", "/tmp" ]
