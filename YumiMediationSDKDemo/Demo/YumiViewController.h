//
//  YumiViewController.h
//  YumiMediationDebugCenter-iOS
//
//  Created by ShunZhi Tang on 2017/7/13.
//  Copyright © 2017年 Zplay. All rights reserved.
//

@import UIKit;
#import "YumiCommonHeaderFile.h"

static NSString *const placementID = @"51x4yqe8";
static NSString *const channelID = @"zy005";
static NSString *const versionID = @"5.1.1";

@protocol YumiViewControllerDelegate <NSObject>

- (void)modifyPlacementID:(NSString *)placementID
                channelID:(NSString *)channelID
                versionID:(NSString *)versionID
                   adType:(YumiAdType)adType;

@end

@interface YumiViewController : UIViewController

@property (nonatomic, weak) id<YumiViewControllerDelegate> delegate;
@property (nonatomic, assign, getter=isPresented) BOOL presented;
@property (nonatomic, assign) YumiAdType adType;

@end
