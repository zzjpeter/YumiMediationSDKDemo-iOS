//
//  YuMIDebugCore.m
//  YuMIDebugCenter
//
//  Created by chenzhangtao on 2016/11/17.
//  Copyright © 2016年 CastielChen. All rights reserved.
//

#import "YuMIDebugCenter.h"
#import "YuMIDebugIntegratedTableViewController.h"
#import "YuMIToolDevice.h"

#define YUMIDebugConfigurationKey             @"ConfigurationKey"
#define YUMIDebugKey                          @"yumi_key"
#define YUMIDebugChannel                      @"yumi_channle"
#define YUMIDebugVersion                      @"yumi_versions"
#define YUMIDebugAdtype                       @"yumi_adtype"

#define YUMIDebugBannerAndInterstitalFilePath @"Caches/YUMICache"
#define YUMIDebugVideoFilePath                @"Caches/YUMICache/Video"
#define AdValuableKey                         @"Zplay_AdValuableKey"
#define YUMIDebugLoadAllVideoAdapter          @"YUMILoadAllVideoAdapter"

@interface YuMIDebugCenter()

@property(strong,nonatomic)  NSMutableDictionary  *pathDictionary;
@property(strong,nonatomic)  NSMutableDictionary  *resultDictionary;
@property(strong,nonatomic)  NSMutableDictionary  *allVideoAdapter;
@property(strong,nonatomic)  NSMutableDictionary  *valuableDict;

@end

@implementation YuMIDebugCenter

+ (void)load {
    [YuMIDebugCenter shareInstance];
}

static YuMIDebugCenter *instance;
+ (YuMIDebugCenter *)shareInstance{
    if (!instance) {
        
        instance = [[YuMIDebugCenter alloc] init];
        instance.resultDictionary  = [[NSMutableDictionary alloc]init];
        instance.pathDictionary  = [[NSMutableDictionary alloc]init];
        instance.valuableDict  = [[NSMutableDictionary alloc]init];
        
        //监听初始化接口 banner、inster 、video
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(debugLogCenterInitConfiger:) name:YUMIDebugConfigurationKey object:nil];
        //监听视频所有adpter的初始化
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(YUMILoadAllVideoAdapter:) name:YUMIDebugLoadAllVideoAdapter object:nil];
        //监听广告的成功回调
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(adIsValuable:) name:AdValuableKey object:nil];
    }
    return instance;
}


-(void)YUMILoadAllVideoAdapter:(NSNotification *)sender{
    _allVideoAdapter  = [[NSMutableDictionary alloc] initWithDictionary:sender.userInfo];
}


-(void)debugLogCenterInitConfiger:(NSNotification *)sender{
    NSDictionary * params =sender.userInfo;
    NSString *file_name= [[YuMIToolDevice shareToolDevice] getSaveConfigStr:[params objectForKey:YUMIDebugKey]
                                                                    channel:[params objectForKey:YUMIDebugChannel]
                                                                    version:[params objectForKey:YUMIDebugVersion]
                                                                     adType:[[params objectForKey:YUMIDebugAdtype] integerValue]];
    NSString *file_path;
    if ([[params objectForKey:@"yumi_adtype"] integerValue]==5) {//视频存放路径
        file_path = [ [[YuMIToolDevice shareToolDevice] getCacheFilePath:YUMIDebugVideoFilePath] stringByAppendingPathComponent:file_name];
    }else {//banner插屏存放路径
        file_path = [ [[YuMIToolDevice shareToolDevice] getCacheFilePath:YUMIDebugBannerAndInterstitalFilePath] stringByAppendingPathComponent:file_name];
    }
    //存储路径
    [self.pathDictionary setObject:file_path forKey:file_name];
    //获取配置数据
    [self createConfigurationData:file_path adtype:params[YUMIDebugAdtype]];
}

//监测广告加载成功的回调
- (void)adIsValuable:(NSNotification *)notification {
    NSDictionary * params =notification.userInfo;
    NSString *pId_type = [params.allKeys firstObject];
    NSArray *providerID = [pId_type componentsSeparatedByString:@"_"];
    NSString *nId_type;
    if ([[providerID firstObject] intValue] > 100000) {
       nId_type = [pId_type substringFromIndex:1];
    }else {
       nId_type = pId_type;
    }
    NSString *isValuable = params[pId_type];
    [instance.valuableDict setObject:isValuable?isValuable:@"NO" forKey:nId_type];
}

- (void)createConfigurationData:(NSString *)path adtype:(NSString *)adtype {
    NSData *data = [[YuMIToolDevice shareToolDevice] getDataFromFile:path];
    if (!data) {
        return;
    }
    NSDictionary *data_dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *providerArray = data_dic[@"providers"];
    for (NSDictionary *pro_dic in providerArray) {
        if ([pro_dic[@"reqType"] intValue] == 1) {
          
            NSString *providerID = pro_dic[@"providerID"];
            if ([pro_dic[@"providerID"] integerValue] > 100000) {
                providerID = [providerID substringFromIndex:1];
            }
          
            NSMutableDictionary *old_dic = [[NSMutableDictionary alloc] init];
            NSString *pro_key = [NSString stringWithFormat:@"%@_%@",providerID,adtype];
            [old_dic setObject:providerID?providerID:@"" forKey:@"providerID"];
            [old_dic setObject:pro_dic[@"keys"][@"key1"]?pro_dic[@"keys"][@"key1"]:@"" forKey:@"key1"];
            [old_dic setObject:pro_dic[@"keys"][@"key2"]?pro_dic[@"keys"][@"key2"]:@"" forKey:@"key2"];
            [old_dic setObject:pro_dic[@"keys"][@"key3"]?pro_dic[@"keys"][@"key3"]:@"" forKey:@"key3"];
            [old_dic setObject:pro_dic[@"outTime"]?pro_dic[@"outTime"]:@"" forKey:@"outTime"];
            [old_dic setObject:adtype?adtype:@"" forKey:@"adtype"];
            [self.resultDictionary setObject:old_dic forKey:pro_key];
        }
    }
  
    if (_allVideoAdapter) {
        for (NSString * key in [self.resultDictionary allKeys]) {
            NSMutableDictionary * dic =[self.resultDictionary objectForKey:key];
            if ([[dic objectForKey:@"adtype"] integerValue]==5) {
                NSString *pro_key = [NSString stringWithFormat:@"%@_%@",dic[@"providerID"],[dic objectForKey:@"adtype"]];
                
                if ([_allVideoAdapter objectForKey:dic[@"providerID"]]==nil) {
                    break;
                }
                [dic setObject:[_allVideoAdapter objectForKey:dic[@"providerID"]] forKey:@"videoAdapter"];

                [self.resultDictionary setObject:dic forKey:pro_key];
            }
        }

    }
    
}

- (NSMutableDictionary *)getPathDictionary {
    return self.pathDictionary;
}


-(void)startDebugging:(UIViewController*)viewController{
    YuMIDebugIntegratedTableViewController *table = [[YuMIDebugIntegratedTableViewController alloc] init];
    table.resultDictionary = self.resultDictionary;
    table.valuableDict = instance.valuableDict;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:table];
    [viewController presentViewController:nav animated:YES completion:^{
        
    }];
}


@end
