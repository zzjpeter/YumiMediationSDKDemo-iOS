//
//  YumiMediationInitializeInfoUserDefaults
//  YumiMediationDebugCenter-iOS
//
//  Created by ShunZhi Tang on 2017/7/27.
//  Copyright © 2017年 Zplay. All rights reserved.
//

#import "YumiMediationInitializeModel.h"
#import <Foundation/Foundation.h>

@interface YumiMediationInitializeInfoUserDefaults : NSObject

+ (instancetype)sharedPlacementIDsUserDefaults;

- (void)persistMediationInitializeInfo:(YumiMediationInitializeModel *)placementIDInfoModel;

- (NSArray<YumiMediationInitializeModel *> *)fetchMediationPlacementIDs;

@end
