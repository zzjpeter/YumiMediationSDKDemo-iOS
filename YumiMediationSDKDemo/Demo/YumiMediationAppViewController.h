//
//  YumiMediationAppViewController.h
//  YumiMediationSDKDemo
//
//  Created by ShunZhi Tang on 2017/7/13.
//  Copyright © 2017年 Zplay. All rights reserved.
//

#import "YumiCommonHeaderFile.h"
#import <UIKit/UIKit.h>

@interface YumiMediationAppViewController : UIViewController

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithPlacementID:(NSString *)placementID
                          channelID:(NSString *)channelID
                          versionID:(NSString *)versionID
                             adType:(YumiAdType)adType;

@end
