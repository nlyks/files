FROM alpine:latest AS download
ARG TARGETPLATFORM
ARG VERSION=v5.0.0b3
WORKDIR /root
RUN  apk add --no-cache wget unzip ca-certificates \
    && case "${TARGETPLATFORM}" in \
    "linux/amd64") SNELL_URL="https://dl.nssurge.com/snell/snell-server-${VERSION}-linux-amd64.zip" ;; \
    "linux/arm64") SNELL_URL="https://dl.nssurge.com/snell/snell-server-${VERSION}-linux-aarch64.zip" ;; \
    "linux/arm/v7") SNELL_URL="https://dl.nssurge.com/snell/snell-server-${VERSION}-linux-armv7l.zip" ;; \
    "linux/386") SNELL_URL="https://dl.nssurge.com/snell/snell-server-${VERSION}-linux-i386.zip" ;; \
    *) echo "Unsupported platform: ${TARGETPLATFORM}"  && exit 1 ;; \
    esac \
	&& wget -O snell-server.zip ${SNELL_URL} \
	&& unzip snell-server.zip \
	&& chmod +x snell-server

FROM debian:stable-slim
RUN apt update && apt install -y tini
COPY --from=download /root/snell-server /usr/local/bin/snell-server
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT ["/usr/bin/tini", "--", "/root/entrypoint.sh"]
