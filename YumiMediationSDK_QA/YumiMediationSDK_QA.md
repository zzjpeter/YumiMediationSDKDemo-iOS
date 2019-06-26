- [YumiMediationSDK Q&A](#yumimediationsdk-qa)
  - [Universal](#universal)
  - [iOS](#ios)
      - [使用 Firebase 库 和 admob 库冲突解决方案](#使用-Firebase-库-和-admob-库冲突解决方案)
  - [Android](#android)
  - [Unity插件 Android问题](#unity%E6%8F%92%E4%BB%B6-android%E9%97%AE%E9%A2%98)


# YumiMediationSDK Q&A
## Universal
1. `ChannelID`填什么？
   该参数用于统计需求使用，如无特殊需求，可填空字符串。
2. `VersionID`填什么？
   该参数用于统计需求使用，如无特殊需求，可填空字符串。
3. Facebook 填充问题。
   Facebook 在国内填充较差，测试时，需开启 VPN，并保持 Facebook app 处于登录状态。
   具体请参阅 Facebook 文档，开启测试模式。
4. 启动崩溃且崩溃日志中有 Admob 相关文字。
   iOS 更新您的 info.plist 文件。[Admob 相关文档](https://developers.google.com/admob/ios/quick-start?hl=zh-cn) 
   Android 更新您的 AndroidManifest.xml。[Admob 相关文档](https://developers.google.com/admob/android/quick-start?hl=zh-cn)

## iOS
1. 初次使用 CocoaPods。
   请查阅 [CocoaPods Guides](https://guides.cocoapods.org/using/using-cocoapods.html)
2. 填充很低，查看抓包工具只有 https 请求。
   请查阅 [iOS ATS setting](https://github.com/yumimobi/YumiMediationSDKDemo-iOS/blob/master/normalDocuments/YumiMediationSDK%20for%20iOS(zh-cn).md#app-transport-security)

### 使用 Firebase 库 和 admob 库冲突解决方案
由于 Firebase 库中的文件和 admob 广告SDK 代码重复造成冲突，使用 cocoapods 无法完成 admob 接入，只能通过手动的方式接入admob 平台。具体步骤如下：
1. 在 Podfile 中加入 Firebase admob 库

   ```ruby
   pod 'Firebase/AdMob'
   ```

   在终端执行 ```pod install``` 完成 Firebase admob 库的安装 

2. 手动导入 YumiMediationAdMob （Yumi 的admob adapter）
<br>下载地址是 ([SDKDownloadPage-iOS](https://github.com/yumimobi/YumiMediationSDKDemo-iOS/blob/master/normalDocuments/iOSDownloadPage.md)) 中的 AdMob。
<br>**只需要把 Resources 和 YumiMediationAdMob.framework 导入 Xcode 工程即可** 
   ![image](resources/001.png)

## Android
1. Android6.0以上系统权限处理。
   当您的应用targetSdkVersion为23及以上时，可选择以下方法进行权限检查并且弹窗提示用户授权。
   <p><span style="color:red;">注：该方法默认为false， 不会对用户进行权限提示并且不会导致崩溃。设为true，会进行权限检查并且弹窗提示用户授权。该方法在实例化广告之前调用，并且需要添加android-support-v4.jar。</span></p>
   
   ```java
   YumiSettings.runInCheckPermission(true);
   ```

2. Android 9.0 适配。
   目前一些平台Android SDK暂不支持Android9.0以上操作系统，比如 Mintegral 平台，如果在Android9.0以上系统出现的崩溃，可以通过以下方法解决。
   - 将targaetSDKveriosn设置为27或者27以下。 

3. 百度平台广告无填充。
   - 确认以下权限是否有添加：
   ```java
   <uses-permission android:name="android.permission.READ_PHONE_STATE" />
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
   ```
4. GDT(广点通)平台广告无填充。
   - 确认以下权限是否有添加：
   ```java
   <uses-permission android:name="android.permission.READ_PHONE_STATE" />
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />  
   <uses-permission android:name="android.permission.ACCESS_COARSE_UPDATES"/>
   ```

5. GDT(广点通)平台使用Android Studio接入原生广告，出现原生视频广告不显示问题。
   如果你使用AndroidStudio接入GdtMob(广点通)平台，请确保你App的AndroidManifest.xml中的package:"xxx.xxx.xxx"名称和build.gradle文件中的applicationId "xxx.xxx.xxx"保持一致。如下图所示：
   <img src="resources/aImage1.png" alt="aImage1">

## Unity插件 Android问题
1. Failed to find Build Tools...
   ```
   * What went wrong:
   A problem occurred configuring root project 'gradleOut'.
   > Failed to find Build Tools revision 29.0.0
   ```
   解决方法:
   从 [mainTemplet](../../Assets/Plugins/Android/mainTemplate.gradle) 中删除 `buildToolsVersion '**BUILDTOOLS**'` 

2. No toolchains found...
   ```
   * What went wrong:
   A problem occurred configuring root project 'gradleOut'.
   > No toolchains found in the NDK toolchains folder for ABI with prefix: mips64el-linux-android
   ```
   解决方法:
   修改 [mainTemplet](../../Assets/Plugins/Android/mainTemplate.gradle) 中 gradle plugin 版本，如将 `classpath 'com.android.tools.build:gradle:3.0.1'` 修改为 `classpath 'com.android.tools.build:gradle:3.2.1'`。

3. Failed to apply plugin...
   ```
   * What went wrong:
   A problem occurred evaluating root project 'gradleOut'.
   > Failed to apply plugin [id 'com.android.application']
      > Minimum supported Gradle version is 4.6. Current version is 4.2.1. If using the gradle wrapper, try editing the distributionUrl in
   ```
   解决方法(以下方法任选一个即可):
   - 升级 gradle 版本至 4.6
   - 降级 gradle plugin 版本至 gradle 4.2.1 对应的版本。对照 [Update Gradle](https://developer.android.com/studio/releases/gradle-plugin#updating-gradle) 文档可知需要将 [mainTemplet](../../Assets/Plugins/Android/mainTemplate.gradle) 中 `classpath 'com.android.tools.build:gradle:x.x.x'` 修改为 `classpath 'com.android.tools.build:gradle:3.0.0+'`

4. 接入GDT(广点通)原生广告后，出现广点通原生广告视频不显示问题
   解决方法：
   请确保你Unity项目的Assets/Plugins/Android/AndroidManifest.xml中的package:"xxx.xxx.xxx"名称和你Unity项目的package name "xxx.xxx.xxx"保持一致。如下图所示：
   <img src="resources/uImage1.png" alt="uImage1">