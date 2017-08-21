//
//  YumiMediationAppViewController.m
//  YumiMediationSDKDemo
//
//  Created by ShunZhi Tang on 2017/7/13.
//  Copyright © 2017年 Zplay. All rights reserved.
//

#import "YumiMediationAppViewController.h"
#import "CALayer+Transition.h"
#import "YumiViewController.h"
#import <YumiMediationDebugCenter-iOS/YumiLocalStatisticsAdsListTableViewController.h>
#import <YumiMediationDebugCenter-iOS/YumiMediationDebugController.h>
#import <YumiMediationDebugCenter-iOS/YumiMediationDemoConstants.h>
#import <YumiMediationDebugCenter-iOS/YumiMediationFetchAdConfig.h>
#import <YumiMediationSDK/YUMIStream.h>
#import <YumiMediationSDK/YUMIStreamCustomView.h>
#import <YumiMediationSDK/YUMIStreamLogCenter.h>
#import <YumiMediationSDK/YUMIStreamModel.h>
#import <YumiMediationSDK/YumiAdsSplash.h>
#import <YumiMediationSDK/YumiMediationAdapterRegistry.h>
#import <YumiMediationSDK/YumiMediationBannerView.h>
#import <YumiMediationSDK/YumiMediationInterstitial.h>
#import <YumiMediationSDK/YumiMediationPartnerID.h>
#import <YumiMediationSDK/YumiMediationVideo.h>
#import <YumiMediationSDK/YumiTest.h>
#import <YumiMediationSDK/YumiTool.h>

@interface YumiMediationAppViewController () <YumiMediationBannerViewDelegate, YumiMediationInterstitialDelegate,
                                              YumiMediationVideoDelegate, YumiAdsSplashDelegate, YUMIStreamDelegate,
                                              YMAdCustomViewDelegate, YumiViewControllerDelegate>

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
@property (nonatomic) YumiAdsSplash *yumiSplash;
@property (nonatomic) YumiMediationVideo *videoAdInstance;

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
@property (nonatomic, assign) BOOL isVideoReceive;

@property (nonatomic) NSString *yumiID;
@property (nonatomic) NSString *channelID;
@property (nonatomic) NSString *versionID;

// stream
@property (nonatomic) YUMIStream *nativeStream;
@property (nonatomic) YUMIStreamCustomView *nativeCustomView;
@property (nonatomic, assign) NSUInteger streamNumber;
@property (nonatomic) UIView *bgView;

@end

@implementation YumiMediationAppViewController

- (instancetype)init {
    if (self = [super init]) {
        self = [self createVCFromCustomBundle];
    }
    return self;
}

- (instancetype)initWithYumiID:(NSString *)yumiID channelID:(NSString *)channelID versionID:(NSString *)versionID {
    self = [super init];

    self = [self createVCFromCustomBundle];
    self.yumiID = yumiID;
    self.channelID = channelID;
    self.versionID = versionID;

    [self saveYumiID:yumiID channelID:channelID versionID:versionID];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self requestAdConfig];
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

- (void)saveYumiID:(NSString *)yumiID channelID:(NSString *)channelID versionID:(NSString *)versionID {

    NSUserDefaults *stdUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [NSString stringWithFormat:@"%@,%@,%@", yumiID, channelID, versionID];

    [stdUserDefaults setObject:value forKey:yumiIDKey];
    [stdUserDefaults synchronize];
}

- (void)requestAdConfig {
    __weak typeof(self) weakSelf = self;
    void (^retry)(void) = ^{

        dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC));
        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_after(t, q, ^{
            [weakSelf requestAdConfig];

        });
    };

    [self fetchAdConfigWith:YumiMediationAdTypeBanner];
    [self fetchAdConfigWith:YumiMediationAdTypeInterstitial];
    [self fetchAdConfigWith:YumiMediationAdTypeVideo];

    if (!self.isConfigSuccess) {
        retry();
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        self.yumiMediationButton.enabled = YES;
        [self.yumiMediationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    });
}

- (NSArray<YumiMediationProvider *> *)fetchAdConfigWith:(YumiMediationAdType)adType {

    YumiMediationFetchAdConfig *adConfig = [YumiMediationFetchAdConfig sharedFetchAdConfig];
    NSArray<YumiMediationProvider *> *providers =
        [adConfig fetchAdConfigWith:adType yumiID:self.yumiID channelID:self.channelID versionID:self.versionID];
    if (providers.count > 0) {
        self.isConfigSuccess = YES;
    }
    return providers;
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

                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"YES"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [YumiTest enableTestMode];

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
        [self.bannerView removeFromSuperview];
        self.bannerView = nil;
    }
}

