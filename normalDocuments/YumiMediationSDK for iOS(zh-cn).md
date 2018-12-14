* [YumiMediationSDK iOS](#yumimediationsdk-ios)   
   * [概述](#概述)   
   * [开发环境配置](#开发环境配置)   
      * [App Transport Security](#app-transport-security)
      * [iOS 9 及以上系统相关权限](#ios-9-及以上系统相关权限)   
   * [接入方式](#接入方式)   
   * [代码集成示例](#代码集成示例)   
      * [广告形式](#广告形式)   
         * [Banner](#banner)   
            * [初始化及请求横幅](#初始化及请求横幅)   
            * [设置 Banner 尺寸](#设置-banner-尺寸)   
            * [移除 Banner](#移除-banner)   
            * [实现代理方法](#实现代理方法)   
            * [自适应功能](#自适应功能)   
         * [Interstitial](#interstitial)   
            * [初始化及请求插屏](#初始化及请求插屏)   
            * [展示插屏](#展示插屏)   
            * [实现代理方法](#实现代理方法-1)   
         * [Rewarded Video](#rewarded-video)   
            * [初始化及请求视频](#初始化及请求视频)   
            * [展示视频](#展示视频)   
            * [实现代理方法](#实现代理方法-2)   
         * [Splash](#splash)   
            * [初始化及展示开屏](#初始化及展示开屏)   
               * [展示全屏广告](#展示全屏广告)   
               * [展示半屏广告](#展示半屏广告)   
            * [实现代理方法](#实现代理方法-3)
         * [Native](#native)   
            * [初始化及请求](#初始化及请求)   
            * [Register View](#register-view)   
            * [Report Impression](#report-impression)   
            * [实现代理方法](#实现代理方法-4)   
   * [调试模式](#调试模式)
      * [接入方式](#接入方式-1)
      * [调用调试模式](#调用调试模式)   
      * [图示](#图示)   
      * [测试广告位](#测试广告位)

# YumiMediationSDK iOS

## 概述

1. 面向人群

   本产品主要面向需要在 iOS 产品中接入玉米移动广告 SDK 的开发人员。

2. 开发环境

   Xcode 7.0 或更高版本。

   iOS 8.0 或更高版本。

3. [Demo 获取地址](https://github.com/yumimobi/YumiMediationSDKDemo-iOS.git)         
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

## 接入方式

- CocoaPods (推荐)

   CocoaPods 是 iOS 的依赖管理工具，使用它可以轻松管理 YumiMediationSDK。

   打开您工程的 Podfile，选择下面其中一种方式添加到您应用的 target。

   如果您是初次使用 CocoaPods，请查阅 [CocoaPods Guides](https://guides.cocoapods.org/using/using-cocoapods.html) 。

   - 如果您只需要 YumiMediationSDK 

     ```ruby
     pod "YumiMediationSDK"
     ```

   - 如果您需要聚合其他平台

     ```ruby
     pod "YumiMediationAdapters", :subspecs => ['AdColony','AdMob','AppLovin','Baidu','Chartboost','Domob','Facebook','GDT','InMobi','IronSource','Unity','Vungle','Mintegral','OneWay','PlayableAds']
     ```

   接下来在命令行界面中运行：

   ```ruby
   $ pod install --repo-update
   ```

   最终通过 workspace 打开工程。

- 手动集成 YumiMediationSDK

   1. 下载 ([SDKDownloadPage-iOS](https://github.com/yumimobi/YumiMediationSDKDemo-iOS/blob/master/normalDocuments/iOSDownloadPage.md)) YumiMediationSDK 及您所需的三方平台

   2. 添加 YumiMediationSDK 及您所需的三方平台到您的工程

      <img src="resources/addFiles.png" width="280" height="320"> 

      <img src="resources/addFiles-2.png" width="500" height="400"> 

   3. 配置脚本

      按照如图所示步骤，添加 YumiMediationSDKConfig.xcconfig

      ![ios02](resources/ios02.png) 

   4. 导入 Framework

      导入如图所示的系统动态库。

      ![ios06](resources/ios06.png) 

## 代码集成示例

### 广告形式

#### Banner

- ##### 初始化及请求横幅

  ```objective-c
  #import <YumiMediationSDK/YumiMediationBannerView.h>

  @interface ViewController ()<YumiMediationBannerViewDelegate>
  @property (nonatomic) YumiMediationBannerView *yumiBanner;
  @end
    
  @implementation ViewController

  //init yumiBanner
  - (void)viewDidLoad {
  	[super viewDidLoad];
  	self.yumiBanner = [[YumiMediationBannerView alloc] 
                       initWithPlacementID:@"Your PlacementID" 			
                         		   channelID:@"Your ChannelID" 
                                 versionID:@"Your VersionNumber"
                                  position:YumiMediationBannerPositionBottom
                        rootViewController:self];
    	self.yumiBanner.delegate = self;
    	[self.yumiBanner loadAd:YES];
      [self.view addSubview:self.yumiBanner];
  }
  @end
  ```

- ##### 设置 Banner 尺寸

  ```objective-c
  //目前我们支持三种尺寸
  //在 iPhone 上默认为 320 * 50，如无调整不需设置下列代码。
  //在 iPad 上默认为 728 * 90，如无调整不需设置下列代码。
  //如果您有特殊需求，300 * 250 为可选项。请在 loadAd 之前，执行下列代码。
  self.yumiBanner.bannerSize = kYumiMediationAdViewBanner300x250;
  ```

- ##### 移除 Banner

  ```objective-c
  //remove yumiBanner
  - (void)viewWillDisappear:(BOOL)animated {
      [super viewWillDisappear:animated];
      if (_yumiBanner) {
          [_yumiBanner removeFromSuperview];
          _yumiBanner = nil;
      }
  }
  ```

- ##### 实现代理方法 

  ```objective-c
  //implementing yumiBanner delegate
  - (void)yumiMediationBannerViewDidLoad:(YumiMediationBannerView *)adView{
      NSLog(@"adViewDidReceiveAd");
  }
  - (void)yumiMediationBannerView:(YumiMediationBannerView *)adView didFailWithError:(YumiMediationError *)error{
      NSLog(@"adView:didFailToReceiveAdWithError: %@", error);
  }
  - (void)yumiMediationBannerViewDidClick:(YumiMediationBannerView *)adView{
      NSLog(@"adViewDidClick");
  }
  ```

- ##### 自适应功能

  ```objective-c
  - (void)loadAd:(BOOL)isSmartBanner;
  ```

  您在请求 `banner` 广告的同时可以设置是否开启自适应功能。

  如果设置 `isSmartBanner` 为 `YES` ,YumiMediationBannerView 将会自动根据设备的尺寸进行适配。

  此时您可以通过下面的方法获取 YumiMediationBannerView 的尺寸。

  ```objective-c
  - (CGSize)fetchBannerAdSize;
  ```

 ![fzsy](resources/fzsy.png) ![zsy](resources/zsy.png) 

​	*非自适应模式* 		  *自适应模式*										

#### Interstitial

- ##### 初始化及请求插屏

  ```objective-c
  #import <YumiMediationSDK/YumiMediationInterstitial.h>

  @interface ViewController ()<YumiMediationInterstitialDelegate>
  @property (nonatomic) YumiMediationInterstitial *yumiInterstitial;
  @end

  @implementation ViewController
  //init yumiInterstitial
  - (void)viewDidLoad {
  	[super viewDidLoad];
   	self.yumiInterstitial =  [[YumiMediationInterstitial alloc] 
                                initWithPlacementID:@"Your PlacementID"
  							            channelID:@"Your channelID"
  							            versionID:@"Your versionID"
  							   rootViewController:self];
    	self.yumiInterstitial.delegate = self;
  }
  @end
  ```

- ##### 展示插屏

  ```objective-c
  //present YumiMediationInterstitial
  - (IBAction)presentYumiMediationInterstitial:(id)sender {
  	if ([self.yumiInterstitial isReady]) {
      	[self.yumiInterstitial present];
    } else {
      	NSLog(@"Ad wasn't ready");
    }
  }
  ```

- ##### 实现代理方法

  ```objective-c
  //implementing YumiMediationInterstitial Delegate
  - (void)yumiMediationInterstitialDidReceiveAd:(YumiMediationInterstitial *)interstitial{
      NSLog(@"interstitialDidReceiveAd");
  }
  - (void)yumiMediationInterstitial:(YumiMediationInterstitial *)interstitial
                   didFailWithError:(YumiMediationError *)error{
      NSLog(@"interstitial:didFailToReceiveAdWithError: %@", error)
  }
  - (void)yumiMediationInterstitialWillDismissScreen:(YumiMediationInterstitial *)interstitial{
      NSLog(@"interstitialWillDismissScreen");
  }
  - (void)yumiMediationInterstitialDidClick:(YumiMediationInterstitial *)interstitial{
      NSLog(@"interstitialDidClick");
  }
  ```

#### Rewarded Video

- ##### 初始化及请求视频

  ```objective-c
  #import <YumiMediationSDK/YumiMediationVideo.h>
   
  @implementation ViewController
  - (void)viewDidLoad {
  	[super viewDidLoad];
      [[YumiMediationVideo sharedInstance] loadAdWithPlacementID:@"Your PlacementID" 
       									             channelID:@"Your channelID" 
       									             versionID:@"Your versionID"];
    	[YumiMediationVideo sharedInstance].delegate = self;
  }
  @end
  ```

- ##### 展示视频

  ```objective-c
  - (IBAction)presentYumiMediationVideo:(id)sender {
  	if ([[YumiMediationVideo sharedInstance] isReady]) {
      	 [[YumiMediationVideo sharedInstance] presentFromRootViewController:self];
    } else {
      	NSLog(@"Ad wasn't ready");
    }
  }
  ```

- ##### 实现代理方法

  ```objective-c
  - (void)yumiMediationVideoDidOpen:(YumiMediationVideo *)video{
      NSLog(@"Opened reward video ad.");
  }
  - (void)yumiMediationVideoDidStartPlaying:(YumiMediationVideo *)video{
      NSLog(@"Reward video ad started playing.");
  }
  - (void)yumiMediationVideoDidClose:(YumiMediationVideo *)video{
      NSLog(@"Reward video ad is closed.");
  }
  - (void)yumiMediationVideoDidReward:(YumiMediationVideo *)video{
      NSLog(@"is Reward");
  }
  ```

#### Splash

- ##### 初始化及展示开屏

  为了保证开屏的展示，我们推荐尽量在 App 启动时开始执行下面的方法。

  例如：在您 `AppDelegate.m` 的 `application:didFinishLaunchingWithOptions:` 方法中。

  ```objective-c
  #import <YumiMediationSDK/YumiAdsSplash.h>
  ```

- ###### 展示全屏广告

  ```objective-c
  //appKey 为预留字段，可填空字符串。
  [[YumiAdsSplash sharedInstance] showYumiAdsSplashWith:@"Your PlacementID"
   											   appKey:@"nullable" 
   								   rootViewController:self.window.rootViewController 
   											 delegate:self]
  ```

- ###### 展示半屏广告

  ```objective-c
  //appKey 为预留字段，可填空字符串。
  UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-100,
          [UIScreen mainScreen].bounds.size.width, 100)]; 
  view.backgroundColor = [UIColor redColor];
  //view is your customView.You can show your logo there.
  //warning:view's frame is nonnull.
  [[YumiAdsSplash sharedInstance] showYumiAdsSplashWith:@"Your PlacementID" 
   											   appKey:@"nullable" 
   									 customBottomView:view
                                     rootViewController:self.window.rootViewController 
   											 delegate:self];
  ```

- ##### 实现代理方法

  ```objective-c
  - (void)yumiAdsSplashDidLoad:(YumiAdsSplash *)splash{
      NSLog(@"yumiAdsSplashDidLoad.");
  }
  - (void)yumiAdsSplash:(YumiAdsSplash *)splash DidFailToLoad:(NSError *)error{
      NSLog(@"yumiAdsSplash:DidFailToLoad: %@", error)
  }
  - (void)yumiAdsSplashDidClicked:(YumiAdsSplash *)splash{
      NSLog(@"yumiAdsSplashDidClicked.");
  }
  - (void)yumiAdsSplashDidClosed:(YumiAdsSplash *)splash{
      NSLog(@"yumiAdsSplashDidClosed.");
  }
  - (nullable UIImage *)yumiAdsSplashDefaultImage{
      return UIImage;//Your default image when app start
  }
  ```

#### Native

- ##### 初始化及请求

  ```objective-c
  #import <YumiMediationSDK/YumiMediationNativeAd.h>

  @interface ViewController ()<YumiMediationNativeAdDelegate>
  @property (nonatomic) YumiMediationNativeAd *yumiNativeAd;
  @end
   
  @implementation ViewController
  - (void)viewDidLoad {
  	[super viewDidLoad];
   	 self.yumiNativeAd = [[YumiMediationNativeAd alloc] 
  					                        initWithPlacementID:@"Your PlacementID" 
                                                        channelID:@"Your channelID" 
                                                        versionID:@"Your versionID"];
       self.yumiNativeAd.delegate = self;
    	 [self.nativeAd loadAd:1];//You can request more than one ad.
  }
  @end
  ```

- ##### Register View

  ```objective-c
  /**
   注册用来渲染广告的 View
   - Parameter view: 渲染广告的 View.
   - Parameter viewController: 将用于当前的ui SKStoreProductViewController(iTunes商店产品信息)或	应用程序的浏览器。
   整个渲染区域可点击。
   */
  - (void)registerViewForInteraction:(UIView *)view
                  withViewController:(nullable UIViewController *)viewController
                            nativeAd:(YumiMediationNativeModel *)nativeAd;
  ```

- ##### Report Impression

  ```objective-c
  /**
   当原生广告被展示时调用此方法
   - Parameter nativeAd: 将要被展示的广告对象.
   - Parameter view: 用来渲染广告的 View.
  */
  - (void)reportImpression:(YumiMediationNativeModel *)nativeAd view:(UIView *)view;
  ```

- ##### 实现代理方法

  ```objective-c
  /// Tells the delegate that an ad has been successfully loaded.
  - (void)yumiMediationNativeAdDidLoad:(NSArray<YumiMediationNativeModel *> *)nativeAdArray{
      NSLog(@"Native Ad Did Load.");
  }

  /// Tells the delegate that a request failed.
  - (void)yumiMediationNativeAd:(YumiMediationNativeAd *)nativeAd didFailWithError:(YumiMediationError *)error{
      NSLog(@"NativeAd Did Fail With Error.");
  }

  /// Tells the delegate that the Native view has been clicked.
  - (void)yumiMediationNativeAdDidClick:(YumiMediationNativeModel *)nativeAd{
      NSLog(@"Native Ad Did Click.");
  }
  ```

## 调试模式

如果您想调试平台key是否有广告返回，可选择调试模式。

调用调试模式之前，请保证您的 app 已经初始化 YumiMediationSDK 。

### 接入方式

- CocoaPods（推荐）

  ```ruby
  pod "YumiMediationDebugCenter-iOS" 
  ```


- 手动方式

  将下载好的``YumiMediationDebugCenter-iOS.framework``加入``Xcode``工程即可。 

  [**DownloadPage-iOS**](https://github.com/yumimobi/YumiMediationSDKDemo-iOS/blob/master/normalDocuments/iOSDownloadPage.md)

### 调用调试模式

```objective-c
#import <YumiMediationDebugCenter-iOS/YumiMediationDebugController.h>

[[YumiMediationDebugController sharedInstance] 
	presentWithBannerPlacementID:@"Your BannerPlacementID"
	     interstitialPlacementID:@"Your interstitialPlacementID"
	            videoPlacementID:@"Your videoPlacementID"
	           nativePlacementID:@"Your nativePlacementID"
	                   channelID:@"Your channelID"
	                   versionID:@"Your versionID"
	          rootViewController:self];//your rootVC
```

### 图示

<img src="resources/debug-1.png" width="240" height="426">

选择平台类型

<img src="resources/debug-2.png" width="240" height="426">

选择单一平台，灰色平台为已添加未配置

<img src="resources/debug-3.png" width="240" height="426">

选择广告类型，调试单一平台

### 测试广告位

| 平台   | Banner   | Interstitial | Rewarded Video | Native   | Splash   |
| ---- | -------- | ------------ | -------------- | -------- | -------- |
| iOS  | l6ibkpae | onkkeg5i     | 5xmpgti4       | atb3ke1i | pwmf5r42 |







