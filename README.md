# Supported tags
* 17.4.0, 17, latest
* 16.10.0, 16, lts
* 13.33.0, 13

The `latest` tag will always follow the latest standard release (15, 16, 17, ...). The `lts` tag will follow LTS-Releases (13, 16, ...). Using this tags will result in an major update from time to time. If you want to stay within the same version, use a version tag like `16`, `17`, ...

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

# Possible Issues

## asterisk not starting without any error messages

Due to the build process, a `Sandy Bridge` or later CPU is required. Otherwise asterisk won't start and an `trap: invalid opcode` is logged in the kernel log.

If you have an older CPU, it is possible to build the image locally (docker-compose example, checkout repository with git and replace `image:` with `build:`):

```yaml
services:
  asterisk:
    build:
      context: ./docker-asterisk
      args:
        asterisk_version: 17.4.0 # full version required, just "17" does not work.
```