- (void)removeNativeAd:(BOOL)isLog {
    if (isLog && _nativeCustomView) {
        [self showLogConsoleWith:@"remove native ad " adLogType:YumiMediationAdLogTypeNative];
    }

    if (self.nativeCustomView) {
        [self.nativeCustomView removeFromSuperview];
        self.nativeCustomView = nil;
    }
    if (self.bgView) {
        [self.bgView removeFromSuperview];
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

    [[YumiMediationDebugController sharedInstance] presentWithYumiID:self.yumiID
                                                           channelID:self.channelID
                                                           versionID:self.versionID
                                                  rootViewController:self];
}
- (IBAction)clickRequestAd:(UIButton *)sender {

    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{

        switch (weakSelf.selectAdType.selectedSegmentIndex) {
            case 0:

                [weakSelf.bannerView loadAd:weakSelf.switchIsSmartSize.on];
                _bannerView.delegate = weakSelf;
                [weakSelf showLogConsoleWith:[NSString stringWithFormat:@"initialize   banner ad yumiID : %@",
                                                                        weakSelf.yumiID]
                                   adLogType:YumiMediationAdLogTypeBanner];
                [weakSelf showLogConsoleWith:@"start request banner ad" adLogType:YumiMediationAdLogTypeBanner];
                [weakSelf.view addSubview:weakSelf.bannerView];
                weakSelf.bannerView.hidden = NO;
                [weakSelf.view bringSubviewToFront:weakSelf.bannerView];

                break;
            case 1:
                [weakSelf showLogConsoleWith:[NSString stringWithFormat:@"initialize  interstitial ad yumiID : %@",
                                                                        weakSelf.yumiID]
                                   adLogType:YumiMediationAdLogTypeInterstitial];
                weakSelf.interstitial = [[YumiMediationInterstitial alloc] initWithYumiID:weakSelf.yumiID
                                                                                channelID:weakSelf.channelID
                                                                                versionID:weakSelf.versionID
                                                                       rootViewController:weakSelf];
                weakSelf.interstitial.delegate = weakSelf;
                break;

            case 2: {
                [weakSelf
                    showLogConsoleWith:[NSString stringWithFormat:@"initialize  video ad yumiID : %@", weakSelf.yumiID]
                             adLogType:YumiMediationAdLogTypeVideo];
                weakSelf.videoAdInstance = [YumiMediationVideo sharedInstance];
                [weakSelf.videoAdInstance loadAdWithYumiID:weakSelf.yumiID
                                                 channelID:weakSelf.channelID
                                                 versionID:weakSelf.versionID];
                weakSelf.videoAdInstance.delegate = weakSelf;
                weakSelf.isVideoReceive = NO;
            } break;

            case 3:
            {
                weakSelf.yumiSplash = [YumiAdsSplash sharedInstance];
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-100,[UIScreen mainScreen].bounds.size.width, 100)];
                view.backgroundColor = [UIColor redColor];
                [weakSelf.yumiSplash showYumiAdsSplashWith:weakSelf.yumiID
                                          customBottomView:view
                                        rootViewController:weakSelf
                                                  delegate:weakSelf];
            }
                break;
            case 4:
                [weakSelf
                    showLogConsoleWith:[NSString stringWithFormat:@"initialize  native ad yumiID : %@", weakSelf.yumiID]
                             adLogType:YumiMediationAdLogTypeNative];
                [weakSelf.nativeStream loadStream];
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
                [self.interstitial present];
            }
            break;
        case 2:
            if (self.isVideoReceive) {
                [self.videoAdInstance presentFromRootViewController:self];
            }
            
            break;
        case 4: {
            if (![self.nativeStream isExistStream]) {
                return;
            }
            YUMIStreamModel *streamModel = [self.nativeStream getStreamModel];
            switch (streamModel.showType) {
                case showOfData: {
                    self.nativeCustomView.streamModel = streamModel;
                    [self.nativeCustomView loadHTMLString:[self streamHtmlWithStreamModel:streamModel]];
                    break;
                }
                case showOfView:
                    [streamModel reloadWebview];
                    break;
                default:
                    break;
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
            [self.presentOrCloseAdButton setTitle:@"Show native" forState:UIControlStateNormal];
            self.checkVideoButton.hidden = NO;
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
            if ([[YumiMediationVideo sharedInstance] isReady]) {
                [alert addAction:[UIAlertAction actionWithTitle:@"Play video"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *_Nonnull action) {
                                                            [[YumiMediationVideo sharedInstance]
                                                                presentFromRootViewController:self];
                                                        }]];
            } else {
                [alert addAction:[UIAlertAction actionWithTitle:@"NO video"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *_Nonnull action){

                                                        }]];
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

- (IBAction)clickStatistics:(UIButton *)sender {

    YumiLocalStatisticsAdsListTableViewController *statisticsVc =
        [[YumiLocalStatisticsAdsListTableViewController alloc] init];

    UINavigationController *navigationVc = [[UINavigationController alloc] initWithRootViewController:statisticsVc];

    [self presentViewController:navigationVc animated:YES completion:nil];
}
- (IBAction)clickModifyID:(UIButton *)sender {
    NSBundle *bundle = [NSBundle mainBundle];
    UIStoryboard *UpgradeHardware = [UIStoryboard storyboardWithName:@"Main" bundle:bundle];
    YumiViewController *rootVc = [UpgradeHardware instantiateViewControllerWithIdentifier:@"YumiViewController"];
    rootVc.presented = YES;
    rootVc.delegate = self;
    [self presentViewController:rootVc animated:YES completion:nil];

    [[UIApplication sharedApplication].keyWindow.layer transitionWithAnimType:TransitionAnimTypeRamdom
                                                                      subType:TransitionSubtypesFromRamdom
                                                                        curve:TransitionCurveRamdom
                                                                     duration:2.0];
}

#pragma mark : - native ad

- (NSString *)streamHtmlWithStreamModel:(YUMIStreamModel *)smodel {
    NSBundle *sourceBundle = [[YumiTool sharedTool] resourcesBundleWithBundleName:@"YumiMediationSDK"];

    NSString *path = [sourceBundle pathForResource:@"stream320x50_icon" ofType:@"html"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *streamHtml = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    streamHtml = [NSString stringWithFormat:streamHtml, @"100%", @"100%", @"100%", @"76%", smodel.iconUrl, smodel.desc];

    return streamHtml;
}

#pragma mark : getter
- (YumiMediationBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[YumiMediationBannerView alloc] initWithYumiID:self.yumiID
                                                            channelID:self.channelID
                                                            versionID:self.versionID
                                                             position:YumiMediationBannerPositionBottom
                                                   rootViewController:self];
    }
    return _bannerView;
}

- (YUMIStreamCustomView *)nativeCustomView {
    if (!_nativeCustomView) {
        _nativeCustomView =
            [[YUMIStreamCustomView alloc] initWithCustomView:CGRectMake((self.view.frame.size.width - 320) / 2,
                                                                        self.view.frame.size.height - 50, 320, 50)
                                                   clickType:CustomViewClickTypeOpenSystem
                                                    delegate:self];
    }

    return _nativeCustomView;
}

- (YUMIStream *)nativeStream {
    if (!_nativeStream) {
        _nativeStream =
            [[YUMIStream alloc] initWithYumiID:self.yumiID channelID:self.channelID versionID:self.versionID];
        _nativeStream.delegate = self;
    }

    return _nativeStream;
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

- (void)yumiMediationInterstitialWillRequestAd:(YumiMediationInterstitial *)interstitial {
    [self showLogConsoleWith:@"interstitial will request ad" adLogType:YumiMediationAdLogTypeInterstitial];
}

- (void)yumiMediationInterstitialDidReceiveAd:(YumiMediationInterstitial *)interstitial {
    self.isConfigSuccess = YES;
    [self showLogConsoleWith:@"interstitial did receive ad" adLogType:YumiMediationAdLogTypeInterstitial];
}

- (void)yumiMediationInterstitial:(YumiMediationInterstitial *)interstitial
                 didFailWithError:(YumiMediationError *)error {
    [self showLogConsoleWith:[NSString stringWithFormat:@"interstitial did fial with error : [ %@ ] ",
                                                        [error localizedDescription]]
                   adLogType:YumiMediationAdLogTypeInterstitial];
}

- (void)yumiMediationInterstitialwillDismissScreen:(YumiMediationInterstitial *)interstitial {
    [self showLogConsoleWith:@"interstitial will dismiss screen" adLogType:YumiMediationAdLogTypeInterstitial];
}

- (void)yumiMediationInterstitialDidClick:(YumiMediationInterstitial *)interstitial {
    [self showLogConsoleWith:@"interstitial did click " adLogType:YumiMediationAdLogTypeInterstitial];
}

#pragma mark - YumiMediationVideoDelegate
- (void)yumiMediationVideoDidClose:(YumiMediationVideo *)video {
    self.isVideoReceive = NO;
    [self showLogConsoleWith:@"video did close " adLogType:YumiMediationAdLogTypeVideo];
}

- (void)yumiMediationVideoDidReward:(YumiMediationVideo *)video {

    [self showLogConsoleWith:@"video did reward " adLogType:YumiMediationAdLogTypeVideo];
}

- (void)yumiMediationVideoDidOpen:(YumiMediationVideo *)video {
    self.isConfigSuccess = YES;
    [self showLogConsoleWith:@"video did open " adLogType:YumiMediationAdLogTypeVideo];
}

- (void)yumiMediationVideoDidStartPlaying:(YumiMediationVideo *)video {
    [self showLogConsoleWith:@"video start playing " adLogType:YumiMediationAdLogTypeVideo];
}

- (void)yumiMediationVideoDidReceive:(YumiMediationVideo *)video {
    self.isVideoReceive = YES;
    [self showLogConsoleWith:@"video did receive " adLogType:YumiMediationAdLogTypeVideo];
}

#pragma mark : - YumiAdsSplashDelegate

- (void)yumiAdsSplashDidLoad:(YumiAdsSplash *)splash {
    [self showLogConsoleWith:@"splash did load " adLogType:YumiMediationAdLogTypeSplash];
}
- (void)yumiAdsSplash:(YumiAdsSplash *)splash DidFailToLoad:(NSError *)error {
    [self showLogConsoleWith:[NSString
                                 stringWithFormat:@"splash did fail with error [ %@ ] ", [error localizedDescription]]
                   adLogType:YumiMediationAdLogTypeSplash];
}
- (void)yumiAdsSplashDidClicked:(YumiAdsSplash *)splash {
    [self showLogConsoleWith:@"splash did clicked " adLogType:YumiMediationAdLogTypeSplash];
}
- (void)yumiAdsSplashDidClosed:(YumiAdsSplash *)splash {
    [self showLogConsoleWith:@"splash did closed " adLogType:YumiMediationAdLogTypeSplash];
}
- (nullable UIImage *)yumiAdsSplashDefaultImage {
    [self showLogConsoleWith:@"splash set default image is nil" adLogType:YumiMediationAdLogTypeSplash];
    return nil;
}

#pragma mark - YUMIStreamDelegate
- (UIViewController *)viewControllerForPresentStream {
    return self;
}

- (void)returnStreamModel:(YUMIStreamModel *)model impressionSize:(CGSize)adSize {
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - adSize.width) / 2,
                                                           [UIScreen mainScreen].bounds.size.height - adSize.height,
                                                           adSize.width, adSize.height)];
    [model showInview:self.bgView];
    [self.view addSubview:self.bgView];
}

