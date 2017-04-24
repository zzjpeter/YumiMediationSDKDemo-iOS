//
//  YUMIStatisticTableViewController.m
//  YUMIVideoSample
//
//  Created by wxl on 15/10/12.
//  Copyright (c) 2015年 AdsYuMI. All rights reserved.
//

#import "YUMIStatisticTableViewController.h"
#import "YUMIStatisticDetailTableViewController.h"

@interface YUMIStatisticTableViewController ()

@property (nonatomic, retain) NSArray * adArray;

@end

@implementation YUMIStatisticTableViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.adArray = @[@"Banner",@"Interstital",@"Video"];
    
    UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(0, 0, 60, 30)];
    [back setTitle:@"Back" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    back.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.adArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"YUMICell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    cell.textLabel.text = self.adArray[indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   YUMIStatisticDetailTableViewController * detail = [YUMIStatisticDetailTableViewController shareViewController];
  
  if (indexPath.row==0) {
    detail.adType = [NSString stringWithFormat:@"2"];
  }else if (indexPath.row==1){
    detail.adType = [NSString stringWithFormat:@"3"];
  }else{
    detail.adType = [NSString stringWithFormat:@"5"];
  }
  
  [detail refreshObserver];
    [self.navigationController pushViewController:detail animated:YES];
}


@end
