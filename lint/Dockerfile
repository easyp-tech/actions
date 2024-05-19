FROM golang:1.22.3-alpine3.19

LABEL "com.github.actions.name"="EasyP lint action"
LABEL "com.github.actions.description"="Run EasyP linter"
LABEL "com.github.actions.icon"="check-circle"
LABEL "com.github.actions.color"="blue"

RUN apk update && apk add --no-cache git

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
