FROM alpine:latest


LABEL "com.github.actions.name"="WeChat Work Messenger"
LABEL "com.github.actions.description"="Post WeChat Work messages from your own bot"
LABEL "com.github.actions.icon"="bell"
LABEL "com.github.actions.color"="green"

LABEL version="1.0.0"
LABEL repository="https://github.com/chhpt/wechat-work-messenger.git"
LABEL homepage="https://github.com/chhpt/wechat-work-messenger.git"
LABEL maintainer="wuyiqing <cwuyiqing@gmail.com>"

RUN apk --no-cache add curl sed

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
