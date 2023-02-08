# WiFite 2 container

Docker for https://github.com/kimocoder/wifite2 using Kali as a base. Rebuilt daily.

## Pulling

### DockerHub

[![Docker build and upload](https://github.com/FinchSec/wifite2-docker/actions/workflows/docker.yml/badge.svg?event=push)](https://github.com/FinchSec/wifite2-docker/actions/workflows/docker.yml)

URL: https://hub.docker.com/r/finchsec/wifite2

`sudo docker pull finchsec/wifite2`

## Running

`sudo docker run --rm -it --privileged --net=host --pid=host finchsec/wifite2`
