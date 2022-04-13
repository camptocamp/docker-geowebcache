# Docker image for GeoWebCache

A docker image that runs GeoWebCache version 1.20.1

## To run

```bash
cd docker-webcache
make build
docker run -p 8600:8080 camptocamp/geowebcache:latest
```

Visit http://localhost:8600/geowebcache

## Configuration and persistence

This image use two volumes, you may mount them somewhere when using it for production.

The first one is `/mnt/geowebcache_datadir` where you may want to give a custom `geowebcache.xml` file.
If there is no geowebcache.xml file, a example one will be created at startup.

The second one is `/mnt/geowebcache_tiles` where will be store the cache.

```bash

mkdir -p $HOME/data/

# launch the container.
docker run --rm -d --name geowebcache \
    -v $HOME/data/geowebcache_datadir:/mnt/geowebcache_datadir \
    -v $HOME/data/geowebcache_tiles:/mnt/geowebcache_tiles \
    -p 8600:8080 \
    camptocamp/geowebcache
```
