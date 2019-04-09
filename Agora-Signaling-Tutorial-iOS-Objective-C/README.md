
# Agora Signaling Tutorial (iOS Swift)

*Read this in other languages: [中文](README.zh.md)*

This tutorial enables you to quickly get started with using a sample chat application to develop requests to the Agora Signaling SDK.

This sample app demonstrates the basic Agora Signaling SDK features:

- Login to the signaling server
- Send and receive peer-to-peer messages offline
- View peer-to-peer message history
- Join a channel
- Send and receive channel messages
- Leave a channel
- Logout


## Prerequisites

- Xcode 9.0+
- Physical iOS device (iPhone or iPad)
	
	**Note:** Use a physical device to run the sample. Some simulators lack the functionality or the performance needed to run the sample.


## Quick Start
This section shows you how to prepare and build the Java signaling sample app.

### Create an Account and Obtain an App ID
To build and run the sample application, you must obtain an app ID: 

1. Create a developer account at [agora.io](https://dashboard.agora.io/signin/). Once you finish the sign-up process, you are redirected to the dashboard.
2. Navigate in the dashboard tree on the left to **Projects** > **Project List**.
3. Copy the app ID that you obtained from the dashboard into a text file. You will use this when you launch the app.


### Update and Run the Sample Application 

1. Open `Agora-Signaling-Tutorial.xcodeproj` and edit the `KeyCenter.m` file. In the `AppId` declaration, update `<#Your App Id#>` with your app ID.

	``` 
    + (NSString *)AppId {
    return @<#Your AppId#>;
}
	```

2. Download the [Agora Signaling SDK](https://www.agora.io/en/download/). Unzip the downloaded SDK package and copy the `libs` folder from the SDK folder into the sample application's `Agora-Signaling-Tutorial` folder.
			
3. Connect your iPhone or iPad device and run the project. Ensure a valid provisioning profile is applied or your project will not run.


## Resources
* A detailed code walkthrough for this sample is available in [Steps to Create this Sample](./guide.md).
* Complete API documentation is available at the [Document Center](https://docs.agora.io/en/).
* Join the [Agora Developer Community] (https://dev.agora.io/cn/).
* For pre-sale questions:
	- Call 400-632-6626
	- Join the official Q group 12742516 with questions
* Technical support is available. Submit a ticket within the [Agora Dashboard] (https://dashboard.agora.io)

* You can file bugs about this demo at [issue](https://github.com/AgoraIO/Signaling/issues)

## License
This software is under the MIT License (MIT). [View the license](LICENSE.md).