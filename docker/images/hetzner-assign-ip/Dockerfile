FROM alpine:3.8

LABEL maintainer="Ahmed Hefnawi <hello@hefnawi.me>"

ARG ROBOT_USER="hetzner_robot_ws_user"
ARG ROBOT_PASS="hetzner_robot_ws_pass"
ARG IP="failover_ip_addr"


ENV ROBOT_USER=$ROBOT_USER \
    ROBOT_PASS=$ROBOT_PASS \
    IP=$IP

COPY master.sh /master.sh

RUN apk update && apk add --no-cache curl jq && chmod +x /master.sh

ENTRYPOINT ["/master.sh"]
