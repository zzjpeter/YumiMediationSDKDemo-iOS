//
//  YumiViewController.h
//  YumiMediationDebugCenter-iOS
//
//  Created by ShunZhi Tang on 2017/7/13.
//  Copyright © 2017年 Zplay. All rights reserved.
//

@import UIKit;
#import "YumiCommonHeaderFile.h"
#import <YumiMediationSDK/YumiMediationConstants.h>

static NSString *const placementID = @"k21ubzif";
static NSString *const channelID = @"";
static NSString *const versionID = @"";

@protocol YumiViewControllerDelegate <NSObject>

- (void)modifyPlacementID:(NSString *)placementID
                channelID:(NSString *)channelID
                versionID:(NSString *)versionID
                   adType:(YumiAdType)adType
               bannerSize:(YumiMediationAdViewBannerSize) bannerSize;

@end

@interface YumiViewController : UIViewController

@property (nonatomic, weak) id<YumiViewControllerDelegate> delegate;
@property (nonatomic, assign, getter=isPresented) BOOL presented;
@property (nonatomic, assign) YumiAdType adType;
@property (nonatomic, assign) YumiMediationAdViewBannerSize bannerSize;

@end
