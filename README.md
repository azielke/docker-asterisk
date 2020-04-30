# Supported tags
* 17.3.0, 17, latest
* 16.10.0, 16

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
services:
  asterisk:
    image: azielke/asterisk
    container_name: asterisk
    restart: always
    network_mode: host
    environment:
      - TZ=Europe/Berlin
    volumes:
      - "/path/to/cfg:/etc/asterisk"
```
