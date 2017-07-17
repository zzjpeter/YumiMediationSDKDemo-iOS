//
//  YumiLocalStatisticsDataTableViewController.h
//  YumiMediationSDK-iOS
//
//  Created by wxl on 15/10/12.
//  Copyright (c) 2015年 AdsYuMI. All rights reserved.
//

#import "YumiLocalStatistics.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YumiMediationStatisticsType) {
    YumiMediationStatisticsRequest = 1,
    YumiMediationStatisticsSuccess = 2,
    YumiMediationStatisticsFail = 3,
    YumiMediationStatisticsImpression = 4,
    YumiMediationStatisticsClick = 5,
    YumiMediationStatisticsOpportunity = 6,
    YumiMediationStatisticsStart = 7,
    YumiMediationStatisticsEnd = 8,
    YumiMediationStatisticsReward = 9
};

NS_ASSUME_NONNULL_BEGIN

@interface YumiLocalStatisticsDataTableViewController : UITableViewController

@property (nonatomic) NSString *adType;
@property (nonatomic) NSString *adTitle;
@property (nonatomic) YumiLocalStatisticsManager *localStatisticsManager;

+ (YumiLocalStatisticsDataTableViewController *)defaultTableViewController;
- (void)refresh;

@end

NS_ASSUME_NONNULL_END
