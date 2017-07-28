//
//  YumiMediationInitializeInfoUserDefaults.m
//  YumiMediationDebugCenter-iOS
//
//  Created by ShunZhi Tang on 2017/7/27.
//  Copyright © 2017年 Zplay. All rights reserved.
//

#import "YumiMediationInitializeInfoUserDefaults.h"

static NSString *const key = @"YumiMediation_YumiIDs_key";

@implementation YumiMediationInitializeInfoUserDefaults

+ (instancetype)sharedYumiIDsUserDefaults {
    static YumiMediationInitializeInfoUserDefaults *sharedUserDefaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUserDefaults = [[self alloc] init];
    });
    return sharedUserDefaults;
}

- (void)persistMediationInitializeInfo:(YumiMediationInitializeModel *)yumiIDInfoModel {

    NSMutableArray<YumiMediationInitializeModel *> *yumiIDs = [[self fetchMediationYumiIDs] mutableCopy];
    if (!yumiIDs) {
        yumiIDs = [NSMutableArray array];
    }

    for (int index = 0; index < yumiIDs.count; index++) {
        YumiMediationInitializeModel *tempModel = yumiIDs[index];

        if ([tempModel.yumiID isEqualToString:yumiIDInfoModel.yumiID]) {
            [yumiIDs removeObjectAtIndex:index];
        }
    }

    [yumiIDs insertObject:yumiIDInfoModel atIndex:0];

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:yumiIDs];

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:data forKey:key];
    [standardUserDefaults synchronize];
}

- (NSArray<YumiMediationInitializeModel *> *)fetchMediationYumiIDs {

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [standardUserDefaults objectForKey:key];
    NSArray *yumiIDs = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    return yumiIDs;
}

@end
