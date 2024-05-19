FROM golang:1.22

LABEL "com.github.actions.name"="EasyP Install Action"
LABEL "com.github.actions.description"="Install EasyP tool"
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="blue"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
