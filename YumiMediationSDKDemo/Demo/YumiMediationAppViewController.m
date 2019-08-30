//
//  YumiMediationAppViewController.m
//  YumiMediationSDKDemo
//
//  Created by ShunZhi Tang on 2017/7/13.
//  Copyright © 2017年 Zplay. All rights reserved.
//

#import "YumiMediationAppViewController.h"
#import "CALayer+Transition.h"
#import <YumiMediationSDK/YumiMediationSplash.h>
#import "YumiNativeView.h"
#import "YumiViewController.h"
#import <YumiMediationDebugCenter-iOS/YumiMediationDebugController.h>
#import <YumiMediationDebugCenter-iOS/YumiMediationDemoConstants.h>
#import <YumiMediationSDK/YumiMediationAdapterRegistry.h>
#import <YumiMediationSDK/YumiMediationBannerView.h>
#import <YumiMediationSDK/YumiMediationInterstitial.h>
#import <YumiMediationSDK/YumiMediationNativeAd.h>
#import <YumiMediationSDK/YumiMediationNativeAdConfiguration.h>
#import <YumiMediationSDK/YumiMediationVideo.h>
#import <YumiMediationSDK/YumiTest.h>
#import <YumiMediationSDK/YumiTool.h>
#import "PADemoUtils.h"

static NSString *const appKey = @"";
static int nativeAdNumber = 4;

@interface YumiMediationAppViewController () <YumiMediationBannerViewDelegate, YumiMediationInterstitialDelegate,
                                              YumiMediationVideoDelegate, YumiMediationSplashAdDelegate,
                                              YumiMediationNativeAdDelegate, YumiViewControllerDelegate,
                                              YumiMediationNativeVideoControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *yumiMediationButton;
@property (weak, nonatomic) IBOutlet UIButton *requestAdButton;
@property (weak, nonatomic) IBOutlet UIButton *checkVideoButton;
@property (weak, nonatomic) IBOutlet UIButton *presentOrCloseAdButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectAdType;
@property (weak, nonatomic) IBOutlet UITextView *showLogConsole;
@property (weak, nonatomic) IBOutlet UIButton *clearLogButton;
@property (weak, nonatomic) IBOutlet UIButton *showLogAtBottomButton;
@property (weak, nonatomic) IBOutlet UIButton *showLogTopButton;
@property (weak, nonatomic) IBOutlet UISwitch *switchIsSmartSize;
@property (weak, nonatomic) IBOutlet UILabel *smartLabel;

@property (nonatomic) YumiMediationBannerView *bannerView;
@property (nonatomic) YumiMediationInterstitial *interstitial;
@property (nonatomic) YumiMediationSplash *yumiSplash;
@property (nonatomic) YumiMediationVideo *videoAdInstance;
@property (nonatomic) YumiMediationNativeAd *nativeAd;
@property (nonatomic) YumiNativeView *nativeView;
@property (nonatomic) NSURLSession *session;

@property (nonatomic) NSString *bannerAdLog;
@property (nonatomic) NSString *interstitialAdLog;
@property (nonatomic) NSString *videoAdLog;
@property (nonatomic) NSString *splashAdLog;
@property (nonatomic) NSString *nativeAdLog;
@property (nonatomic, assign) YumiMediationAdLogType adType;
@property (nonatomic, assign) BOOL isSelectTest;
@property (nonatomic, assign) BOOL isOnce;
@property (nonatomic, assign) BOOL isConfigSuccess;
@property (nonatomic, assign) BOOL isObserved;

@property (nonatomic) NSString *bannerPlacementID;
@property (nonatomic) NSString *interstitialPlacementID;
@property (nonatomic) NSString *videoPlacementID;
@property (nonatomic) NSString *nativePlacementID;
@property (nonatomic) NSString *splashPlacementID;
@property (nonatomic) NSString *channelID;
@property (nonatomic) NSString *versionID;

@property (nonatomic) NSMutableArray<YumiMediationNativeModel *> *totalNativeAdArray;
@property (weak, nonatomic) IBOutlet UISwitch *disableAutoRefresh;
@property (weak, nonatomic) IBOutlet UILabel *disableAutoRefreshLabel;

@end

@implementation YumiMediationAppViewController

- (instancetype)init {
    if (self = [super init]) {
        self = [self createVCFromCustomBundle];
    }
    return self;
}

- (instancetype)initWithPlacementID:(NSString *)placementID
                          channelID:(NSString *)channelID
                          versionID:(NSString *)versionID
                             adType:(YumiAdType)adType {
    self = [super init];

    self = [self createVCFromCustomBundle];

    self.channelID = channelID;
    self.versionID = versionID;
    self.adType = (YumiMediationAdLogType)adType;
    [self setupAdPlacementID:placementID adType:adType];
    return self;
}

