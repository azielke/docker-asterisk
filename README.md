# Supported tags
* 19.4.1, 19, latest
* 18.12.1, 18, lts
* 16.26.1, 16

The `latest` tag will always follow the latest standard release (15, 16, 17, ...). The `lts` tag will follow LTS-Releases (13, 16, ...). Using these tags will result in an major update from time to time. If you want to stay within the same version, use a version tag like `16`, `17`, ...

# How to use this image

## Starting an asterisk instance

**Note:** Keep in mind that this image does not provide any configuration! You must provide your own and make it available at `/etc/asterisk`.

```
$ docker run -v "/path/to/config:/etc/asterisk" -it azielke/asterisk
```

## Networking considerations

As SIP and NAT might cause problems - especially if you want to use the asterisk as a server and not as a pure client - you might want to use host networking using `--network host`

## Example docker-compose.yml

```yaml
version: '2.4'
volumes:
  astdb:
  voicemail:
services:
  asterisk:
    image: azielke/asterisk
    container_name: asterisk
    restart: always
    network_mode: host
    environment:
      - TZ=Europe/Berlin
    volumes:
      - "/path/to/cfg:/etc/asterisk:ro"
      - "astdb:/var/lib/asterisk/db"
      - "voicemail:/var/spool/asterisk/voicemail"
```

# Manual build

The hook scripts can be used manually to initiate a build process. That will build all versions as definied in the `versions`-File.\
But as the hook scripts depend on a CI environment, some variables must be set.

```
export DOCKER_REPO=azielke/asterisk
export IMAGE_NAME=${DOCKER_REPO}:latest
bash -x hooks/build
```

If just a single version should be build, run docker build with build-arg `asterisk_version`:

```
docker build --build-arg asterisk_version=18.12.1 -t azielke/asterisk:18.12.1
```
