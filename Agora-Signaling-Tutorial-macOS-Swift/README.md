# Agora macOS Signaling Tutorial for Swift
*其他语言版本： [简体中文](README.zh.md)*

The Agora Android OpenDuo Sample App is an open-source demo that will help you get message chat integrated directly into your Android applications using the Agora Signaling SDK.

With this sample app, you can:

- Login Signaling
 server
- Send point to point message and receive point to point message off line
- Display point to point history message
- Join channel
- Send channel message, receive channel message
- Leave channel
- Logout Signaling server

## Running the App
First, create a developer account at [Agora.io](https://dashboard.agora.io/signin/), and obtain an App ID.
Update "Agora-Signaling-Tutorial-macOS-Swift/Agora-Signaling-Tutorial/MainPage/KeyCenter.swift" with your App ID.

```
static let appID : String = <#YOUR APPID#>
```

Next, download the Agora Signaling SDK from Agora.io SDK. Unzip the downloaded SDK package and copy the "libs" folder to the project folder.


Finally, open Agora-Signaling-Tutorial.xcodeproj, setup your development signing and run.
## Developer Environment Requirements
* XCode 8.0 +
* macOS


## Connect Us
- You can find full API document at [Document Center](https://docs.agora.io/en/)
- You can file bugs about this demo at [issue](https://github.com/AgoraIO/Signaling/issues)

## License
The MIT License (MIT).

