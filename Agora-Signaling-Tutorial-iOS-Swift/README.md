# Agora iOS Signaling Tutorial for Swift
*其他语言版本： [简体中文](README.zh.md)*

The Agora Android OpenDuo Sample App is an open-source demo that will help you get message chat integrated directly into your Android applications using the Agora Signaling SDK.

With this sample app, you can:

- login signaling server
- Send point to point message and receive point to point message off line
- Display point to point history message
- Join channel
- Send channel message, receive channel message
- Leave channel
- Logout signaling server

Agora signaling SDK supports Android / Web / MacOS. You can find demos of these platform here:

- Android: https://github.com/AgoraIO/Agora-Signaling-Tutorial-Android
- Web    : https://github.com/AgoraIO/Agora-Signaling-Tutorial-Web
- MacOS  : https://github.com/AgoraIO/Agora-Signaling-Tutorial-macOS-Swift
- Linux  : https://github.com/AgoraIO/Agora-Signaling-Tutorial-Linux
- Java   : https://github.com/AgoraIO/Agora-Signaling-Tutorial-Java
- Windows: https://github.com/AgoraIO/Agora-Signaling-Tutorial-Windows


## Running the App
First, create a developer account at [Agora.io](https://dashboard.agora.io/signin/), and obtain an App ID.
Update "Agora-Signaling-Tutorial-iOS-Swift/Agora-Signaling-Tutorial/KeyCenter.swift" with your App ID.

```
let AppId: String = "Your App Id"
```



Next, download the Agora Signaling SDK from Agora.io SDK. Unzip the downloaded SDK package and copy the "libs" folder to the project folder.

Finally, Open Agora-Signaling-Tutorial.xcodeproj, connect your iPhone／iPad device, setup your development signing and run.

## Developer Environment Requirements
* XCode 8.0 +
* Real devices (iPhone, iPad or iOS simulator)


## Connect Us
- You can find full API document at [Document Center](https://docs.agora.io/en/)
- You can file bugs about this demo at [issue](https://github.com/AgoraIO/Agora-Signaling-Tutorial-iOS-Swift/issues)

## License
The MIT License (MIT).

