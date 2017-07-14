//
//  YUMIStatisticDetailTableViewController.h
//  YUMIVideoSample
//
//  Created by wxl on 15/10/12.
//  Copyright (c) 2015年 AdsYuMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YUMIStatisticDetailTableViewController : UITableViewController


@property (strong, nonatomic) IBOutlet UITableView *yumiTableView;

@property (nonatomic, copy) NSString * adType;
+(YUMIStatisticDetailTableViewController*)shareViewController;

- (void)refreshObserver;
@end
