//
//  YumiMediationInitializeInfoUserDefaults.m
//  YumiMediationDebugCenter-iOS
//
//  Created by ShunZhi Tang on 2017/7/27.
//  Copyright © 2017年 Zplay. All rights reserved.
//

#import "YumiMediationInitializeInfoUserDefaults.h"

static NSString *const key = @"YumiMediation_PlacementIDs_key";

@implementation YumiMediationInitializeInfoUserDefaults

+ (instancetype)sharedPlacementIDsUserDefaults {
    static YumiMediationInitializeInfoUserDefaults *sharedUserDefaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUserDefaults = [[self alloc] init];
    });
    return sharedUserDefaults;
}

- (void)persistMediationInitializeInfo:(YumiMediationInitializeModel *)placementIDInfoModel {

    NSMutableArray<YumiMediationInitializeModel *> *placementIDs = [[self fetchMediationPlacementIDs] mutableCopy];
    if (!placementIDs) {
        placementIDs = [NSMutableArray array];
    }

    for (int index = 0; index < placementIDs.count; index++) {
        YumiMediationInitializeModel *tempModel = placementIDs[index];

        if ([tempModel.placementID isEqualToString:placementIDInfoModel.placementID]) {
            [placementIDs removeObjectAtIndex:index];
        }
    }

    [placementIDs insertObject:placementIDInfoModel atIndex:0];

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:placementIDs];

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:data forKey:key];
    [standardUserDefaults synchronize];
}

- (NSArray<YumiMediationInitializeModel *> *)fetchMediationPlacementIDs {

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [standardUserDefaults objectForKey:key];
    if (!data) {
        return nil;
    }
    NSArray *placementIDs = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    return placementIDs;
}

@end
