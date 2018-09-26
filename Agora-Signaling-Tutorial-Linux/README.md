# Agora Linux Signaling Tutorial

*其他语言版本： [简体中文](README_zh.md)*

The Agora Linux Signaling-Tutorial Sample is an open-source demo that will help you get message chat integrated directly into your Linux applications using the Agora Signaling SDK.

With this sample app, you can:

- Login signaling server
- Send point to point message and receive point to point message off line
- Display point to point history message
- Join channel
- Send channel message, receive channel message
- Leave channel
- Logout signaling server

Agora Signaling SDK supports iOS / Android / Web. You can find demos of these platform here:
- Android: https://github.com/AgoraIO/Agora-Signaling-Tutorial-Android
- IOS    : https://github.com/AgoraIO/Agora-Signaling-Tutorial-iOS-Swift
- Web    : https://github.com/AgoraIO/Agora-Signaling-Tutorial-Web
- MacOS  : https://github.com/AgoraIO/Agora-Signaling-Tutorial-macOS-Swift
- Windows: https://github.com/AgoraIO/Agora-Signaling-Tutorial-Windows
- Java   : https://github.com/AgoraIO/Agora-Signaling-Tutorial-Java

## Running the App
- step 1:create a developer account at [Agora.io](https://dashboard.agora.io/signin/), and obtain an App ID.
Then select the editor in the test project, click App Certificate, and get the App Certificate according to the operation.
Update "app/src/main/res/values/strings_config.xml" with your App ID and App Certificate.
- step 2:download the signaling sdk, extract the packet and copy 'libagorasig.so' to our project's 'libs' folder,and also copy 'agora_sig.h' to our project's 'include' folder.
- step 3:open our project ‘src’ folder, run ./build.sh, and according to the prompt to compile,then run ./sig_demo according to the prompt please.

## Developer Environment Requirements
- Physical or virtual, more than Ubuntu Linux 14.04 LTS 64 bits 


## Connect Us
- You can find full API document at [Document Center](https://docs.agora.io/en/)
- You can file bugs about this demo at [issue](https://github.com/AgoraIO/Agora-Signaling-Tutorial-Linux/issues)

## License
The MIT License (MIT).