- (void)setupAdPlacementID:(NSString *)placementID adType:(YumiAdType)adType {
    switch (adType) {
        case YumiAdBanner:
            self.bannerPlacementID = placementID;
            break;
        case YumiAdInterstitial:
            self.interstitialPlacementID = placementID;
            break;
        case YumiAdVideo:
            self.videoPlacementID = placementID;
            break;
        case YumiAdSplash:
            self.splashPlacementID = placementID;
            break;
        case YumiAdNative:
            self.nativePlacementID = placementID;
            break;

        default:
            break;
    }
}

- (NSString *)getAdPlacementIDWith:(YumiMediationAdType)mediationType {
    NSString *placementID = @"";
    switch (mediationType) {
        case YumiMediationAdTypeBanner:
            placementID = self.bannerPlacementID;
            break;
        case YumiMediationAdTypeInterstitial:
            placementID = self.interstitialPlacementID;
            break;
        case YumiMediationAdTypeVideo:
            placementID = self.videoPlacementID;
            break;
        case YumiMediationAdTypeSplash:
            placementID = self.splashPlacementID;
            break;
        case YumiMediationAdTypeNative:
            placementID = self.nativePlacementID;
            break;

        default:
            break;
    }

    return placementID;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // initialize global log
    self.bannerAdLog = @"";
    self.interstitialAdLog = @"";
    self.videoAdLog = @"";
    self.splashAdLog = @"";
    self.nativeAdLog = @"";
    NSArray<UIButton *> *senders =
        @[ self.yumiMediationButton, self.requestAdButton, self.presentOrCloseAdButton, self.checkVideoButton ];
    [self setUIWithButtons:senders];
    self.showLogConsole.editable = NO;
    [self addObserver:self forKeyPath:@"isConfigSuccess" options:NSKeyValueObservingOptionNew context:nil];

    self.selectAdType.selectedSegmentIndex = (NSInteger)self.adType;
    [self clickSegmentControl:self.selectAdType];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isOnce) {
        self.isOnce = YES;
        [self implementTestFeature];
    }

    YumiMediationAdapterRegistry *yumiRegistry = [YumiMediationAdapterRegistry registry];
    yumiRegistry.providerWhiteList = nil;
}

#pragma mark : - private method

- (void)setUIWithButtons:(NSArray<UIButton *> *)senders {
    for (UIButton *customButton in senders) {
        customButton.clipsToBounds = YES;
        customButton.layer.borderWidth = 1.0;
        customButton.layer.borderColor = [UIColor whiteColor].CGColor;
        customButton.layer.cornerRadius = 5.0;
        [customButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    }
}

- (YumiMediationAppViewController *)createVCFromCustomBundle {
    NSBundle *bundle = [NSBundle mainBundle];
    YumiMediationAppViewController *vc =
        [[YumiMediationAppViewController alloc] initWithNibName:@"YumiMediationAppViewController" bundle:bundle];
    if (vc == nil) {
        NSLog(@"Failed to load material");
        return self;
    }
    return vc;
}

- (void)showLogConsoleWith:(NSString *)log adLogType:(YumiMediationAdLogType)adLogType {

    NSDate *date = [NSDate date];
    NSDateFormatter *formateDate = [[NSDateFormatter alloc] init];
    [formateDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dataString = [formateDate stringFromDate:date];

    NSString *formateLog = [NSString stringWithFormat:@"%@ : %@ \n", dataString, log];
    NSString *adLog = @"";
    switch (adLogType) {
        case YumiMediationAdLogTypeBanner:
            self.bannerAdLog = [self.bannerAdLog stringByAppendingString:formateLog];
            adLog = self.bannerAdLog;
            break;
        case YumiMediationAdLogTypeInterstitial:
            self.interstitialAdLog = [self.interstitialAdLog stringByAppendingString:formateLog];
            adLog = self.interstitialAdLog;
            break;
        case YumiMediationAdLogTypeVideo:
            self.videoAdLog = [self.videoAdLog stringByAppendingString:formateLog];
            adLog = self.videoAdLog;
            break;
        case YumiMediationAdLogTypeSplash:
            self.splashAdLog = [self.splashAdLog stringByAppendingString:formateLog];
            adLog = self.splashAdLog;
            break;
        case YumiMediationAdLogTypeNative:
            self.nativeAdLog = [self.nativeAdLog stringByAppendingString:formateLog];
            adLog = self.nativeAdLog;
            break;

        default:
            break;
    }

    if (self.adType != adLogType) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.showLogConsole.text = adLog;
    });
}

