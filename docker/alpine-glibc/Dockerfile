FROM alpine:latest
WORKDIR /root
COPY *.apk /root/
RUN apk update \
    && wget -q -O /etc/apk/keys/nlyk.rsa.pub https://github.com/nlyks/Rule/releases/download/2.40/nlyk-66d16030.rsa.pub \
    && apk add --no-cache libstdc++ gcompat \
    && apk add  --allow-untrusted --no-cache --force-overwrit glibc-bin-2.40-r1.apk glibc-2.40-r1.apk
