# Agora Signaling Tutorial (JAVA)

*其他语言版本： [简体中文](README.en.md)*
 
This open source sample project demonstrates how to quickly integrate the Agora Signaling SDK for a simple multi-instance Signaling or single-instance Signaling JAVA chat application.

The following features are included in this sample project:

- Create multiple Signaling instances or single Signaling instances (the example project has two entries, SingleSignalObjectMain is the entrance of Signaling single instance and MulteSignalObjectMain2 is the entrance of Signaling multi-instance)
- Create a target account and log in
- Select chat mode (1. Peer-to-peer private chat 2. Into the channel, multi-person chat group to chat)
- Type in the account name or channel name of the other party (decided by the chat mode of the previous step)
- Show private chat history
- Send channel message, receive channel message
- Leave the chat group
- Logout

## Integration mode & run the sample program
* Step 1: Register an account at [Agora.io] (https://dashboard.agora.io/cn/signup/) and create your own test project to get the appId
Then select the Constant.java file in your test project, add appId to the set app_ids and if you want to implement multiple instances, you will need to add more than one appId.
`` `java
app_ids.add ("Your appId");
`` `
* Step 2: Download the Java Agora Signaling SDK at [Agora.io SDK] (https://docs.agora.io/cn/2.0.2/download), create the lib folder at the root of the sample project, after unpacking the file, copy the jar package under the Lib folder and the jar package under the libs-dep to the Lib file of this project.
* Step 3: Import the sample project to your development tools as a gradle project.

## Operating environment

* Eclipse 4.7.1 or IntelliJ IDEA 2016
* Gradle 2.13

## Contact us
- Complete API Documentation See [Documentation Center] (https://docs.agora.io/cn/)
- If you have a problem with integration, you can ask questions on [Developer Community] (https://dev.agora.io/cn/)
- If you have pre-sales consulting questions, you can call 400 632 6626, or join the official Q group 12742516 questions
- If after-sales technical support is required, you can submit a ticket at [Agora Dashboard] (https://dashboard.agora.io)
- If you find a bug in the sample code, please feel free to submit [issue] (https://github.com/AgoraIO/Signaling/issues)

## Code License
The MIT License (MIT).
