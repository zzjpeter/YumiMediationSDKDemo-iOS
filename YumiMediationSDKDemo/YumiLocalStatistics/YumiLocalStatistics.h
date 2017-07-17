//
//  YumiLocalStatistics.h
//  YumiMediationSDK-iOS
//
//  Created by wxl on 15/10/12.
//  Copyright (c) 2015年 AdsYuMI. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YumiLocalStatistics : NSObject <NSCoding>

@property (nonatomic) NSString *adName;
@property (nonatomic) NSString *adType;
@property (nonatomic, assign) NSUInteger adRequestCount;
@property (nonatomic, assign) NSUInteger adResponseSuccessCount;
@property (nonatomic, assign) NSUInteger adResponseFailCount;
@property (nonatomic, assign) NSUInteger adImpressionCount;
@property (nonatomic, assign) NSUInteger adOpportunityCount;
@property (nonatomic, assign) NSUInteger adClickCount;
@property (nonatomic, assign) NSUInteger adStartCount;
@property (nonatomic, assign) NSUInteger adEndCount;
@property (nonatomic, assign) NSUInteger adRewardCount;

@end

@interface YumiLocalStatisticsManager : NSObject

@property (nonatomic) NSMutableDictionary<NSString *, YumiLocalStatistics *> *statisticData;

+ (YumiLocalStatisticsManager *)defaultManager;
- (void)prepareForStatisticsDataWithAdType:(NSString *)adType;
- (void)cacheStatisticData:(YumiLocalStatistics *)parameters;
- (NSMutableDictionary<NSString *, YumiLocalStatistics *> *)getStatisticData:(NSString *)adType;

@end

NS_ASSUME_NONNULL_END
