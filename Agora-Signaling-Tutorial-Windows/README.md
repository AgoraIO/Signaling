# Agora Signaling Tutorial for Windows
*其他语言版本： [简体中文](README.zh.md)*

The Agora Windows Sample App is an open-source demo that will help you get message chat integrated directly into your Windows applications using the Agora Signaling SDK.

With this sample app, you can:

- Login into Signaling Serve
- Send point to point message and receive point to point message off line
- Display point to point history message
- Join channel
- Send channel message, receive channel message
- Leave channel
- Logout signaling server

Agora Signaling SDK supports Android / Web / MacOS. You can find demos of these platform here:

- Android: https://github.com/AgoraIO/Agora-Signaling-Tutorial-Android
- Web    : https://github.com/AgoraIO/Agora-Signaling-Tutorial-Web
- MacOS  : https://github.com/AgoraIO/Agora-Signaling-Tutorial-macOS-Swift
- IOS  : https://github.com/AgoraIO/Agora-Signaling-Tutorial-iOS-Swift
- Linux  : https://github.com/AgoraIO/Agora-Signaling-Tutorial-Linux
- Java   : https://github.com/AgoraIO/Agora-Signaling-Tutorial-Java


## Running the App
First, create a developer account at [Agora.io](https://dashboard.agora.io/signin/), and obtain an App ID.
Then select the editor in the test project, click App Certificate, and get the App Certificate according to the operation.
Update "Agora-Signaling-Tutorial-Windows/AgoraSignal.ini" with your App ID and App Certificate.

```
[BaseInfo]
AppID=
AppCertificatedId=
```
The user can generate a tokenID based on the AppCertificateID, and the tokenID can also be '_no_need_token'

## Developer Environment Requirements
- win7 above
- Visual Studio 2013

## Operating Instructions
- 1.Create SDK directory at the same level of Sln directory
- 2.To the network https://www.agora.io/cn/download/ download the latest signaling library, copy all directories in libs to SDK directory. 
- 3.You need to copy the agora_sig_sdk.dll file in the dLL directory of the SDK to the compiled executable directory (debug / release)

## Connect Us
- You can find full API document at [Document Center](https://docs.agora.io/en/)
- You can file bugs about this demo at [issue](https://github.com/AgoraIO/Agora-Signaling-Tutorial-Windows/issues)

## License
The MIT License (MIT).
