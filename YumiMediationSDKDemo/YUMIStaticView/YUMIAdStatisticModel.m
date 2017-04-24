//
//  YUMIAdStatisticModel.m
//  YUMIVideoSample
//
//  Created by wxl on 15/10/12.
//  Copyright (c) 2015年 AdsYuMI. All rights reserved.
//

#import "YUMIAdStatisticModel.h"
#define YUMIAdNameKey @"ad_name"
#define YUMIAdTypeKey @"ad_type"
#define YUMIRequestCountKey @"ad_request"
#define YUMIResponseSuccessCountKey @"ad_success"
#define YUMIResponseFailCountKey @"ad_fail"
#define YUMIexposureCountKey @"ad_exposure"
#define YUMIopportCountKey @"ad_opport"
#define YUMIClickCountKey @"ad_click"
#define YUMIRewardCountKey @"ad_reward"

#define YUMIDictionaryKey @"ad_dict"

@implementation YUMIAdStatisticModel
/**
 *  【注】:要将一个自定义的类进行归档，那么类里面的每个属性都必须是可以被归档的，如果是不能归档的类型，我们可以把他转化为NSValue进行归档，然后在读出来的时候在转化为相应的类。
 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:_YUMIAdName forKey:YUMIAdNameKey];
  [aCoder encodeObject:_YUMIAdType forKey:YUMIAdTypeKey];
  [aCoder encodeInteger:_YUMIRequestCount forKey:YUMIRequestCountKey];
  [aCoder encodeInteger:_YUMIResponseSuccessCount forKey:YUMIResponseSuccessCountKey];
  [aCoder encodeInteger:_YUMIResponseFailCount forKey:YUMIResponseFailCountKey];
  [aCoder encodeInteger:_YUMIexposureCount forKey:YUMIexposureCountKey];
  [aCoder encodeInteger:_YUMIopportCount forKey:YUMIopportCountKey];
  [aCoder encodeInteger:_YUMIClickCount forKey:YUMIClickCountKey];
  [aCoder encodeInteger:_YUMIRewardCount forKey:YUMIRewardCountKey];
  
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self=[super init]) {
    _YUMIAdName = [aDecoder decodeObjectForKey:YUMIAdNameKey];
    _YUMIAdType = [aDecoder decodeObjectForKey:YUMIAdTypeKey];
    _YUMIRequestCount = [aDecoder decodeIntegerForKey:YUMIRequestCountKey];
    _YUMIResponseSuccessCount = [aDecoder decodeIntegerForKey:YUMIResponseSuccessCountKey];
    _YUMIResponseFailCount = [aDecoder decodeIntegerForKey:YUMIResponseFailCountKey];
    _YUMIexposureCount = [aDecoder decodeIntegerForKey:YUMIexposureCountKey];
    _YUMIopportCount = [aDecoder decodeIntegerForKey:YUMIopportCountKey];
    _YUMIClickCount = [aDecoder decodeIntegerForKey:YUMIClickCountKey];
    _YUMIRewardCount = [aDecoder decodeIntegerForKey:YUMIRewardCountKey];
  }
  return self;
}

- (id)copyWithZone:(NSZone *)zone {

    YUMIAdStatisticModel *model = [[[self class] allocWithZone:zone] init];
    model.YUMIAdName = [self.YUMIAdName copyWithZone:zone];
    model.YUMIAdType = [self.YUMIAdType copyWithZone:zone];
    model.YUMIRequestCount = self.YUMIRequestCount;
    model.YUMIResponseSuccessCount = self.YUMIResponseSuccessCount;
    model.YUMIResponseFailCount = self.YUMIResponseFailCount;
    model.YUMIexposureCount = self.YUMIexposureCount;
    model.YUMIopportCount = self.YUMIopportCount;
    model.YUMIClickCount = self.YUMIClickCount;
    model.YUMIRewardCount = self.YUMIRewardCount;
    
    return model;
}

@end

@interface YUMIAdStatisticModelManager() {

    YUMIAdStatisticModel *_staticModel;
}

@end

@implementation YUMIAdStatisticModelManager

//读取coder中的数据
- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self=[super init]) {
    
    _YUMIAdstatisticDic = [aDecoder decodeObjectForKey:YUMIDictionaryKey];
    
  }
  return self;
}

//向coder中写入数据
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_YUMIAdstatisticDic forKey:YUMIDictionaryKey];
}

- (id)copyWithZone:(NSZone *)zone {
    
    YUMIAdStatisticModelManager *manager = [[[self class] allocWithZone:zone] init];
    manager.YUMIAdstatisticDic = [self.YUMIAdstatisticDic copyWithZone:zone];
    
    return manager;
}

+(YUMIAdStatisticModelManager*)shareStatisticModelManager{
  static YUMIAdStatisticModelManager *modelManager;
    if (!modelManager) {
      static dispatch_once_t onceToken;
      dispatch_once(&onceToken, ^{
        modelManager  =[[YUMIAdStatisticModelManager alloc]init];
      });
    }
    return modelManager;
}

//预加载时读取数据
+(void)load{
    
    YUMIAdStatisticModelManager * modelManager2=[YUMIAdStatisticModelManager shareStatisticModelManager];
    modelManager2.YUMIAdstatisticDic =[[NSMutableDictionary alloc]init];
    for (int i =2; i<6; i++) {
        NSString * path = [[YUMIAdStatisticModelManager shareStatisticModelManager] filePath:[NSString stringWithFormat:@"_%d",i]];
        //解档
        NSData *outData = [[NSMutableData alloc] initWithContentsOfFile:path];
        if (outData==nil) {
          continue;
        }
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:outData];
        NSMutableDictionary * dataDic = [unarchiver decodeObjectForKey:[NSString stringWithFormat:@"_%d",i]];
        for (NSString * key in [dataDic allKeys]) {
          
            [modelManager2.YUMIAdstatisticDic setObject:[dataDic objectForKey:key] forKey:key];
        }
        
        [unarchiver finishDecoding];
        
    }
}

//存储统计数据
-(void)setStatisticDic:(YUMIAdStatisticModel*)paramsmodel{
  
  NSString * dic_key =[NSString stringWithFormat:@"%@_%@",paramsmodel.YUMIAdName,paramsmodel.YUMIAdType];
  
  _staticModel = [self.YUMIAdstatisticDic objectForKey:dic_key];
  
  if (!_staticModel) {
    [self.YUMIAdstatisticDic setObject:paramsmodel forKey:dic_key];
  }else{
    _staticModel.YUMIRequestCount+=paramsmodel.YUMIRequestCount;
    _staticModel.YUMIResponseSuccessCount +=paramsmodel.YUMIResponseSuccessCount;
    _staticModel.YUMIResponseFailCount +=paramsmodel.YUMIResponseFailCount;
    _staticModel.YUMIexposureCount +=paramsmodel.YUMIexposureCount;
    _staticModel.YUMIopportCount +=paramsmodel.YUMIopportCount;
    _staticModel.YUMIClickCount +=paramsmodel.YUMIClickCount;
    _staticModel.YUMIRewardCount +=paramsmodel.YUMIRewardCount;
  }
  
  // 时时刷新
  [[NSNotificationCenter defaultCenter] postNotificationName:@"YUMIRefresh" object:self userInfo:nil];
  
  if (self.YUMIAdstatisticDic.count!= 0) {
    //归档
    NSString * path = [[YUMIAdStatisticModelManager shareStatisticModelManager] filePath:[NSString stringWithFormat:@"_%@",paramsmodel.YUMIAdType]];
    NSString * key = [NSString stringWithFormat:@"_%@",paramsmodel.YUMIAdType];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.YUMIAdstatisticDic forKey:key];
    [archiver finishEncoding];
    [data writeToFile:path atomically:YES];
  }
  
}


//获取存储的数据模型
-(YUMIAdStatisticModel*)getStatisticDic:(NSString*)YUMIAdName YUMIAdType:(NSString*)adType{
  
  NSArray * array =[YUMIAdName componentsSeparatedByString:@"_"];
  NSString * dic_key =[NSString stringWithFormat:@"%@_%@",[array objectAtIndex:0],adType];
  _staticModel= [self.YUMIAdstatisticDic objectForKey:dic_key];
  
  return _staticModel;
}

//展示数据的数组
-(NSArray*)getStatisticArray:(NSString*)adType{
  
  NSMutableArray * returnArray =[[NSMutableArray alloc]init];
  NSArray * array_key =[self.YUMIAdstatisticDic allKeys];
  for (NSString* keystr in array_key) {
    if ([keystr hasSuffix:[NSString stringWithFormat:@"_%@",adType]]) {
      [returnArray addObject:keystr];
    }
  }
  return returnArray;
}

-(NSString *)filePath:(NSString *)type {
  
  NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@",type]];
  
  return path;
}


@end