- (void)streamAdDidReceive {
    [self showLogConsoleWith:@"native did load " adLogType:YumiMediationAdLogTypeNative];
}
- (void)streamAdStartToRequest {
    [self showLogConsoleWith:@"native start request " adLogType:YumiMediationAdLogTypeNative];
}

- (void)streamAdDidReceiveNumber:(NSUInteger)number {
}

- (void)streamAdFailToReceive:(NSError *)error {
    [self showLogConsoleWith:[NSString stringWithFormat:@"native receive error: [%@]", [error localizedDescription]]
                   adLogType:YumiMediationAdLogTypeNative];
}

#pragma mark - CustomViewdelegate

- (void)adCustomViewDidFail:(NSError *)error {
    [self showLogConsoleWith:[NSString stringWithFormat:@"native error: [%@]", [error localizedDescription]]
                   adLogType:YumiMediationAdLogTypeNative];
}

- (void)adCustomViewDidFinsh:(YUMIStreamCustomView *)customView {
    [self showLogConsoleWith:@"native did show " adLogType:YumiMediationAdLogTypeNative];

    [self.view addSubview:customView];
    [customView.streamModel showInview:self.view];
}

- (void)adCustomViewDidClick:(YUMIStreamCustomView *)customView {
    [self showLogConsoleWith:@"native did click " adLogType:YumiMediationAdLogTypeNative];
    [customView.streamModel clickStreamAd];
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

#pragma mark : - YumiViewControllerDelegate
- (void)modifyYumiID:(NSString *)yumiID channelID:(NSString *)channelID versionID:(NSString *)versionID {

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

    self.yumiID = yumiID;
    self.channelID = channelID;
    self.versionID = versionID;
}
@end
