#!/bin/bash
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

mentioned_mobile_list=""
parse_phones() {
    local mapstr=$1
    local touser=$2
    local result=""

    IFS=',' read -ra pairs <<< "$mapstr"
    for pair in "${pairs[@]}"; do
        IFS=':' read -ra data <<< "$pair"
        key=${data[0]}
        value=${data[1]}
        if [[ " $touser " = *" $key "* ]]; then
            result="$result\"$value\","
        fi
    done

    result=${result%,}
    echo $result
}

ASSIGNEES=$(echo $ASSIGNEES | jq -r '.[] | .login')
ASSIGNEES="${ASSIGNEES//$'\n'/ }"
mentioned_mobile_list=$(parse_phones "$PHONE_MAPS" "$ASSIGNEES")

if [ "$MSG_TYPE" = "text" ]; then
  curl "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=${BOT_KEY}" \
    -H "Content-Type: application/json" \
    -d @- <<END
  {
    "msgtype": "text",
    "text": {
      "content": "${POST_MESSAGE}",
      "mentioned_mobile_list": [${mentioned_mobile_list}]
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
      "content": "${POST_MESSAGE}",
      "mentioned_mobile_list": [${mentioned_mobile_list}]
    }
  }
END
fi
