FROM golang:1.22.3-alpine3.19

LABEL "com.github.actions.name"="EasyP Install action"
LABEL "com.github.actions.description"="Install EasyP tool"
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="blue"

RUN apk update && apk add --no-cache git

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
