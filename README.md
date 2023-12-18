# Post WeChat Work Bot Messenger

This action wraps the [WeChat Work Bot Post Message API](https://developer.work.weixin.qq.com/document/path/91770) which can be used to post text and markdown type notification messages.

本 Action 包装了[企业微信群机器人发送消息的 API](https://developer.work.weixin.qq.com/document/path/91770)，可以快速发送 text、Markdown 格式的群通知消息。

## 用法

将发送消息的的 key 参数配置到 GitHub Secret 中，并配置发送的 Markdown 消息。
配置参数：

| 参数名         | 描述                          |
|--------------|----------------------------------|
| BOT_KEY      | 机器人key              |
| MSG_TYPE     | 支持 text、markdown              |
| POST_MESSAGE | 推送内容                 |
| MESSAGE_FILE | 从MESSAGE_FILE中读取消息内容    |
| PHONE_MAPS   | 当MSG_TYPE==text有效，支持被@手机列表，格式：`stvenx:13800138000,user1:13800138001` |


POST_MESSAGE和MESSAGE_FILE二选一

```yaml
- name: Notify WeChat Work
  uses: stvenx/wechat-work-messenger@v2
  env:
    BOT_KEY: ${{ secrets.BOT_KEY }}
    MSG_TYPE: 'text'
    POST_MESSAGE: 'Markdown Message'
    PHONE_MAPS: 'stvenx:13800138000,xxx:13800138001'
```

```yaml
- name: Notify WeChat Work
  uses: stvenx/wechat-work-messenger@v2
  env:
    BOT_KEY: ${{ secrets.BOT_KEY }}
    MSG_TYPE: 'markdown'
    POST_MESSAGE: |
      ### ${{ github.ref_name }} go test succeeded \n
      > author： <font color=\"warning\"> ${{ github.event.head_commit.author.name }} </font>
```

## License

基于 [MIT License](LICENSE)。
