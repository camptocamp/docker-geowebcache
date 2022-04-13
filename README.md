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

This image uses two volumes:
 * The first one is `/mnt/geowebcache_datadir` which hosts the `geowebcache.xml` config file. A default one will be created at startup if empty.
 * The second one is `/mnt/geowebcache_tiles` where the tile cache resides.

```bash
mkdir -p $HOME/data/

# launch the container.
docker run --rm -d --name geowebcache \
    -v $HOME/data/geowebcache_datadir:/mnt/geowebcache_datadir \
    -v $HOME/data/geowebcache_tiles:/mnt/geowebcache_tiles \
    -p 8600:8080 \
    camptocamp/geowebcache
```
