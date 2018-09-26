# Agora Signaling Tutorial (JAVA)

*Read this in other languages: [English](README.md)*
 
这个开源示例项目演示了如何快速集成 Agora 信令 SDK 实现一个简单的多个 Signaling 实例或者单个 Signaling 实例 JAVA 聊天应用。

在这个示例项目中包含了以下功能：

- 创建多个 Signaling 实例或者单个 Signaling 实例（该示例项目有两个入口，SingleSignalObjectMain 为 Signaling 单实例入口，MulteSignalObjectMain2 为 Signaling 多实例入口）
- 创建目标账户账户，并进行登录 
- 选择聊天方式（1.点对点双人私聊  2.进入频道，多人聊天组进行聊天）
- 键入对方账户姓名或者频道名（由上一步的聊天方式选择决定）
- 显示私聊的聊天记录
- 发送频道消息，接收频道消息
- 离开聊天组
- 注销

Agora 信令 SDK 支持 Android/IOS/Linux/MacOS/Web/Windows 等多个平台，你可以查看对应各平台的示例项目:

* Android: https://github.com/AgoraIO/Agora-Signaling-Tutorial-Android	 
* IOS: https://github.com/AgoraIO/Agora-Signaling-Tutorial-iOS-Swift	
* Linux: https://github.com/AgoraIO/Agora-Signaling-Tutorial-Linux	
* MacOS: https://github.com/AgoraIO/Agora-Signaling-Tutorial-macOS-Swift
* Web: https://github.com/AgoraIO/Agora-Signaling-Tutorial-Web
* Windows https://github.com/AgoraIO/Agora-Signaling-Tutorial-Windows


## 集成方式&运行示例程序
* 首先在 [Agora.io 注册](https://dashboard.agora.io/cn/signup/) 注册账号，并创建自己的测试项目，获取到 appId
选择到测试项目里的 Constant.java 文件，将 appId 添加到集合 app_ids 中，如果要实现多实例，你就要添加多个 appId 。
``` java
app_ids.add(“Your appId”);
```
* 然后在 [Agora.io SDK](https://docs.agora.io/cn/2.0.2/download) 下载 Java 版信令 SDK，在示例项目根目录创建 lib 文件夹，lib 和 src 文件夹平级，解压后将其中的 lib 文件夹下的 jar 包和 libs-dep 下的 jar 包复制到本项目的 lib 文件下。

* 最后将示例项目以 gradle 项目导入开发工具中。
## 运行环境

* eclipse 4.7.1 或者 IntelliJ IDEA 2016
* gradle 2.13

## 联系我们
- 完整的 API 文档见 [文档中心](https://docs.agora.io/cn/)
- 如果在集成中遇到问题, 你可以到 [开发者社区](https://dev.agora.io/cn/) 提问
- 如果有售前咨询问题, 可以拨打 400 632 6626，或加入官方Q群 12742516 提问
- 如果需要售后技术支持, 你可以在 [Agora Dashboard](https://dashboard.agora.io) 提交工单
- 如果发现了示例代码的 bug, 欢迎提交 [issue](https://github.com/AgoraIO/Agora-Android-Tutorial-1to1/issues)

## 代码许可
The MIT License (MIT).
