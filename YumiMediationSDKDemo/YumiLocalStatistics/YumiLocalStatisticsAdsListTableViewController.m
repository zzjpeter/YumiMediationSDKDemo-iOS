//
//  YumiLocalStatisticsAdsListTableViewController.m
//  YumiMediationSDK-iOS
//
//  Created by wxl on 15/10/12.
//  Copyright (c) 2015年 AdsYuMI. All rights reserved.
//

#import "YumiLocalStatisticsAdsListTableViewController.h"
#import "YumiLocalStatisticsDataTableViewController.h"

@interface YumiLocalStatisticsAdsListTableViewController ()

@property (nonatomic) NSArray *ads;
@property (nonatomic) NSArray *adTypes;

@end

@implementation YumiLocalStatisticsAdsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"广告类型";
    self.ads = @[ @"Banner", @"Interstital", @"Video" ];
    self.adTypes = @[ @"2", @"3", @"5" ];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ads.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"YumiAdsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    cell.textLabel.text = self.ads[indexPath.row];

    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YumiLocalStatisticsDataTableViewController *detailVC =
        [YumiLocalStatisticsDataTableViewController defaultTableViewController];
    detailVC.adType = self.adTypes[indexPath.row];
    [detailVC refresh];
    [detailVC setAdTitle:self.ads[indexPath.row]];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