- (void)implementTestFeature {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select the test environment?"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"NO"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *_Nonnull action){
                                                [[PADemoUtils shared] removeTagFile];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"YES"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [YumiTest enableTestMode];
                                                [[PADemoUtils shared] createTagFile];
                                            }]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)clearLogConsole {
    switch (self.adType) {
        case YumiMediationAdLogTypeBanner:
            self.bannerAdLog = @"";
            break;
        case YumiMediationAdLogTypeInterstitial:
            self.interstitialAdLog = @"";
            break;
        case YumiMediationAdLogTypeVideo:
            self.videoAdLog = @"";
            break;
        case YumiMediationAdLogTypeSplash:
            self.splashAdLog = @"";
            break;
        case YumiMediationAdLogTypeNative:
            self.nativeAdLog = @"";
            break;

        default:
            break;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        self.showLogConsole.text = @"";
    });
}

- (void)removeBannerAd:(BOOL)isLog {
    if (isLog && _bannerView) {
        [self showLogConsoleWith:@"remove  banner ad" adLogType:YumiMediationAdLogTypeBanner];
    }

    if (_bannerView) {
        [self.bannerView disableAutoRefresh];
        [self.bannerView removeFromSuperview];
        self.bannerView = nil;
    }
}

- (void)removeNativeAd:(BOOL)isLog {
    if (isLog && _nativeAd) {
        [self showLogConsoleWith:@"remove native ad " adLogType:YumiMediationAdLogTypeNative];
    }

    if (self.nativeAd) {
        self.nativeAd = nil;
    }
}

