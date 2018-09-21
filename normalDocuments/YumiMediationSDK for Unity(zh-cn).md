* [YumiMediationSDK for Unity](#yumimediationsdk-for-unity)   
   * [概述](#概述)   
   * [导入YumiMediationPlugins.unitypackage](#导入yumimediationpluginsunitypackage)   
    * [开发环境配置](#开发环境配置)   
       * [App Transport Security](#app-transport-security)   
       * [iOS 9 及以上系统相关权限](#ios-9-及以上系统相关权限)   
    * [三方SDK接入方式](#三方sdk接入方式)   
    * [代码集成示例](#代码集成示例)   
       * [广告形式](#广告形式)   
           * [Banner](#banner)   
              * [初始化](#初始化)   
              * [设置banner 尺寸](#设置banner-尺寸)   
              * [请求横幅](#请求横幅)   
              * [移除 Banner](#移除-banner)   
              * [实现代理方法](#实现代理方法)   
              * [自适应功能](#自适应功能)   
           * [Interstitial](#interstitial)   
              * [初始化及请求插屏](#初始化及请求插屏)   
              * [展示插屏](#展示插屏)   
              * [实现代理方法](#实现代理方法-1)   
           * [Rewarded Video](#rewarded-video)   
              * [初始化及请求视频](#初始化及请求视频)   
              * [判断视频是否准备好](#判断视频是否准备好)   
              * [展示视频](#展示视频)   
              * [实现代理方法](#实现代理方法-2)   
   * [调试模式](#调试模式)   
      * [调用调试模式](#调用调试模式)   
      * [设置调试模式的banner尺寸](#设置调试模式的banner尺寸)   
      * [图示](#图示)   
      
# YumiMediationSDK for Unity

## 概述

1. 面向人群

   本产品主要面向需要在 Unity 产品中接入玉米移动广告 SDK 的开发人员。

2. 开发环境

   Xcode 7.0 或更高版本。

   iOS 8.0 或更高版本。

3. [Demo 获取地址](https://github.com/yumimobi/YumiMediationSDKDemo-iOS.git)   

## 导入YumiMediationPlugins.unitypackage

1. 双击 YumiMediationPlugins.unitypackage 将所有文件导入 Unity 工程
   [YumiMediationUnityPlugins_v3.3.9 download](https://adsdk.yumimobi.com/iOS/Archived/3.3.9/YumiMediationUnityPlugins_v339.unitypackage)

   <img src="resources/UnityPackage1.png" width="300" height="500"> 

2. Add Component 

   关联 YumiMediationSDKEventListener.cs 及 YumiMediationSDKManager.cs 到您需要使用的scene中。

3. 导出Xcode工程

## 开发环境配置 

- ### App Transport Security

  WWDC 15 提出的 ATS (App Transport Security) 是 Apple 在推进网络通讯安全的一个重要方式。在 iOS 9 及以上版本中，默认非 HTTPS 的网络访问是被禁止的。

  因为大部分广告物料以 HTTP 形式提供，为提高广告填充率，请进行以下设置：

  ```plsql
  <key>NSAppTransportSecurity</key>
  <dict>
      <key>NSAllowsArbitraryLoads</key>
      <true/>
  </dict>
  ```

  ![ats_exceptions](resources/ats_exceptions.png)

  *当 `NSAllowsArbitraryLoads` 和 `NSAllowsArbitraryLoadsInWebContent` 或 `NSAllowsArbitraryLoadsForMedia` 同时存在时，根据系统不同，表现的行为也会不一样。简单说，iOS 9 只看 `NSAllowsArbitraryLoads`，而 iOS 10 会优先看 `InWebContent` 和 `ForMedia` 的部分。在 iOS 10 中，要是后两者存在的话，在相关部分就会忽略掉 `NSAllowsArbitraryLoads`；如果不存在，则遵循 `NSAllowsArbitraryLoads` 的设定。*

- ### iOS 9 及以上系统相关权限

  应用程序上传 App Store, 请在 info.plist 文件中添加以下权限。

  ```plsql
  <-- 日历 -->
  <key>NSCalendarsUsageDescription</key>
  <string>App需要您的同意,才能访问日历</string>
  <!-- 相册 -->
  <key>NSPhotoLibraryUsageDescription</key>
  <string>App需要您的同意,才能访问相册</string>
  ```

## 三方SDK接入方式

- CocoaPods (推荐)

  CocoaPods 是 iOS 的依赖管理工具，使用它可以轻松管理您的三方SDK。

  打开您工程的 Podfile，选择下面其中一种方式添加到您应用的 target。

  如果您是初次使用 CocoaPods，请查阅 [CocoaPods Guides](https://guides.cocoapods.org/using/using-cocoapods.html) 。

  - 如果您需要聚合其他平台

    ```ruby
    pod "YumiMediationAdapters", :subspecs => ['AdColony','AdMob','AppLovin','Baidu','Chartboost','Domob','Facebook','GDT','InMobi','IronSource','Unity','Vungle','Mintegral','OneWay','PlayableAds']
    ```

    接下来在命令行界面中运行：

    ```shell
    $ pod install --repo-update
    ```

    最终通过 workspace 打开工程。

2. 手动集成三方SDK

   1. 三方 SDK 选择 ([SDKDownloadPage-iOS](https://github.com/yumimobi/YumiMediationSDKDemo-iOS/blob/master/normalDocuments/iOSDownloadPage.md)) 
   2. 添加 三方SDK 到您的工程

   <img src="resources/addFiles.png" width="280" height="320"> 

   <img src="resources/addFiles-3.png" width="500" height="400"> 


## 代码集成示例

### 广告形式

#### Banner

- ##### 初始化

  ```c#
  //banner展示位置
  public enum YumiMediationBannerPosition{
  		YumiMediationBannerPositionTop,
  		YumiMediationBannerPositionBottom
  	}
  ```

  ```c#
  YumiMediationSDK_Unity.initYumiMediationBanner("Your PlacementID","Your channelID",
                                                 "Your versionID",                                             YumiMediationSDK_Unity.YumiMediationBannerPosition.YumiMediationBannerPositionBottom);
  ```

- ##### 设置banner 尺寸

  ```c#
  //目前我们支持三种尺寸
  //在 iPhone 上默认为 320 * 50，如无调整不需设置下列代码。
  //在 iPad 上默认为 728 * 90，如无调整不需设置下列代码。
  //如果您有特殊需求，300 * 250 为可选项。请在 loadAd 之前，执行下列代码。
  YumiMediationSDK_Unity.setBannerAdSize (YumiMediationSDK_Unity.YumiMediationAdViewBannerSize.kYumiMediationAdViewBanner300x250);
  ```

- ##### 请求横幅

  ```c#
  YumiMediationSDK_Unity.loadAd(false);
  ```

- ##### 移除 Banner

  ```c#
  YumiMediationSDK_Unity.removeBanner();
  ```

- ##### 实现代理方法 

  ```c#
  void yumiMediationBannerViewDidLoadEvent()
  {
  	Debug.Log("YumiMediationSDKBanner,didLoaded");
  }
  void yumiMediationSDKDidFailToReceiveAdEvent(string error)
  {
  	Debug.Log("YumiMediationSDKBanner,didFailToReceiveAd");
  }
  void yumiMediationBannerViewDidClickEvent()
  {
  	Debug.Log("YumiMediationSDKBanner,didClickedAd");
  }
  ```

- ##### 自适应功能

  ```c#
  YumiMediationSDK_Unity.loadAd(false);
  ```

  您在请求 `banner` 广告的同时可以设置是否开启自适应功能。

  如果设置 `isSmartBanner` 为 `YES` ,YumiMediationBannerView 将会自动根据设备的尺寸进行适配。

 ![fzsy](resources/fzsy.png) ![zsy](resources/zsy.png) 

	*非自适应模式* 		  *自适应模式*										

#### Interstitial

- ##### 初始化及请求插屏

  ```c#
  YumiMediationSDK_Unity.initYumiMediationInterstitial("Your PlacementID",
                                                     "Your channelID",
                                                     "Your versionID");
  ```

- ##### 展示插屏

  ```c#
  YumiMediationSDK_Unity.present();
  ```

- ##### 实现代理方法

  ```c#
  void yumiMediationInterstitialDidReceiveAdEvent(){
      Debug.Log ("YumiMediationInterstital, DidReceiveAd");
  }
  void yumiMediationInterstitialDidFailToReceiveAdEvent(string error){
      Debug.Log ("YumiMediationInterstital, DidFailToReceiveAd");
  }
  void yumiMediationInterstitialWillDismissScreenEvent(){
      Debug.Log ("YumiMediationInterstital, WillDismissScreen");
  }
  void yumiMediationInterstitialDidClickEvent() {
      Debug.Log ("YumiMediationInterstital, DidClicked");
  }
  ```

#### Rewarded Video

- ##### 初始化及请求视频

  ```c#
  YumiMediationSDK_Unity.loadYumiMediationVideo("Your PlacementID",
                                              "Your channelID",
                                              "Your versionID");
  ```

- ##### 判断视频是否准备好

  ```c#
  bool isplay = YumiMediationSDK_Unity.isVideoReady();
  ```

- ##### 展示视频

  ```c#
  YumiMediationSDK_Unity.playVideo();
  ```

- ##### 实现代理方法

  ```objective-c
  void yumiMediationVideoDidOpenEvent(){
      Debug.Log ("YumiMediationVideo, DidOpen");
  }
  void yumiMediationVideoDidStartPlayingEvent(){
      Debug.Log ("YumiMediationVideo, DidStartPlaying");
  }
  void yumiMediationVideoDidCloseEvent(){
      Debug.Log ("YumiMediationVideo, DidClosed");
  }
  void yumiMediationVideoDidRewardEvent(){
      Debug.Log ("YumiMediationVideo, DidRewarded");
  }
  ```

## 调试模式

如果您想调试平台key是否有广告返回，可选择调试模式。 

### 调用调试模式

```c#
YumiMediationSDK_Unity.presentYumiMediationDebugCenter (" your banner placementID"," your interstitial placementID","your video placementID","your native placementID","your channelID","your versionID");
```

### 设置调试模式的banner尺寸

```c#
//目前我们支持三种尺寸
//在 iPhone 上默认为 320 * 50，如无调整不需设置下列代码。
//在 iPad 上默认为 728 * 90，如无调整不需设置下列代码。
//如果您有特殊需求，300 * 250 为可选项。请在 presentYumiMediationDebugCenter 之前，执行下列代码。
YumiMediationSDK_Unity.setBannerSizeInDebugCenter (YumiMediationSDK_Unity.YumiMediationAdViewBannerSize.kYumiMediationAdViewBanner300x250);
```

### 图示

<img src="resources/debug-1.png" width="240" height="426">

选择平台类型

<img src="resources/debug-2.png" width="240" height="426">

选择单一平台，灰色平台为已添加未配置

<img src="resources/debug-3.png" width="240" height="426">

选择广告类型，调试单一平台







