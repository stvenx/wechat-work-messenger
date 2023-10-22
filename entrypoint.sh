#!/bin/sh
set -e

if [ -z "$BOT_KEY" ]; then
  echo "Please set the BOT_KEY secret."
  exit 1
fi

if [ -z "$POST_MESSAGE" ] && [ -z "$MESSAGE_FILE" ]; then
  echo "Please set the post markdown message or a file containing the message."
  exit 1
fi

if [ -z "$POST_MESSAGE" ] && [ -n "$MESSAGE_FILE" ]; then
  if [ ! -f "$MESSAGE_FILE" ]; then
    echo "File '$MESSAGE_FILE' not found."
    exit 1
  fi
  POST_MESSAGE=$(sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/\\n/g' -e 's/"/\\"/g' "$MESSAGE_FILE")
fi

if [ "$MSG_TYPE" = "text" ]; then
  curl "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=${BOT_KEY}" \
    -H "Content-Type: application/json" \
    -d @- <<END
  {
    "msgtype": "text",
    "text": {
      "content": "${POST_MESSAGE}"
    }
  }
END
else
  curl "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=${BOT_KEY}" \
    -H "Content-Type: application/json" \
    -d @- <<END
  {
    "msgtype": "markdown",
    "markdown": {
      "content": "${POST_MESSAGE}"
    }
  }
END
fi
