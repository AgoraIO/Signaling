# Agora-Signaling-Tutorial-Windows

*Read this in other languages: [English](README.md)*

这个开源示例项目演示了如何快速集成 Agora 信令 SDK 实现发消息功能。

在这个示例项目中包含了以下功能：

- 登录信令服务器
- 查询点对点聊天对象是否在线
- 发送点对点消息，离线接收点对点消息
- 加入频道
- 发送频道消息，接收频道消息
- 离开频道
- 注销信令登录

Agora 信令 SDK 支持 iOS / Android / Web 等多个平台，你可以查看对应各平台的示例项目：
- Android: https://github.com/AgoraIO/Agora-Signaling-Tutorial-Android
- IOS    : https://github.com/AgoraIO/Agora-Signaling-Tutorial-iOS-Swift
- Web    : https://github.com/AgoraIO/Agora-Signaling-Tutorial-Web
- MacOS  : https://github.com/AgoraIO/Agora-Signaling-Tutorial-macOS-Swift
- Linux  : https://github.com/AgoraIO/Agora-Signaling-Tutorial-Linux
- Java   : https://github.com/AgoraIO/Agora-Signaling-Tutorial-Java

## 运行示例程序
- 首先在 [Agora.io 注册](https://dashboard.agora.io/cn/signup/) 注册账号，并创建自己的测试项目，获取到 AppID。
然后选择测试项目里的编辑，如果该 AppID 对应的 Certificate 已经启用，根据操作拿到 App Certificate。
将 AppID 和 App Certificate 填写进 "AgoraSignal.ini" 中

```
[BaseInfo]
AppID=
AppCertificatedId=
```
- 用户可以根据 AppCertificateID 生成 tokenID, tokenID也可以为 "_no_need_token".

## 运行环境
- win7以上
- Visual Studio 2013

## 运行说明
- 1.在Sln同级目录创建SDK文件夹
- 2.到官网https://www.agora.io/cn/download/ 下载最新的信令库,将 libs 文件夹下所有文件夹拷贝到和SDK目录下即可       
- 3.需要将 SDK 包中 libs\dll 目录下 agora_sig_sdk.dll 文件拷贝到编译执行目录（debug / release）

## 联系我们
- 完整的 API 文档见 [文档中心](https://docs.agora.io/cn/)
- 如果在集成中遇到问题, 你可以到 [开发者社区](https://dev.agora.io/cn/) 提问
- 如果有售前咨询问题, 可以拨打 400 632 6626，或加入官方Q群 12742516 提问
- 如果需要售后技术支持, 你可以在 [Agora Dashboard](https://dashboard.agora.io) 提交工单
- 如果发现了示例代码的 bug, 欢迎提交 [issue](https://github.com/AgoraIO/Agora-Signaling-Tutorial-Windows/issues)

## 代码许可
The MIT License (MIT).