- (IBAction)clickMetation:(UIButton *)sender {
    [self removeBannerAd:YES];
    [self removeNativeAd:YES];
    if (self.interstitial) {
        self.interstitial = nil;
    }

    if (self.videoAdInstance) {
        self.videoAdInstance = nil;
    }

    if (self.yumiSplash) {
        self.yumiSplash = nil;
    }
    // @"1l4aphvz"
    [[YumiMediationDebugController sharedInstance] presentWithBannerPlacementID:self.bannerPlacementID
                                                        interstitialPlacementID:self.interstitialPlacementID
                                                               videoPlacementID:self.videoPlacementID
                                                              nativePlacementID:self.nativePlacementID
                                                              splashPlacementID:self.splashPlacementID
                                                                      channelID:self.channelID
                                                                      versionID:self.versionID
                                                             rootViewController:self];
    [[YumiMediationDebugController sharedInstance] setupBannerSize:self.bannerSize];
}
- (IBAction)clickRequestAd:(UIButton *)sender {

    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{

        switch (weakSelf.selectAdType.selectedSegmentIndex) {
            case 0: {
                weakSelf.bannerView.bannerSize = self.bannerSize;
                if (weakSelf.disableAutoRefresh.on) {
                    [weakSelf.bannerView disableAutoRefresh];
                }
                [weakSelf.bannerView loadAd:weakSelf.switchIsSmartSize.on];
                _bannerView.delegate = weakSelf;
                [weakSelf showLogConsoleWith:[NSString stringWithFormat:@"initialize   banner ad placementID : %@",
                                                                        weakSelf.bannerPlacementID]
                                   adLogType:YumiMediationAdLogTypeBanner];
                [weakSelf showLogConsoleWith:@"start request banner ad" adLogType:YumiMediationAdLogTypeBanner];
                [weakSelf.view addSubview:weakSelf.bannerView];
                weakSelf.bannerView.hidden = NO;
                [weakSelf.view bringSubviewToFront:weakSelf.bannerView];
            } break;
            case 1:
                [weakSelf showLogConsoleWith:[NSString stringWithFormat:@"initialize  interstitial ad placementID : %@",
                                                                        weakSelf.interstitialPlacementID]
                                   adLogType:YumiMediationAdLogTypeInterstitial];
                weakSelf.interstitial =
                    [[YumiMediationInterstitial alloc] initWithPlacementID:weakSelf.interstitialPlacementID
                                                                 channelID:weakSelf.channelID
                                                                 versionID:weakSelf.versionID];
                weakSelf.interstitial.delegate = weakSelf;
                break;

            case 2: {
                [weakSelf showLogConsoleWith:[NSString stringWithFormat:@"initialize  video ad placementID : %@",
                                                                        weakSelf.videoPlacementID]
                                   adLogType:YumiMediationAdLogTypeVideo];
                weakSelf.videoAdInstance = [YumiMediationVideo sharedInstance];
                // 修改coreLogicInstance 中 state的值
                [[weakSelf.videoAdInstance valueForKey:@"coreLogicInstance"] setValue:@(0) forKey:@"state"];
                [weakSelf.videoAdInstance loadAdWithPlacementID:weakSelf.videoPlacementID
                                                      channelID:weakSelf.channelID
                                                      versionID:weakSelf.versionID];
                weakSelf.videoAdInstance.delegate = weakSelf;
            } break;

            case 3: {
                [weakSelf showLogConsoleWith:[NSString stringWithFormat:@"initialize  splash ad placementID : %@",
                                                                        weakSelf.splashPlacementID]
                                   adLogType:YumiMediationAdLogTypeSplash];
                weakSelf.yumiSplash = [[YumiMediationSplash alloc] initWithPlacementID:weakSelf.splashPlacementID
                                                                             channelID:weakSelf.channelID
                                                                             versionID:weakSelf.versionID];
                weakSelf.yumiSplash.delegate = self;
                [weakSelf.yumiSplash setFetchTime:5];
                [weakSelf.yumiSplash setInterfaceOrientation:UIInterfaceOrientationPortrait];
                [weakSelf.yumiSplash setLaunchImage:[UIImage imageNamed:@"native_back"]];
                [weakSelf.yumiSplash loadAdAndShowInWindow:[UIApplication sharedApplication].keyWindow];
            } break;
            case 4:
                [weakSelf.totalNativeAdArray removeAllObjects];
                [weakSelf showLogConsoleWith:[NSString stringWithFormat:@"initialize  native ad placementID : %@",
                                                                        weakSelf.nativePlacementID]
                                   adLogType:YumiMediationAdLogTypeNative];
                [weakSelf.nativeAd loadAd:nativeAdNumber];
                break;

            default:
                break;
        }
    });
}
- (IBAction)clickPresentOrCloseAdButton:(UIButton *)sender {
    switch (self.selectAdType.selectedSegmentIndex) {
        case 0:
            [self removeBannerAd:YES];
            break;
        case 1:
            if ([self.interstitial isReady]) {
                [self.interstitial presentFromRootViewController:self];
            }
            break;
        case 2:
            if ([self.videoAdInstance isReady]) {
                [self.videoAdInstance presentFromRootViewController:self];
            }
            
            break;
        case 4: {
            if (self.totalNativeAdArray.count > 0) {
                YumiMediationNativeModel *model = self.totalNativeAdArray[0];
                
                [self registerNativeView:model];
                // native view
                if (!model.isExpressAdView) {
                    [self showNativeView:model];
                }
                
                // remove first object
                [self.totalNativeAdArray removeObjectAtIndex:0];
                
            } else {
                [self showLogConsoleWith:@"No ad show" adLogType:YumiMediationAdLogTypeNative];
            }
        } break;
            
        default:
            break;
    }
}
- (IBAction)clickSegmentControl:(UISegmentedControl *)sender {
    
    // reset button style
    __weak typeof(self) weakSelf = self;
    switch (sender.selectedSegmentIndex) {
        case 0: {
            [self.requestAdButton setTitle:@"Show banner" forState:UIControlStateNormal];
            [self.presentOrCloseAdButton setTitle:@"Remove banner" forState:UIControlStateNormal];
            self.checkVideoButton.hidden = YES;
            self.presentOrCloseAdButton.hidden = NO;
            self.smartLabel.hidden = NO;
            self.switchIsSmartSize.hidden = NO;
            self.disableAutoRefresh.hidden = NO;
            self.disableAutoRefreshLabel.hidden = NO;
            self.adType = YumiMediationAdLogTypeBanner;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.showLogConsole.text = self.bannerAdLog;
                [weakSelf removeNativeAd:YES];
                weakSelf.interstitial = nil;
                weakSelf.videoAdInstance = nil;
                weakSelf.yumiSplash = nil;
            });
        } break;
        case 1: {
            [self.requestAdButton setTitle:@"Request interstitial" forState:UIControlStateNormal];
            [self.presentOrCloseAdButton setTitle:@"Show interstitial" forState:UIControlStateNormal];
            self.checkVideoButton.hidden = YES;
            self.disableAutoRefresh.hidden = YES;
            self.disableAutoRefreshLabel.hidden = YES;
            self.presentOrCloseAdButton.hidden = NO;
            self.smartLabel.hidden = YES;
            self.switchIsSmartSize.hidden = YES;
            self.adType = YumiMediationAdLogTypeInterstitial;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.showLogConsole.text = self.interstitialAdLog;
                [weakSelf removeNativeAd:YES];
                [weakSelf removeBannerAd:YES];
                weakSelf.videoAdInstance = nil;
                weakSelf.yumiSplash = nil;
            });
        } break;
        case 2: {
            [self.requestAdButton setTitle:@"Request video" forState:UIControlStateNormal];
            [self.checkVideoButton setTitle:@"Check  video" forState:UIControlStateNormal];
            [self.presentOrCloseAdButton setTitle:@"Play video" forState:UIControlStateNormal];
            self.checkVideoButton.hidden = NO;
            self.presentOrCloseAdButton.hidden = NO;
            self.smartLabel.hidden = YES;
            self.disableAutoRefresh.hidden = YES;
            self.disableAutoRefreshLabel.hidden = YES;
            self.switchIsSmartSize.hidden = YES;
            self.adType = YumiMediationAdLogTypeVideo;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.showLogConsole.text = self.videoAdLog;
                [weakSelf removeNativeAd:YES];
                [weakSelf removeBannerAd:YES];
                weakSelf.interstitial = nil;
                weakSelf.yumiSplash = nil;
            });
        } break;

        case 3: {
            [self.requestAdButton setTitle:@"Request splash" forState:UIControlStateNormal];
            self.checkVideoButton.hidden = YES;
            self.presentOrCloseAdButton.hidden = YES;
            self.disableAutoRefresh.hidden = YES;
            self.disableAutoRefreshLabel.hidden = YES;
            self.smartLabel.hidden = YES;
            self.switchIsSmartSize.hidden = YES;
            self.adType = YumiMediationAdLogTypeSplash;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.showLogConsole.text = self.splashAdLog;
                [weakSelf removeNativeAd:YES];
                [weakSelf removeBannerAd:YES];
                weakSelf.videoAdInstance = nil;
                weakSelf.interstitial = nil;
            });
        } break;
        case 4: {
            [self.requestAdButton setTitle:@"Request native" forState:UIControlStateNormal];
            [self.checkVideoButton setTitle:@"Remove  native" forState:UIControlStateNormal];
            [self.presentOrCloseAdButton setTitle:@"Show new native" forState:UIControlStateNormal];
            self.checkVideoButton.hidden = YES;
            self.disableAutoRefresh.hidden = YES;
            self.disableAutoRefreshLabel.hidden = YES;
            self.presentOrCloseAdButton.hidden = NO;
            self.smartLabel.hidden = YES;
            self.switchIsSmartSize.hidden = YES;
            self.adType = YumiMediationAdLogTypeNative;

            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.showLogConsole.text = self.nativeAdLog;
                [weakSelf removeBannerAd:YES];
                weakSelf.videoAdInstance = nil;
                weakSelf.interstitial = nil;
                weakSelf.yumiSplash = nil;
            });
        } break;

        default:
            break;
    }
}

