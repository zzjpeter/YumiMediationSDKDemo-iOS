//
//  YuMIDebugIntegratedTableViewController.h
//  AdsYUMISample
//
//  Created by weixiaolei on 16/11/17.
//  Copyright © 2016年 AdsYuMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YuMIDebugIntegratedTableViewController : UITableViewController

/**
 广告配置集合
 */
@property (nonatomic, strong) NSMutableDictionary *resultDictionary;
/**
 广告请求成功集合
 */
@property (nonatomic, strong) NSDictionary *valuableDict;



- (void)backAction;
@end
