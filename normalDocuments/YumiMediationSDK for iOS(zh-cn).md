* [YumiMediationSDK iOS](#yumimediationsdk-ios)   
   * [概述](#概述)   
   * [开发环境配置](#开发环境配置)   
      * [App Transport Security](#app-transport-security)
      * [<a href="./ThirdpartyNetworkConfiguration/ThirdpartyNetworkConfiguration.md">各三方平台环境配置</a>](#各三方平台环境配置)
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
            * [设置开屏拉取时长](#设置开屏拉取时长)
            * [设置开屏加载时的背景图片](#设置开屏加载时的背景图片)
            * [设置开屏方向（只支持 Admob 平台）](#设置开屏方向（只支持-Admob-平台）)   
            * [展示全屏广告](#展示全屏广告)   
            * [展示半屏广告](#展示半屏广告)   
            * [实现代理方法](#实现代理方法-3)
         * [Native](#native)   
            * [初始化及请求](#初始化及请求) 
            * [何时请求广告](#何时请求广告)  
            * [确定加载完成时间](#确定加载完成时间)
            * [Register View](#register-view)   
            * [Report Impression](#report-impression)   
            * [原生视频广告](#原生视频广告) 
            * [原生广告选项 YumiMediationNativeAdConfiguration](#原生广告选项-yumimediationnativeadconfiguration)  
            * [实现代理方法](#实现代理方法-4)   
   * [调试模式](#调试模式)
      * [接入方式](#接入方式-1)
      * [调用调试模式](#调用调试模式)   
      * [图示](#图示)   
      * [TEST ID](#TEST-ID)
      * [GDPR](#gdpr)
         * [设置 GDPR](#设置-gdpr)
         * [支持 GDPR 的平台](#支持-gdpr-的平台)

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

  ```xml
  <key>NSAppTransportSecurity</key>
  <dict>
      <key>NSAllowsArbitraryLoads</key>
      <true/>
  </dict>
  ```

  ![ats_exceptions](resources/ats_exceptions.png)

  *当 `NSAllowsArbitraryLoads` 和 `NSAllowsArbitraryLoadsInWebContent` 或 `NSAllowsArbitraryLoadsForMedia` 同时存在时，根据系统不同，表现的行为也会不一样。简单说，iOS 9 只看 `NSAllowsArbitraryLoads`，而 iOS 10 会优先看 `InWebContent` 和 `ForMedia` 的部分。在 iOS 10 中，要是后两者存在的话，在相关部分就会忽略掉 `NSAllowsArbitraryLoads`；如果不存在，则遵循 `NSAllowsArbitraryLoads` 的设定。*

- ### [各三方平台环境配置](./ThirdpartyNetworkConfiguration/ThirdpartyNetworkConfiguration.md)
  请按照您接入的三方平台，进行相关配置。此内容来源于各三方平台开发文档。


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
     pod "YumiMediationAdapters", :subspecs => ['AdColony','AdMob','AppLovin','Baidu','Chartboost','Domob','Facebook','GDT','InMobi','IronSource','Unity','Vungle','Mintegral','OneWay','ZplayAds','IQzone','BytedanceAds','InneractiveAdSDK']
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
  //调用 `loadAd:` 方法后，banner 广告位会自动填充，无需重复调用。
  //如果您不想自动填充 banner 广告位，可以调用 `disableAutoRefresh` 方法。
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
/// Represents the fixed banner ad size
typedef NS_ENUM(NSUInteger, YumiMediationAdViewBannerSize) {
    /// iPhone and iPod Touch ad size. Typically 320x50.
    kYumiMediationAdViewBanner320x50 = 1 << 0,
    // Leaderboard size for the iPad. Typically 728x90.
    kYumiMediationAdViewBanner728x90 = 1 << 1,
    // Represents the fixed banner ad size - 300pt by 250pt.
    kYumiMediationAdViewBanner300x250 = 1 << 2,
    /// An ad size that spans the full width of the application in portrait orientation. 
    /// The height is typically 50 pixels on an iPhone/iPod UI, and 90 pixels tall on an iPad UI.
    kYumiMediationAdViewSmartBannerPortrait = 1 << 3,
    /// An ad size that spans the full width of the application in landscape orientation. 
    /// The height is typically 32 pixels on an iPhone/iPod UI, and 90 pixels tall on an iPad UI.
    kYumiMediationAdViewSmartBannerLandscape = 1 << 4
};
```

```objective-c
  //在 iPhone 上默认为 320 * 50，如无调整不需设置下列代码。
  //在 iPad 上默认为 728 * 90，如无调整不需设置下列代码。
  //如果您有特殊需求，可根据枚举所述尺寸，在 loadAd 之前，执行下列代码。
  self.yumiBanner.bannerSize = kYumiMediationAdViewBanner300x250;
```

- ##### 移除 Banner

  ```objective-c
  //remove yumiBanner
  - (void)viewWillDisappear:(BOOL)animated {
      [super viewWillDisappear:animated];
      if (_yumiBanner) {
      	[_yumiBanner disableAutoRefresh];
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
  //插屏广告位会自动加载广告，您无需重复调用。
  - (void)viewDidLoad {
    [super viewDidLoad];
    self.yumiInterstitial = [[YumiMediationInterstitial alloc] 
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
  /// Tells the delegate that the interstitial ad request succeeded.
  - (void)yumiMediationInterstitialDidReceiveAd:(YumiMediationInterstitial *)interstitial {
    NSLog(@"YumiMediationInterstitialDidReceiveAd");
  }
  /// Tells the delegate that the interstitial ad failed to load.
  - (void)yumiMediationInterstitial:(YumiMediationInterstitial *)interstitial
             didFailToLoadWithError:(YumiMediationError *)error {
    NSLog(@"YumiMediationInterstitialDidFailToLoadWithError: %@", [error localizedDescription]);
  }
  /// Tells the delegate that the interstitial ad failed to show.
  - (void)yumiMediationInterstitial:(YumiMediationInterstitial *)interstitial
             didFailToShowWithError:(YumiMediationError *)error {
    NSLog(@"YumiMediationInterstitialDidFailToShowWithError: %@", [error localizedDescription]);
  }
  /// Tells the delegate that the interstitial ad opened.
  - (void)yumiMediationInterstitialDidOpen:(YumiMediationInterstitial *)interstitial {
    NSLog(@"YumiMediationInterstitialDidOpen);
  }
  /// Tells the delegate that the interstitial ad start playing.
  - (void)yumiMediationInterstitialDidStartPlaying:(YumiMediationInterstitial *)interstitial {
    NSLog(@"YumiMediationInterstitialDidStartPlaying);
  }
  /// Tells the delegate that the interstitial is to be animated off the screen.
  - (void)yumiMediationInterstitialDidClosed:(YumiMediationInterstitial *)interstitial {
    NSLog(@"YumiMediationInterstitialDidClosed);
  }
  /// Tells the delegate that the interstitial ad has been clicked.
  - (void)yumiMediationInterstitialDidClick:(YumiMediationInterstitial *)interstitial {
    NSLog(@"YumiMediationInterstitialDidClick);
  }
  ```

#### Rewarded Video

- ##### 初始化及请求视频

  ```objective-c
  //视频广告位会自动加载广告，您无需重复调用。
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
  /// Tells the delegate that the video ad was received.
  - (void)yumiMediationVideoDidReceiveAd:(YumiMediationVideo *)video {
      NSLog(@"YumiMediationVideoDidReceiveAd");
  }
  /// Tells the delegate that the video ad failed to load.
  - (void)yumiMediationVideo:(YumiMediationVideo *)video didFailToLoadWithError:(NSError *)error {
      NSLog(@"YumiMediationVideoDidFailToLoadWithError:%@",[error localizedDescription]);
  }
  /// Tells the delegate that the video ad failed to show.
  - (void)yumiMediationVideo:(YumiMediationVideo *)video didFailToShowWithError:(NSError *)error {
      NSLog(@"YumiMediationVideoDidFailToShowWithError:%@",[error localizedDescription]);
  }
  /// Tells the delegate that the video ad opened.
  - (void)yumiMediationVideoDidOpen:(YumiMediationVideo *)video {
      NSLog(@"YumiMediationVideoDidOpen");
  }
  /// Tells the delegate that the video ad start playing.
  - (void)yumiMediationVideoDidStartPlaying:(YumiMediationVideo *)video {
      NSLog(@"YumiMediationVideoDidStartPlaying");
  }
  /// Tells the delegate that the video ad closed.
  /// You can learn about the reward info by examining the ‘isRewarded’ value.
  - (void)yumiMediationVideoDidClosed:(YumiMediationVideo *)video isRewarded:(BOOL)isRewarded {
      NSLog(@"YumiMediationVideoDidClosedWithReward:%d",isRewarded);
  }
  /// Tells the delegate that the video ad has rewarded the user.
  - (void)yumiMediationVideoDidReward:(YumiMediationVideo *)video {
      NSLog(@"YumiMediationVideoDidReward");
  }
  /// Tells the delegate that the reward video ad has been clicked by the person.
  - (void)yumiMediationVideoDidClick:(YumiMediationVideo *)video {
      NSLog(@"YumiMediationVideoDidClick");
  }
  ```

#### Splash

- ##### 初始化及展示开屏

  为了保证开屏的展示，我们推荐尽量在 App 启动时开始执行下面的方法。

  例如：在您 `AppDelegate.m` 的 `application:didFinishLaunchingWithOptions:` 方法中。

  ```objective-c
  #import <YumiMediationSDK/YumiMediationSplash.h>

  @interface AppDelegate () <YumiMediationSplashAdDelegate>

  @property (nonatomic) YumiMediationSplash *yumiSplash;

  @end

  @implementation AppDelegate
    
  - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  	
    self.yumiSplash = [[YumiMediationSplash alloc] initWithPlacementID:@"YOUR_PLACEMWNT_ID" channelID:@"YOUR_CHANNEL_ID" versionID:@"YOUR_VERSION_ID"];
    self.yumiSplash.delegate = self;
    
      return YES;
  }

  @end
  ```

- ##### 设置开屏拉取时长
  ```objective-c
  /// 拉取广告超时时间，默认3s。在该超时时间内，如果广告拉取成功，则立马展示开屏广告，否则放弃此次广告展示机会。
  /// 百度 平台不支持 这个参数
  [self.yumiSplash setFetchTime:3]; 
  ```

- ##### 设置开屏加载时的背景图片

  ```objective-c
  /// 开屏加载时的背景图片，最好是 APP 启动的 launch image
  [self.yumiSplash setLaunchImage:[UIImage imageNamed:@"YOUR_IMAGENAME"]];
  ```

- ##### 设置开屏方向（只支持 Admob 平台）

  ```objective-c
  /// 开屏的方向
  [self.yumiSplash setInterfaceOrientation:UIInterfaceOrientationPortrait];
  ```



- ##### 展示全屏广告

  ```objective-c
  [self.yumiSplash loadAdAndShowInWindow:[UIApplication sharedApplication].keyWindow];
  ```

- ##### 展示半屏广告

  ```objective-c
  /// bottom view 的高度不能超过屏幕高度的15%
  UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.10)];
  bottomView.backgroundColor = [UIColor redColor];
  [self.yumiSplash loadAdAndShowInWindow:[UIApplication sharedApplication].keyWindow withBottomView:bottomView];
  ```

- ##### 实现代理方法

  ```objective-c
  - (void)yumiMediationSplashAdSuccessToShow:(YumiMediationSplash *)splash {
      NSLog(@"yumiMediationSplashAdSuccessToShow.");
  }
  - (void)yumiMediationSplashAdFailToShow:(YumiMediationSplash *)splash withError:(NSError *)error {
      NSLog(@"yumiMediationSplashAdFailToShow: %@", error)
  }
  - (void)yumiMediationSplashAdDidClick:(YumiMediationSplash *)splash {
      NSLog(@"yumiMediationSplashAdDidClick.");
  }
  - (void)yumiMediationSplashAdDidClose:(YumiMediationSplash *)splash {
      NSLog(@"yumiMediationSplashAdDidClose.");
  }
  ```

#### Native

- ##### 初始化及请求

  ```objectivec 
  #import <YumiMediationSDK/YumiMediationNativeAd.h>
  #import <YumiMediationSDK/YumiMediationNativeAdConfiguration.h>
  
  @interface ViewController ()<YumiMediationNativeAdDelegate>
  @property (nonatomic) YumiMediationNativeAd *yumiNativeAd;
  @end
   
  @implementation ViewController
  - (void)viewDidLoad {
    [super viewDidLoad];
    YumiMediationNativeAdConfiguration *config = [[YumiMediationNativeAdConfiguration alloc] init];
    self.yumiNativeAd = [[YumiMediationNativeAd alloc] initWithPlacementID:@"Your PlacementID"
                                                                 channelID:@"Your channelID"
                                                                 versionID:@"Your versionID"
                                                             configuration:config];
    self.yumiNativeAd.delegate = self;
    [self.nativeAd loadAd:1];//You can request more than one ad.
  }
  @end
  ```
- ##### 何时请求广告

  展示原生广告的应用可以在实际展示广告之前随时请求这些广告。在许多情况下，这是推荐的做法。例如，如果某款应用展示一个商品清单，其中会夹杂一些原生广告，那么该应用就可以加载整个清单中的原生广告，因为它知道一些广告仅在用户滚动浏览视图后才会展示，还有一些可能根本不会展示。

   - 注意：尽管预先提取广告是一种很好的方法，但务必不要长久保留旧广告而不进行展示。对任何原生广告对象来说，如果在保留30分钟后仍没有获得展示，就应该予以舍弃，并替换为来自新请求的新广告。
    您可通过 `YumiMediationNativeModel.h` 中的 `-(BOOL)isExpired;` 来判断当前广告是否过期。

   - 注意：重复使用 `loadAd:` 时，请确保等待每个请求完成，然后再重新调用 `loadAd:`。

- ##### 确定加载完成时间

   在应用调用 `loadAd:` 后，可通过`YumiMediationNativeAdDelegate` 中的以下方法获取请求的结果：

    ```objectivec
    /// Tells the delegate that an ad has been successfully loaded.
    - (void)yumiMediationNativeAdDidLoad:(NSArray<YumiMediationNativeModel *> *)nativeAdArray;
    ```

    ```objectivec
    /// Tells the delegate that a request failed.
    - (void)yumiMediationNativeAd:(YumiMediationNativeAd *)nativeAd didFailWithError:(YumiMediationError *)error;
    ```

- ##### Register View

    ```objectivec
    /**
        注册用来渲染广告的 View
        - Parameter view: 渲染广告的 View.
        - Parameter clickableAssetViews: 可用于点击 view 的字典，使用 YumiMediationUnifiedNativeAssetIdentifier 为 key
        - Parameter viewController: 将用于当前的ui SKStoreProductViewController(iTunes商店产品信息)或	应用程序的浏览器。
        - Parameter nativeAd: 用于展示的原生广告模型对象
        */
    - (void)registerViewForInteraction:(UIView *)view
                   clickableAssetViews: (NSDictionary<YumiMediationUnifiedNativeAssetIdentifier, UIView *> *)clickableAssetViews
                    withViewController:(nullable UIViewController *)viewController
                              nativeAd:(YumiMediationNativeModel *)nativeAd;
    
    /// 例子：
    [self.nativeAd registerViewForInteraction:self.nativeView.adView
                                    clickableAssetViews:@{
                                                          YumiMediationUnifiedNativeTitleAsset : self.nativeView.title,
                                                          YumiMediationUnifiedNativeDescAsset : self.nativeView.desc,
                                                          YumiMediationUnifiedNativeCoverImageAsset : self.nativeView.coverImage,
                                                          YumiMediationUnifiedNativeMediaViewAsset : self.nativeView.mediaView,
                                                          YumiMediationUnifiedNativeIconAsset : self.nativeView.icon,
                                                          YumiMediationUnifiedNativeCallToActionAsset : self.nativeView.callToAction
                                                          }
                                     withViewController:self
                                               nativeAd:adData];
    ```
    - 注意: 如果您使用 `UIButton` 来展示原生广告元素，必须禁用 `userInteractionEnabled`，以便 SDK 处理事件。
           最好的方式是避免使用 `UIButton`，而使用 `UILabel` 或者 `UIImageView`。

    - 如果以这种方式注册视图， SDK 就可以自动处理诸如以下任务：
      1. 记录点击
      2. 显示广告选择叠加层 （AdMob，Facebook 支持）
      3. 显示广告标识

- ##### Report Impression

    ```objectivec
     /**
      当原生广告被展示时调用此方法
      - Parameter nativeAd: 将要被展示的广告对象.
      - Parameter view: 用来渲染广告的 View.
     */
     - (void)reportImpression:(YumiMediationNativeModel *)nativeAd view:(UIView *)view;
    ```

- ##### 原生视频广告

  - 如果您想在原生广告中展示视频，您仅需要在注册视图时，将您的 MediaView 传入 SDK。 `YumiMediationUnifiedNativeMediaViewAsset : self.nativeView.mediaView`。
 SDK 会自动处理此填充事宜：
    1. *如果有视频素材资源可用，则系统会对其进行缓冲，并在您传入的 MediaView 中播放。*
    2. *如果广告中不包含视频素材资源，则会改为下载第一个图片素材资源，并放置在您传入的 MediaView 中。*
    ```objectivec
    [self.nativeAd registerViewForInteraction:self.nativeView.adView
                                    clickableAssetViews:@{
                                                          YumiMediationUnifiedNativeTitleAsset : self.nativeView.title,
                                                          YumiMediationUnifiedNativeDescAsset : self.nativeView.desc,
                                                          YumiMediationUnifiedNativeCoverImageAsset : self.nativeView.coverImage,
                                                          YumiMediationUnifiedNativeMediaViewAsset : self.nativeView.mediaView,
                                                          YumiMediationUnifiedNativeIconAsset : self.nativeView.icon,
                                                          YumiMediationUnifiedNativeCallToActionAsset : self.nativeView.callToAction
                                                          }
                                     withViewController:self
                                               nativeAd:adData];
    
    ``` 

 

  - 通过 `YumiMediationNativeModel.h` 中的 `hasVideoContent` 您可以判断该原生对象中是否存在视频资源。
    ```objectivec
    /// Indicates whether the ad has video content.
    @property (nonatomic, assign, readonly) BOOL hasVideoContent;
    ```
  - YumiMediationNativeVideoController 提供以下查询视频状态的方法：

    ```objectivec
    /// Delegate for receiving video notifications.
    @property(nonatomic, weak) id<YumiMediationNativeVideoControllerDelegate> delegate;

    /// Play the video. Doesn't do anything if the video is already playing.
    - (void)play;

    /// Pause the video. Doesn't do anything if the video is already paused.
    - (void)pause;

    /// Returns the video's aspect ratio (width/height) or 0 if no video is present.
    /// baidu always return 0
    - (double)aspectRatio;

    @protocol YumiMediationNativeVideoControllerDelegate<NSObject>
    @optional
    /// Tells the delegate that the video controller has began or resumed playing a video.
    - (void)yumiMediationNativeVideoControllerDidPlayVideo:(YumiMediationNativeVideoController *)videoController;

    /// Tells the delegate that the video controller has paused video.
    - (void)yumiMediationNativeVideoControllerDidPauseVideo:(YumiMediationNativeVideoController *)videoController;

    /// Tells the delegate that the video controller's video playback has ended.
    - (void)yumiMediationNativeVideoControllerDidEndVideoPlayback:(YumiMediationNativeVideoController *)videoController;

    @end
    ```

- ##### 原生广告选项 `YumiMediationNativeAdConfiguration`

   `YumiMediationNativeAdConfiguration` 是 `YumiMediationNativeAd` 的创建过程中包含的最后一个参数，本节将介绍这些选项。

   - `disableImageLoading`

     通过包含 `image`, `imageURL` 和 `ratios` 属性的 YumiMediationNativeAdImage 实例返回原生广告的图片素材资源。如果 disableImageLoading 设置为 false（这是默认值，在 Objective-C 中为 NO），则 SDK 会自动获取图片素材资源，并为您填充各项属性。不过，如果设置为 true（在 Objective-C 中为 YES），SDK 将只填充 imageURL，从而允许您自行决定是否下载实际图片。

   - `preferredAdChoicesPosition`
     
     您可以使用该属性指定“广告选择”图标应放置的位置。该图标可以显示在广告的任一角，默认为 YumiMediationAdChoicesPositionTopRightCorner。

   - `preferredAdAttributionPosition`
     
     您可以使用该属性指定广告标识图标应放置的位置。该图标可以显示在广告的任一角，默认为 YumiMediationAdViewPositionTopLeftCorner。

   - `preferredAdAttributionText`
     
     您可以使用该属性指定广告标识的文案。根据手机语言显示为“广告”或者“Ad”。

   - `preferredAdAttributionTextColor`
     
     您可以使用该属性指定广告标识的文字颜色。默认白色。

   - `preferredAdAttributionTextBackgroundColor`
     
     您可以使用该属性指定广告标识的背景颜色。默认灰色。

   - `preferredAdAttributionTextFont`
     
     您可以使用该属性指定广告标识的字体大小。默认10。

   - `hideAdAttribution`
     
     您可以使用该属性指定广告标识是否显示。默认显示。

- ##### 实现代理方法

   ```objectivec
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
             splashPlacementID:@"Your splashPlacementID"
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

### TEST ID

 

| 广告类型               | Slot(Placement) ID                                                                                                                | 备注                                                                                                                               |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| Banner                 | l6ibkpae                                                                                                                          | YUMI,AdMob,APPlovin,Baidu,Facebook,GDTMob  使用此test id,以上Network平台可测试到对应平台广告                                                 |
| Interstitial  | onkkeg5i | YUMI,AdMob,Baidu,Chartboost,GDTMob,IronSource,Inmobi,IQzone, untiy Ads，vungle, ZPLAYAds 使用此test id,以上Network平台可测试到对应平台广告 |
| Rewarded Video         | 5xmpgti4                                                                                                                          | YUMI,AdMob,Adcolony, APPlovin,IronSource,Inmobi,Mintegral, untiy Ads，vungle, ZPLAYAds 使用此test id,以上Network平台可测试到对应平台广告 |
| Native                 | atb3ke1i                                                                                                                          | YUMI,AdMob,Baidu,GDTMob,Facebook 使用此test id,以上Network平台可测试到对应平台广告                                        |
| Splash                 | pwmf5r42                                                                                                                         | YUMI,Baidu,GDTMob,AdMob,穿山甲 使用 test id，以上Network平台可测试到对应平台广告                                                                                               |
## GDPR
本文件是为遵守欧洲联盟的一般数据保护条例(GDPR)而提供的。
自 YumiMediationSDK 4.1.0 起，如果您正在收集用户的信息，您可以使用下面提供的api将此信息通知给 YumiMediationSDK 和部分三方平台。
更多信息请查看我们的官网。
### 设置 GDPR

```objective-c
typedef enum : NSUInteger {
    /// The user has granted consent for personalized ads.
    YumiMediationConsentStatusPersonalized,
    /// The user has granted consent for non-personalized ads.
    YumiMediationConsentStatusNonPersonalized,
    /// The user has neither granted nor declined consent for personalized or non-personalized ads.
    YumiMediationConsentStatusUnknown,
} YumiMediationConsentStatus;
```

```objective-c
// Your user's consent. In this case, the user has given consent to store and process personal information.
[[YumiMediationGDPRManager sharedGDPRManager] updateNetworksConsentStatus:YumiMediationConsentStatusPersonalized];
```
### 支持 GDPR 的平台
统计自 YumiMediationSDK 4.1.0 起。
详细信息请至各平台官网获取。

| 平台名称 | 是否支持 GDPR | 备注 |
| :----: | :--------:| :--: |
| Unity  | 是 |   |
| Admob  | 是 |   |
| Mintegral | 是 |   |
| Adcolony  | 是 |   |
| IronSource  | 是 |   |
| Inneractive | 是 |   |
| Chartboost | 是 |   |
| InMobi | 是 |   |
| IQzone | 是 |   |
| Yumi | 是 |   |
| AppLovin  | 是 |   |
| Baidu  | 否 |   |
| Facebook | 否 | 请查阅 Facebook 相关文档 |
| Domob  | 否 |   |
| GDT | 否 |   |
| Vungle | 否 | 可在 Vungle 后台设置 |
| OneWay | 否 |   |
| BytedanceAds | 否 |   |
| ZplayAds  | 否 |   |