- (IBAction)showLogOnTextViewTop:(UIButton *)sender {
    [self.showLogConsole scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (IBAction)showLogOnTextViewBottom:(UIButton *)sender {
    CGRect rect = CGRectMake(0, self.showLogConsole.contentSize.height - 1, self.showLogConsole.frame.size.width,
                             self.showLogConsole.contentSize.height);
    [self.showLogConsole scrollRectToVisible:rect animated:NO];
}

- (IBAction)clearLogOnTextView:(UIButton *)sender {
    [self clearLogConsole];
}
- (IBAction)checkVideoIsReady:(UIButton *)sender {
    switch (self.selectAdType.selectedSegmentIndex) {
        case 2: {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Check if the video is ready?"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            if ([self.videoAdInstance isReady]) {
                [alert addAction:[UIAlertAction actionWithTitle:@"Play video"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *_Nonnull action) {
                                                            [self.videoAdInstance presentFromRootViewController:self];
                                                        }]];
                [self showLogConsoleWith:@"video is ready to play" adLogType:YumiMediationAdLogTypeVideo];
            } else {
                [alert addAction:[UIAlertAction actionWithTitle:@"NO video"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *_Nonnull action){

                                                        }]];
                [self showLogConsoleWith:@"video isn't ready" adLogType:YumiMediationAdLogTypeVideo];
            }

            [self presentViewController:alert animated:YES completion:nil];
        } break;

        case 4: {
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf removeNativeAd:YES];
            });
        } break;

        default:
            break;
    }
}

- (IBAction)clickModifyID:(UIButton *)sender {
    NSBundle *bundle = [NSBundle mainBundle];
    UIStoryboard *UpgradeHardware = [UIStoryboard storyboardWithName:@"Main" bundle:bundle];
    YumiViewController *rootVc = [UpgradeHardware instantiateViewControllerWithIdentifier:@"YumiViewController"];
    rootVc.presented = YES;
    rootVc.delegate = self;
    rootVc.adType = (YumiAdType)self.adType;
    rootVc.bannerSize = self.bannerSize;
    [self presentViewController:rootVc animated:YES completion:nil];

    [[UIApplication sharedApplication].keyWindow.layer transitionWithAnimType:TransitionAnimTypeRamdom
                                                                      subType:TransitionSubtypesFromRamdom
                                                                        curve:TransitionCurveRamdom
                                                                     duration:2.0];
}

#pragma mark : getter
- (YumiMediationBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[YumiMediationBannerView alloc] initWithPlacementID:self.bannerPlacementID
                                                                 channelID:self.channelID
                                                                 versionID:self.versionID
                                                                  position:YumiMediationBannerPositionBottom
                                                        rootViewController:self];
    }
    return _bannerView;
}

