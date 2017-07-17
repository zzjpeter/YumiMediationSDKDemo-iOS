//
//  YumiLocalStatistics.m
//  YumiMediationSDK-iOS
//
//  Created by wxl on 15/10/12.
//  Copyright (c) 2015年 AdsYuMI. All rights reserved.
//

#import "YumiLocalStatistics.h"
#import "NSObject+YumiYYModel.h"

@implementation YumiLocalStatistics
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

@end

@implementation YumiLocalStatisticsManager
- (instancetype)init {
    self = [super init];

    self.statisticData = [[NSMutableDictionary alloc] init];

    return self;
}

+ (YumiLocalStatisticsManager *)defaultManager {
    static YumiLocalStatisticsManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YumiLocalStatisticsManager alloc] init];
    });
    return manager;
}

- (void)cacheStatisticData:(YumiLocalStatistics *)parameters {
    NSString *dataKey = [NSString stringWithFormat:@"%@_%@", parameters.adName, parameters.adType];
    YumiLocalStatistics *localStatistics = self.statisticData[dataKey];

    if (localStatistics) {
        localStatistics.adRequestCount += parameters.adRequestCount;
        localStatistics.adResponseSuccessCount += parameters.adResponseSuccessCount;
        localStatistics.adResponseFailCount += parameters.adResponseFailCount;
        localStatistics.adImpressionCount += parameters.adImpressionCount;
        localStatistics.adOpportunityCount += parameters.adOpportunityCount;
        localStatistics.adClickCount += parameters.adClickCount;
        localStatistics.adStartCount += parameters.adStartCount;
        localStatistics.adEndCount += parameters.adEndCount;
        localStatistics.adRewardCount += parameters.adRewardCount;
        self.statisticData[dataKey] = localStatistics;
    } else {
        self.statisticData[dataKey] = parameters;
    }

    if (self.statisticData.count) {
        NSString *path = [YumiLocalStatisticsManager filePath:[parameters.adType intValue]];
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:self.statisticData forKey:parameters.adType];
        [archiver finishEncoding];
        [data writeToFile:path atomically:YES];
    }
}

- (NSMutableDictionary<NSString *, YumiLocalStatistics *> *)getStatisticData:(NSString *)adType {
    NSMutableDictionary *adStatistics = [[NSMutableDictionary alloc] init];
    [self.statisticData enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, YumiLocalStatistics *_Nonnull obj,
                                                            BOOL *_Nonnull stop) {
        NSString *realKey = [[key componentsSeparatedByString:@"_"] lastObject];
        if (![realKey isEqualToString:adType]) {
            return;
        }
        [adStatistics setObject:obj forKey:key];
    }];
    return adStatistics;
}

- (void)prepareForStatisticsDataWithAdType:(NSString *)adType {
    NSString *path = [YumiLocalStatisticsManager filePath:[adType intValue]];
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    self.statisticData = [unarchiver decodeObjectForKey:adType];
    [unarchiver finishDecoding];
}

+ (NSString *)filePath:(int)adType {
    return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%d", adType]];
}

@end
