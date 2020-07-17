# Supported tags
* 17.6.0, 17, latest
* 16.12.0, 16, lts
* 13.35.0, 13

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