- (YumiMediationNativeAd *)nativeAd {
    if (!_nativeAd) {
        YumiMediationNativeAdConfiguration *config = [[YumiMediationNativeAdConfiguration alloc] init];
        
        config.expressAdSize = CGSizeMake(300, 300);
        //        config.disableImageLoading = NO;
        //        config.preferredAdChoicesPosition = YumiMediationAdViewPositionTopRightCorner;
        //        config.preferredAdAttributionPosition = YumiMediationAdViewPositionTopLeftCorner;
        //        config.preferredAdAttributionText = @"广告";
        //        config.preferredAdAttributionTextColor = [UIColor redColor];
        //        config.preferredAdAttributionTextFont = [UIFont systemFontOfSize:20];
        
        _nativeAd = [[YumiMediationNativeAd alloc] initWithPlacementID:self.nativePlacementID
                                                             channelID:self.channelID
                                                             versionID:self.versionID
                                                         configuration:config];
        _nativeAd.delegate = self;
    }
    return _nativeAd;
}

#pragma mark : - YumiMediationBannerViewDelegate
- (void)yumiMediationBannerViewDidLoad:(YumiMediationBannerView *)adView {
    self.isConfigSuccess = YES;
    [self showLogConsoleWith:@"banner view did load" adLogType:YumiMediationAdLogTypeBanner];
}

- (void)yumiMediationBannerView:(YumiMediationBannerView *)adView didFailWithError:(YumiMediationError *)error {
    [self showLogConsoleWith:[NSString stringWithFormat:@"banner view did fail with error: [ %@ ]",
                                                        [error localizedDescription]]
                   adLogType:YumiMediationAdLogTypeBanner];
}

- (void)yumiMediationBannerViewDidClick:(YumiMediationBannerView *)adView {
    [self showLogConsoleWith:@"banner view did click" adLogType:YumiMediationAdLogTypeBanner];
}

#pragma mark : - YumiMediationInterstitialDelegate
- (void)yumiMediationInterstitialDidReceiveAd:(YumiMediationInterstitial *)interstitial {
    self.isConfigSuccess = YES;
    [self showLogConsoleWith:@"interstitial did received ad" adLogType:YumiMediationAdLogTypeInterstitial];
}
- (void)yumiMediationInterstitial:(YumiMediationInterstitial *)interstitial
           didFailToLoadWithError:(YumiMediationError *)error {
    [self showLogConsoleWith:[NSString stringWithFormat:@"interstitial did fail to load with error : [ %@ ] ",
                                                        [error localizedDescription]]
                   adLogType:YumiMediationAdLogTypeInterstitial];
}
- (void)yumiMediationInterstitialDidClosed:(YumiMediationInterstitial *)interstitial {
    [self showLogConsoleWith:@"interstitial did closed" adLogType:YumiMediationAdLogTypeInterstitial];
}
- (void)yumiMediationInterstitialDidClick:(YumiMediationInterstitial *)interstitial {
    [self showLogConsoleWith:@"interstitial did click " adLogType:YumiMediationAdLogTypeInterstitial];
}
- (void)yumiMediationInterstitialDidOpen:(YumiMediationInterstitial *)interstitial {
    [self showLogConsoleWith:@"interstitial did open" adLogType:YumiMediationAdLogTypeInterstitial];
}
- (void)yumiMediationInterstitialDidStartPlaying:(YumiMediationInterstitial *)interstitial {
    [self showLogConsoleWith:@"interstitial did start playing" adLogType:YumiMediationAdLogTypeInterstitial];
}
- (void)yumiMediationInterstitial:(YumiMediationInterstitial *)interstitial
           didFailToShowWithError:(YumiMediationError *)error {
    [self showLogConsoleWith:[NSString stringWithFormat:@"interstitial did fail to show with error : [ %@ ] ",
                                                        [error localizedDescription]]
                   adLogType:YumiMediationAdLogTypeInterstitial];
}

#pragma mark - YumiMediationVideoDelegate
- (void)yumiMediationVideoDidReceiveAd:(YumiMediationVideo *)video {
    [self showLogConsoleWith:@"video did received... " adLogType:YumiMediationAdLogTypeVideo];
}
- (void)yumiMediationVideoDidReward:(YumiMediationVideo *)video {
    [self showLogConsoleWith:@"video did rewarded " adLogType:YumiMediationAdLogTypeVideo];
}

