* [YumiMediationSDK iOS](#yumimediationsdk-ios)  
   * [Summary](#summary)       
   * [Develop Encironment Configuration](#develop-encironment-configuration)   
      * [App Transport Security](#app-transport-security)   
      * [<a href="./ThirdpartyNetworkConfiguration/ThirdpartyNetworkConfiguration.md">Thirdparty Network Configuration</a>](#thirdparty-network-configuration)     
   * [Integration Method](#integration-method)   
   * [Code Sample](#code-sample)   
      * [Advertisement Forms](#advertisement-forms)   
         * [Banner](#banner)   
            * [Initialization and banner request](#initialization-and-banner-request)   
            * [Set banner size](#set-banner-size)   
            * [Remove banner](#remove-banner)   
            * [Delegate implementation](#delegate-implementation)   
            * [Self-adaptation](#self-adaptation)   
         * [Interstitial](#interstitial)   
            * [Initialization and interstitial request](#initialization-and-interstitial-request)   
            * [Show Interstitial](#show-interstitial)   
            * [Delegate implementation](#delegate-implementation-1)   
         * [Rewarded Video](#rewarded-video)   
            * [Initialization and rewarded video request](#initialization-and-rewarded-video-request)
            * [Show rewarded video](#show-rewarded-video)   
            * [Delegate implementation](#delegate-implementation-2)   
         * [Splash](#splash)   
            * [Initialization and splash request](#initialization-and-splash-request)   
            * [show splash full screen](#show-splash-full-screen)   
            * [show splash with bottom custom view](#show-splash-with-bottom-custom-view)   
            * [Delegate implementation](#delegate-implementation-3)   
         * [Native](#native)   
            * [Initialization and request](#initialization-and-request) 
            * [When to request ad](#when-to-request-ad)
            * [Register View](#register-view)    
            * [Report Impression](#report-impression) 
            * [Native video ads](#native-video-ads) 
            * [YumiMediationNativeAdConfiguration](#yumimediationnativeadconfiguration)   
            * [Delegate implementation](#delegate-implementation-4)   
   * [Debug Mode](#debug-mode)   
      * [Integration Method](#integration-method-1)   
      * [Call debug mode](#call-debug-mode)   
      * [Sample](#sample)  
      * [Test ad placementIDs](#Test-ad-placementIDs)

# YumiMediationSDK iOS

## Summary

1. To Readers

   This documentation is intended for developers who want to integrate Yumimobi SDK in iOS products.

2. Develop Environment

   Xcode 7.0 and above. 

   iOS 8.0 and above.

3. [ Get Demo ](https://github.com/yumimobi/YumiMediationSDKDemo-iOS.git)

## Develop Encironment Configuration 

- ### App Transport Security

  ATS (App Transport Security) proposed by WWDC 15 features an important method for Apple to boost network communication security. Non-HTTPS access will be banned by default for ios 9 and later.

  As most of materials are provided by HTTP, please set as the followings to improve fillrate：

  ```xml
  <key>NSAppTransportSecurity</key>
  <dict>
      <key>NSAllowsArbitraryLoads</key>
      <true/>
  </dict>
  ```

  ![ats_exceptions](resources/ats_exceptions.png)

  *The `NSAllowsArbitraryLoads` exception is required to make sure your ads are not impacted by ATS on iOS 9 devices, while `NSAllowsArbitraryLoadsForMedia` and `NSAllowsArbitraryLoadsInWebContent` are required to make sure your ads are not impacted by ATS on iOS 10 devices.*

- ### [Thirdparty Network Configuration](./ThirdpartyNetworkConfiguration/ThirdpartyNetworkConfiguration.md)
  Please setting configurations according to the thirdparty network you choose.

## Integration Method

- CocoaPods ( recommend )

  CocoaPods is a dependency manager for ios, which will make it easy to manage YumiMediationSDK.

  Open Podfile, add one of the following methods to target.

  If use CocoaPods for the first time, please view [CocoaPods Guides](https://guides.cocoapods.org/using/using-cocoapods.html).

  - If need YumiMediationSDK only:

    ```ruby
    pod "YumiMediationSDK"
    ```

  - If also need other platforms:

    ```ruby
    pod "YumiMediationAdapters", :subspecs => ['AdColony','AdMob','AppLovin','Baidu','Chartboost','Domob','Facebook','GDT','InMobi','IronSource','Unity','Vungle','Mintegral','OneWay','ZplayAds','IQzone']
    ```

  Then run the followings at command line interface:

  ```shell
  $ pod install --repo-update
  ```

  Finally, open project by workspace. 

- Manually Integrating YumiMediationSDK

  1. Download ([SDKDownloadPage-iOS](https://github.com/yumimobi/YumiMediationSDKDemo-iOS/blob/master/normalDocuments/iOSDownloadPage.md)) YumiMediationSDK and third-party SDK which you need.
  2. Add YumiMediationSDK and third-party SDK to your project

  <img src="resources/addFiles.png" width="280" height="320"> 

  <img src="resources/addFiles-2.png" width="500" height="400"> 

3. Script configuration

   Add YUMISDKConfig according to steps as shown.

   ![ios02](resources/ios02.png) 

4. Import Framework

   Import system dynamic libraries as shown.

   ![ios06](resources/ios06.png) 

## Code Sample

### Advertisement Forms

#### Banner

- ##### Initialization and banner request

  ```objective-c
  #import <YumiMediationSDK/YumiMediationBannerView.h>

  @interface ViewController ()<YumiMediationBannerViewDelegate>
  @property (nonatomic) YumiMediationBannerView *yumiBanner;
  @end
    
  @implementation ViewController

  //init yumiBanner
  //if you implement the method `loadAd:`,the banner placement will auto refresh.You don't need to call this method repeatedly.
  //if you don't want to auto refresh banner,You can implement the method `disableAutoRefresh`.
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

- ##### Set banner size

  ```objective-c
  /// Represents the fixed banner ad size
  typedef NS_ENUM(NSUInteger,
  YumiMediationAdViewBannerSize) {
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
  //The SDK now supports five banner sizes
  //iPhone and iPod Touch ad size. Typically 320x50.If there are no special requirements, there is no need to execute the code below.
  //Leaderboard size for the iPad. Typically 728x90.If there are no special requirements, there is no need to execute the code below.
  //If you have special requirements, select a size from the enumeration and execute the code below.
  self.yumiBanner.bannerSize = kYumiMediationAdViewBanner300x250;
  ```

- ##### Remove banner

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

- ##### Delegate implementation 

  ```objective-c
  //implement yumiBanner delegate
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

- ##### Self-adaptation

  ```objective-c
  - (void)loadAd:(BOOL)isSmartBanner;
  ```

  You are available to set whether to turn on self-adaptation when making `banner` request.

  If `isSmartBanner` is `YES` ,YumiMediationBannerView will automatically adapt to size of device. 

  You are supported to get size of YumiMediationBannerView by the following method.

  ```objective-c
  - (CGSize)fetchBannerAdSize;
  ```

   ![fzsy](resources/fzsy.png)  ![zsy](resources/zsy.png) 

  ​	*non self-adaptation mode* 	  	  *self-adaptation mode*										

#### Interstitial

- ##### Initialization and interstitial request

  ```objective-c
  #import <YumiMediationSDK/YumiMediationInterstitial.h>

  @interface ViewController ()<YumiMediationInterstitialDelegate>
  @property (nonatomic) YumiMediationInterstitial *yumiInterstitial;
  @end

  @implementation ViewController
  //init yumiInterstitial
  //the interstitial placement will auto cached.
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

- ##### Show Interstitial

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

- ##### Delegate implementation

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

#### Reward Video

- ##### Initialization and reward video request

  ```objective-c
  #import <YumiMediationSDK/YumiMediationVideo.h>
   
  @implementation ViewController
  //the reward video placement will auto cached.
  - (void)viewDidLoad {
  	[super viewDidLoad];
      [[YumiMediationVideo sharedInstance] loadAdWithPlacementID:@"Your PlacementID" 
       									                               channelID:@"Your channelID" 
       									                               versionID:@"Your versionID"];
    	[YumiMediationVideo sharedInstance].delegate = self;
  }
  @end
  ```

- ##### Show rewarded video

  ```objective-c
  - (IBAction)presentYumiMediationVideo:(id)sender {
  	if ([[YumiMediationVideo sharedInstance] isReady]) {
      	 [[YumiMediationVideo sharedInstance] presentFromRootViewController:self];
    } else {
      	NSLog(@"Ad wasn't ready");
    }
  }
  ```

- ##### Delegate implementation

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

- ##### Initialization and splash request

  To ensure splash impression, it is recommended to operate as the followings when App launching.

  for example：in your `AppDelegate.m`  `application:didFinishLaunchingWithOptions:` 

  ```objective-c
  #import <YumiMediationSDK/YumiAdsSplash.h>
  ```

- ##### show splash full screen

  ```objective-c
  //AppKey is a reserved field that can fill in an empty string.
  [[YumiAdsSplash sharedInstance] showYumiAdsSplashWith:@"Your PlacementID"
   											                         appKey:@"nullable" 
   								                   rootViewController:self.window.rootViewController 
   											                       delegate:self]
  ```

- ##### show splash with bottom custom view

  ```objective-c
  //AppKey is a reserved field that can fill in an empty string.
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

- ##### Delegate implementation

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

- ##### Initialization and request

  ```objective-c
  #import <YumiMediationSDK/YumiMediationNativeAd.h>
  #import <YumiMediationSDK/YumiMediationNativeAdConfiguration.h>

  @interface ViewController ()<YumiMediationNativeAdDelegate>
  @property (nonatomic) YumiMediationNativeAd *yumiNativeAd;
  @end
 
  @implementation ViewController
  - (void)viewDidLoad {
    [super viewDidLoad];
    YumiMediationNativeAdConfiguration *config = [[YumiMediationNativeAdConfiguration alloc] init];
    self.yumiNativeAd = [[YumiMediationNativeAd alloc]              
                          initWithPlacementID:@"Your Placement ID"                       
                                    channelID:@"Your Channel ID"                         
                                    versionID:@"Your Version ID"                         
                                configuration:config];
    self.yumiNativeAd.delegate = self;
    //You can request more than one ad.
    [self.nativeAd loadAd:1];
  }
  @end
  ```
- ##### When to request ad
  Apps displaying native ads are free to request them in advance of when they'll actually be displayed. In many cases, this is the recommended practice. An app displaying a list of items with native ads mixed in, for example, can load native ads for the whole list, knowing that some will be shown only after the user scrolls the view and some may not be displayed at all.

  - Warning: while prefetching ads is a great technique, it's important that you don't keep old ads around forever without displaying them. Any native ad objects that have been held without display for longer than an hour should be discarded and replaced with new ads from a new request.
  You can call `-(BOOL)isExpired;` from `YumiMediationNativeModel.h` file to determine whether the current AD is expired.
  - Warning: when reusing `loadAd:`, make sure you wait for each request to complete.

- ##### Register View

  ```objective-c
  /**
   This is a method to associate a YumiNativeAd with the UIView you will use to display the native ads.
   - Parameter view: The UIView you created to render all the native ads data elements.
   - Parameter clickableAssetViews: Dictionary of asset views that are clickable, keyed by asset IDs.
   - Parameter viewController: The UIViewController that will be used to present SKStoreProductViewController(iTunes Store product information) or the in-app browser. If nil is passed, the top view controller currently shown will be used.
   - Parameter nativeAd: The current native ad model.
   */
  - (void)registerViewForInteraction:(UIView *)view
                 clickableAssetViews:
                    (NSDictionary<YumiMediationUnifiedNativeAssetIdentifier, UIView *> *)clickableAssetViews
                  withViewController:(nullable UIViewController *)viewController
                            nativeAd:(YumiMediationNativeModel *)nativeAd;

  /// for example:
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
  - Warning: If you use UIButtons to display native ad assets, you need to disable their user interaction so that the SDK can properly receive and process UI events. Because of this extra step, it's frequently best to avoid UIButtons entirely and use UILabel and UIImageView instead.
  - If you register the view in this way, the SDK automatically handles tasks such as the following:

    - handle click event.
    - display adChoice view (admob,facebook support)
    - display the `Ad` text view
      
- ##### Report Impression

  ```objective-c
  /**
   report impression when display the native ad.
   - Parameter nativeAd: the ad you want to display.
   - Parameter view: view you display the ad.
  */
  - (void)reportImpression:(YumiMediationNativeModel *)nativeAd view:(UIView *)view;
  ```
- ##### Native video ads

  - If you want to display video in native ads, you only need to pass your MediaView into the SDK when you register the view. `YumiMediationUnifiedNativeMediaViewAsset: self. NativeView.MediaView`. The SDK will automatically handle this filling:

    - If a video resource is available, the sdk cached and played in the MediaView that you pass in.
    - If the advertisement does not contain a video source, it downloads the first image source instead and places it in the MediaView that you pass in.
  
  ```objective-c
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
  - You can call `hasVideoContent ` from `YumiMediationNativeModel.h ` to determine there contains video resources in the native model.
    ```objective-c
    /// Indicates whether the ad has video content.
    @property (nonatomic, assign, readonly) BOOL hasVideoContent;
    ``` 
  - You can query the status of video in the following ways, from `YumiMediationNativeVideoController`

    ```objective-c
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

- ##### YumiMediationNativeAdConfiguration
  YumiMediationNativeAdConfiguration is the last parameter when init YumiMediationNativeAd.
  - `disableImageLoading`
    
    Image assets for native ads are returned via instances of `YumiMediationNativeAdImage`, which contains `image`,`ratios` and `imageURL` properties. If disableImageLoading is set to false, which is the default (NO in Objective-C), the SDK will fetch image assets automatically and populate both the image and the imageURL properties for you. If it's set to true (or YES in Objective-C), the SDK will only populate imageURL, allowing you to download the actual images at your discretion. Use the mainImage property of GADMediaContent to set the image for the media view when manually downloading images.
  
  - `preferredAdChoicesPosition`
    
    You can use this property to specify where the AdChoicesView should be placed. Default is `YumiMediationAdChoicesPositionTopRightCorner`
  
  - `preferredAdAttributionPosition`
    
    You can use this property to specify where the Ad text view should be placed. Default is `YumiMediationAdViewPositionTopLeftCorner`
  
  - `preferredAdAttributionText`
    
    You can use this property to specify the Ad text. Default is `Ad`.
  
  - `preferredAdAttributionTextColor`
    
    You can use this property to specify the Ad text color. Default is `gray`.
  
  - `preferredAdAttributionTextFont`
    
    You can use this property to specify the Ad text font size. Default is `10`.
  
  - `hideAdAttribution`
    
    You can use this property to hide the Ad text. Default is display.

- ##### Delegate implementation

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

## Debug Mode

Please select debug mode if you want to test whether ad ruturn is available for an app.

Please ensure your app has initialized YumiMediationSDK before calling debug mode.

### Integration Method

- CocoaPods ( recommend )

  ```ruby
  pod "YumiMediationDebugCenter-iOS" 
  ```


- Manually Integrating YumiMediationSDK

  [SDKDownloadPage-iOS](https://github.com/yumimobi/YumiMediationSDKDemo-iOS/blob/master/normalDocuments/iOSDownloadPage.md)

  Unzip the downloaded file to get our ``YumiMediationDebugCenter-iOS.framework``. Select this framework and add them to your project. Make sure to have 'Copy Items' checked.

### Call debug mode

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

### Sample

<img src="resources/debug-1.png" width="240" height="426">

Select platform integration category

<img src="resources/debug-2.png" width="240" height="426">

Select single platform, the grey indicates  not configurated yet.

<img src="resources/debug-3.png" width="240" height="426">

select ad category, debug single platform

### Test ad placementIDs

| Platform | Banner   | Interstitial | Rewarded Video | Native   | Splash   |
| -------- | -------- | ------------ | -------------- | -------- | -------- |
| iOS      | l6ibkpae | onkkeg5i     | 5xmpgti4       | atb3ke1i | pwmf5r42 |

