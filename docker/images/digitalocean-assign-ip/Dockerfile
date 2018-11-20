FROM alpine:3.8

LABEL maintainer="Ahmed Hefnawi <me@ahmedhefnawi.com>"

ENV DO_TOKEN="digitalocean_api_token" \
    IP="floating_ip_addr"

COPY master.sh /master.sh

RUN apk update && apk add --no-cache curl jq && chmod +x /master.sh

ENTRYPOINT ["/master.sh"]
