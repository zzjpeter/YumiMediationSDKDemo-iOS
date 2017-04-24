//
//  YUMIAdStatisticModel.h
//  YUMIVideoSample
//
//  Created by wxl on 15/10/12.
//  Copyright (c) 2015年 AdsYuMI. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @prama: 对自定义对象的归档和解档
 */
@interface YUMIAdStatisticModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString * YUMIAdName;
@property (nonatomic, copy) NSString * YUMIAdType;
@property (nonatomic, assign) NSInteger YUMIRequestCount;
@property (nonatomic, assign) NSInteger YUMIResponseSuccessCount;
@property (nonatomic, assign) NSInteger YUMIResponseFailCount;
@property (nonatomic, assign) NSInteger YUMIexposureCount;
@property (nonatomic, assign) NSInteger YUMIopportCount;
@property (nonatomic, assign) NSInteger YUMIClickCount;
@property (nonatomic, assign) NSInteger YUMIRewardCount;
 

@end


@interface YUMIAdStatisticModelManager : NSObject <NSCoding>

@property(nonatomic,strong) NSMutableDictionary * YUMIAdstatisticDic;

+(YUMIAdStatisticModelManager*)shareStatisticModelManager;

-(void)setStatisticDic:(YUMIAdStatisticModel*)model;

-(YUMIAdStatisticModel*)getStatisticDic:(NSString*)YUMIAdName YUMIAdType:(NSString*)adType;

/**
 *  获取所有参与的平台个数
 *
 *  @return 数组
 */
-(NSArray*)getStatisticArray:(NSString*)adType;


@end
