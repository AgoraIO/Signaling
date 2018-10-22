# Agora Signaling Tutorial (Python)
*Read this in other languages: [English](README.md)*

## 信令 SDK Python 版本目前处于测试版本阶段(Beta Version)


这个开源示例项目演示了如何快速集成 Agora 信令 SDK 实现一个简单的信令实例 Python 聊天应用。

在这个示例项目中包含了以下功能：

- 创建目标账户，并进行登录 
- 选择聊天方式（1.点对点双人私聊 2.进入频道，多人聊天组进行聊天）
- 键入对方账户姓名或者频道名（由上一步的聊天方式选择决定）
- 显示私聊及聊天组的聊天记录
- 发送频道消息，接收频道消息
- 离开聊天组
- 注销

## 运行示例程序
* 首先在 [Agora.io 注册](https://dashboard.agora.io/cn/signup/) 注册账号，并创建自己的测试项目，获取到 appId
选择到测试项目里的 interactive_dialogue.py 文件，将 appId 添加到常量 APP_ID 中。

* 然后在命令行使用指令 `pip install agora-signaling-sdk` 安装 python 版信令 SDK。

* 启动程序 `python interactive_by_signaling_entrance.py`

## 运行环境
* PyCharm

## 联系我们
- 完整的 API 文档见 [文档中心](https://docs.agora.io/cn/)
- 如果在集成中遇到问题, 你可以到 [开发者社区](https://dev.agora.io/cn/) 提问
- 如果有售前咨询问题, 可以拨打 400 632 6626，或加入官方Q群 12742516 提问
- 如果需要售后技术支持, 你可以在 [Agora Dashboard](https://dashboard.agora.io) 提交工单
- 如果发现了示例代码的 bug, 欢迎提交 [issue](https://github.com/AgoraIO/Signaling/issues)

## 代码许可
The MIT License (MIT).