- (void)yumiMediationVideoDidClosed:(YumiMediationVideo *)video isRewarded:(BOOL)isRewarded {
    [self showLogConsoleWith:[NSString stringWithFormat:@"video did closed. isRewarded:%d", isRewarded]
                   adLogType:YumiMediationAdLogTypeVideo];
}
- (void)yumiMediationVideoDidOpen:(YumiMediationVideo *)video {
    self.isConfigSuccess = YES;
    [self showLogConsoleWith:@"video did open " adLogType:YumiMediationAdLogTypeVideo];
}
- (void)yumiMediationVideoDidStartPlaying:(YumiMediationVideo *)video {
    [self showLogConsoleWith:@"video start playing " adLogType:YumiMediationAdLogTypeVideo];
}
- (void)yumiMediationVideoDidClick:(YumiMediationVideo *)video {
    [self showLogConsoleWith:@"video did click " adLogType:YumiMediationAdLogTypeVideo];
}
- (void)yumiMediationVideo:(YumiMediationVideo *)video didFailToLoadWithError:(NSError *)error {
    [self showLogConsoleWith:[NSString stringWithFormat:@"video did fail to load with error [ %@ ] ",
                                                        [error localizedDescription]]
                   adLogType:YumiMediationAdLogTypeVideo];
}
- (void)yumiMediationVideo:(YumiMediationVideo *)video didFailToShowWithError:(NSError *)error {
    [self showLogConsoleWith:@"video did fail to show" adLogType:YumiMediationAdLogTypeVideo];
}

#pragma mark : - YumiMediationSplashAdDelegate

- (void)yumiMediationSplashAdSuccessToShow:(YumiMediationSplash *)splash {
    [self showLogConsoleWith:@"splash success to show  " adLogType:YumiMediationAdLogTypeSplash];
}

- (void)yumiMediationSplashAdFailToShow:(YumiMediationSplash *)splash withError:(NSError *)error {
    [self showLogConsoleWith:[NSString
                                 stringWithFormat:@"splash did fail with error [ %@ ] ", [error localizedDescription]]
                   adLogType:YumiMediationAdLogTypeSplash];
}

- (void)yumiMediationSplashAdDidClick:(YumiMediationSplash *)splash {
    [self showLogConsoleWith:@"splash did click " adLogType:YumiMediationAdLogTypeSplash];
}

- (void)yumiMediationSplashAdDidClose:(YumiMediationSplash *)splash {
    [self showLogConsoleWith:@"splash did close " adLogType:YumiMediationAdLogTypeSplash];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context {
    if (self.isObserved) {
        return;
    }

    if ([keyPath isEqualToString:@"isConfigSuccess"]) {
        if ([change[@"new"] intValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.isObserved = YES;
                self.yumiMediationButton.enabled = YES;
                [self.yumiMediationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            });
        }
    }
}

#pragma mark - YumiMediationNativeAdDelegate
/// Tells the delegate that an ad has been successfully loaded.
- (void)yumiMediationNativeAdDidLoad:(NSArray<YumiMediationNativeModel *> *)nativeAdArray {

    self.totalNativeAdArray = [NSMutableArray arrayWithArray:nativeAdArray];

    __weak typeof(self) weakSelf = self;

    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *nativeStr =
            [NSString stringWithFormat:@"native did load ad count is %lu", (unsigned long)nativeAdArray.count];
        [weakSelf showLogConsoleWith:nativeStr adLogType:YumiMediationAdLogTypeNative];
    });
}

/// Tells the delegate that a request failed.
- (void)yumiMediationNativeAd:(YumiMediationNativeAd *)nativeAd didFailWithError:(YumiMediationError *)error {
    [self showLogConsoleWith:[NSString
                                 stringWithFormat:@"native did fail with error [ %@ ] ", [error localizedDescription]]
                   adLogType:YumiMediationAdLogTypeNative];
    [self.totalNativeAdArray removeAllObjects];
}

/// Tells the delegate that the Native view has been clicked.
- (void)yumiMediationNativeAdDidClick:(YumiMediationNativeModel *)nativeAd {
    [self showLogConsoleWith:@"native did clicked " adLogType:YumiMediationAdLogTypeNative];
}

- (void)yumiMediationNativeExpressAdRenderSuccess:(YumiMediationNativeModel *)nativeModel {
    [self showLogConsoleWith:@"native express render success " adLogType:YumiMediationAdLogTypeNative];
    
    [self showNativeExpressAdView:nativeModel];
    
}

- (void)yumiMediationNativeExpressAd:(YumiMediationNativeModel *)nativeModel didRenderFail:(NSString *)errorMsg {
    [self showLogConsoleWith:[NSString stringWithFormat:@"native express render fail. error is == %@",errorMsg] adLogType:YumiMediationAdLogTypeNative];
}

- (void)yumiMediationNativeExpressAdDidClickCloseButton:(YumiMediationNativeModel *)nativeModel {
    [self showLogConsoleWith:@"native express did click close button " adLogType:YumiMediationAdLogTypeNative];
    
    [self closeNativeView];
}

#pragma mark : YumiMediationNativeVideoControllerDelegate
/// Tells the delegate that the video controller has began or resumed playing a video.
- (void)yumiMediationNativeVideoControllerDidPlayVideo:(YumiMediationNativeVideoController *)videoController {
    [self showLogConsoleWith:@"yumiMediationNativeVideoControllerDidPlayVideo" adLogType:YumiMediationAdLogTypeNative];
}

