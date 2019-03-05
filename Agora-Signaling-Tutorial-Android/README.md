# Agora Android Signaling Tutorial

*Read this in other languages: [中文](README.zh.md)*

The Agora Android Signaling Tutorial is an open-source demo that will help you integrate message chat directly into your Android applications using the Agora Signaling SDK.

With this sample project, you can:

- Create a *point-to-point* chat (private, single instance) or a *channel messaging* chat (group, multiple instance)
- Log in to the Signaling server
- Determine if a user is online
- Send and receive *point-to-point* messages offline
- Join a channel
- Send and receive a channel message
- Leave a channel group
- Log out

## Prerequisites
- Agora.io Developer Account
- Android Studio 2.0 or above
- An Android device (e.g. Nexus 5X)

**Note:** Testing with an Android device is preferred over using a simulator, because some device simulators are missing functionality or exhibit performance issues.

## Quick Start
This section shows you how to prepare and build the Android signaling sample app.

### Create an Account and Obtain an App ID
To build and run the sample project, first obtain an app ID:

1. Create a developer account at [agora.io](https://dashboard.agora.io/signin/). Once you finish the sign-up process, you will be redirected to the dashboard.
2. Navigate in the dashboard tree on the left to **Projects** > **Project List**.
3. Copy the app ID that you obtained from the dashboard.
4. Open the `\app\src\main\res\values\strings_config.xml` file and replace `<#YOUR APP ID#>` with the app ID from the Agora dashboard.
   
``` xml
<resources>
    <string name="agora_app_id"><#YOUR APP ID#></string>
</resources>
```

### Import and Run the Sample Project

1. Download the [Agora Signaling Server SDK for Android](https://docs.agora.io/en/2.0.2/download).
2. Unzip the downloaded SDK package and copy the following:

    - The `libs\agora-sig-sdk.jar` files into the `app\libs\` directory of the sample project
    - The `libs\arm64-v8a\libagora-sig-sdk-jni.so` file into the `app\src\main\jniLibs\arm64-v8a` directory of the sample project
    - The `libs\armeabi-v7a\libagora-sig-sdk-jni.so` file into the `app\src\main\jniLibs\armeabi-v7a` directory of the sample project
    - The `libs\x86\libagora-sig-sdk-jni.so` file into the `app\src\main\jniLibs\x86` directory of the sample project

3. Open `app\build.gradle` in a text editor, add `compile fileTree(dir: 'libs', include: ['*.jar'])` to the `dependencies` section, and save the file:

```
dependencies {
    ...
    compile fileTree(dir: 'libs', include: ['*.jar'])
}
```

4. Open Android Studio and select **File** > **Open** from the main menu.

5. In the dialog box that opens, select the directory that contains the sample project and click **OK**.

6. Connect an Android device to your development PC and select **Run** > **Run App** to run the application on that device.

7. When the app launches on the Android device, enter a user name on the login screen and tap **Login**. This displays the channel selection screen.

8. Tap on the single-callout icon to select *point-to-point messaging* or the multi-callouts icon to select *channel messaging*.

9. If *point-to-point messaging* is selected, enter the name of another user to communicate with in the input field and click **Chat**. If *channel messaging* is selected, enter the name of a message channel to join and click **Join**. This displays the message chat screen.

10. Enter a message and click **Send**.

## Resources
* A detailed code walkthrough for this sample is available in [Steps to Create this Sample](./guide.md).
* You can find full API documentation at the [Document Center](https://docs.agora.io/en/).
* You can file bugs about this sample [here](https://github.com/AgoraIO/Agora-Android-Tutorial-1to1/issues).


## License
This software is under the MIT License (MIT). [View the license](LICENSE.md).