/// Tells the delegate that the video controller has paused video.
- (void)yumiMediationNativeVideoControllerDidPauseVideo:(YumiMediationNativeVideoController *)videoController {
    [self showLogConsoleWith:@"yumiMediationNativeVideoControllerDidPauseVideo" adLogType:YumiMediationAdLogTypeNative];
}

/// Tells the delegate that the video controller's video playback has ended.
- (void)yumiMediationNativeVideoControllerDidEndVideoPlayback:(YumiMediationNativeVideoController *)videoController {
    [self showLogConsoleWith:@"yumiMediationNativeVideoControllerDidEndVideoPlayback"
                   adLogType:YumiMediationAdLogTypeNative];
}
- (void)closeNativeView {
    [self.nativeView removeFromSuperview];
    self.nativeView = nil;
}

- (void)registerNativeView:(YumiMediationNativeModel *)adData {
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf showLogConsoleWith:@"register new native Ad" adLogType:YumiMediationAdLogTypeNative];
        
        weakSelf.nativeView = [[NSBundle mainBundle] loadNibNamed:@"YumiNativeView" owner:nil options:nil].firstObject;
        weakSelf.nativeView.frame = weakSelf.view.frame;
        [weakSelf.nativeView.closeButton addTarget:weakSelf
                                            action:@selector(closeNativeView)
                                  forControlEvents:UIControlEventTouchDown];
        
        if ([adData isExpired]) {
            [weakSelf showLogConsoleWith:@"native Ad had expired " adLogType:YumiMediationAdLogTypeNative];
            return;
        }
        
        adData.videoController.delegate = self;
        [weakSelf.nativeAd registerViewForInteraction:weakSelf.nativeView.adView
                                  clickableAssetViews:@{
                                                        YumiMediationUnifiedNativeTitleAsset : weakSelf.nativeView.title,
                                                        YumiMediationUnifiedNativeDescAsset : weakSelf.nativeView.desc,
                                                        YumiMediationUnifiedNativeCoverImageAsset : weakSelf.nativeView.coverImage,
                                                        YumiMediationUnifiedNativeMediaViewAsset : weakSelf.nativeView.coverImage,
                                                        YumiMediationUnifiedNativeIconAsset : weakSelf.nativeView.icon,
                                                        YumiMediationUnifiedNativeCallToActionAsset : weakSelf.nativeView.callToAction
                                                        }
                                   withViewController:weakSelf
                                             nativeAd:adData];
    });
}

- (void)showNativeView:(YumiMediationNativeModel *)adData {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf showLogConsoleWith:@"show new native Ad" adLogType:YumiMediationAdLogTypeNative];
        [weakSelf.view addSubview:weakSelf.nativeView];
        
        weakSelf.nativeView.title.text = adData.title;
        weakSelf.nativeView.desc.text = adData.desc;
        weakSelf.nativeView.callToAction.text = adData.callToAction;
        weakSelf.nativeView.coverImage.image = adData.coverImage.image;
        weakSelf.nativeView.icon.image = adData.icon.image;
        
        [weakSelf.nativeAd reportImpression:adData view:weakSelf.nativeView.adView];
    });
}

- (void)showNativeExpressAdView:(YumiMediationNativeModel *)adData{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf showLogConsoleWith:@"show native  express Ad" adLogType:YumiMediationAdLogTypeNative];
        [weakSelf.view addSubview:weakSelf.nativeView];
        [weakSelf.nativeView.adView addSubview:adData.expressAdView];
        
        CGSize adSize = adData.expressAdView.bounds.size;
        adData.expressAdView.frame = CGRectMake((weakSelf.nativeView.adView.bounds.size.width - adSize.width) * 0.5, (weakSelf.nativeView.adView.bounds.size.height - adSize.height) *0.5, adSize.width, adSize.height);
        
        [weakSelf.nativeAd reportImpression:adData view:weakSelf.nativeView.adView];
        
    });
    
}

#pragma mark : - YumiViewControllerDelegate
- (void)modifyPlacementID:(NSString *)placementID
                channelID:(NSString *)channelID
                versionID:(NSString *)versionID
                   adType:(YumiAdType)adType
               bannerSize:(YumiMediationAdViewBannerSize)bannerSize {
    
    [self removeBannerAd:YES];
    [self removeNativeAd:YES];
    if (self.interstitial) {
        self.interstitial = nil;
    }
    
    if (self.videoAdInstance) {
        self.videoAdInstance = nil;
    }
    
    if (self.yumiSplash) {
        self.yumiSplash = nil;
    }
    self.bannerSize = bannerSize;
    [self setupAdPlacementID:placementID adType:adType];
    self.channelID = channelID;
    self.versionID = versionID;
    self.adType = (YumiMediationAdLogType)adType;
    self.selectAdType.selectedSegmentIndex = (NSUInteger)self.adType;
    [self clickSegmentControl:self.selectAdType];
}
@end
