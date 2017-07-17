//
//  YumiLocalStatisticsDataTableViewController.m
//  YUMIVideoSample
//
//  Created by wxl on 15/10/12.
//  Copyright (c) 2015年 AdsYuMI. All rights reserved.
//

#import "YumiLocalStatisticsDataTableViewController.h"

@interface YumiLocalStatisticsDataTableViewController ()

@property (nonatomic) NSMutableDictionary *ads;

@end

@implementation YumiLocalStatisticsDataTableViewController
+ (YumiLocalStatisticsDataTableViewController *)defaultTableViewController {
    static YumiLocalStatisticsDataTableViewController *statistic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        statistic = [[YumiLocalStatisticsDataTableViewController alloc]
            initWithNibName:@"YumiLocalStatisticsDataTableViewController"
                     bundle:nil];
    });
    return statistic;
}

+ (void)load {
    NSArray *nameList =
        @[ @"request", @"success", @"fail", @"exposure", @"opport", @"click", @"start", @"end", @"reward" ];
    for (NSString *name in nameList) {
        [[NSNotificationCenter defaultCenter]
            addObserver:[YumiLocalStatisticsDataTableViewController defaultTableViewController]
               selector:@selector(actionObserver:)
                   name:name
                 object:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationItem.title = self.adTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 7, 80, 30)];
    [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightButton setTitle:@"refresh" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(prepareData) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)prepareData {
    [[YumiLocalStatisticsManager defaultManager] prepareForStatisticsDataWithAdType:self.adType];

    [self refresh];
}

- (void)refresh {
    self.ads = [[YumiLocalStatisticsManager defaultManager] getStatisticData:self.adType];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - NoticationCenter Delegate
- (void)actionObserver:(NSNotification *)info {
    id obj = [info userInfo];

    YumiLocalStatistics *adModel = [[YumiLocalStatistics alloc] init];
    adModel.adName = [obj[@"name"] lowercaseString];
    adModel.adType = [obj[@"adType"] lowercaseString];
    [self count:adModel action:obj[@"action"]];

    [[YumiLocalStatisticsManager defaultManager] cacheStatisticData:adModel];
}

- (void)count:(YumiLocalStatistics *)adModel action:(NSString *)action {
    NSArray *nameList =
        @[ @"request", @"success", @"fail", @"exposure", @"opport", @"click", @"start", @"end", @"reward" ];
    NSMutableDictionary<NSString *, NSNumber *> *actionList = [NSMutableDictionary dictionary];
    [nameList enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [actionList setObject:@(idx + 1) forKey:obj];
    }];

    switch ([actionList[action] intValue]) {
        case YumiMediationStatisticsRequest:
            adModel.adRequestCount = 1;
            break;
        case YumiMediationStatisticsSuccess:
            adModel.adResponseSuccessCount = 1;
            break;
        case YumiMediationStatisticsFail:
            adModel.adResponseFailCount = 1;
            break;
        case YumiMediationStatisticsImpression:
            adModel.adImpressionCount = 1;
            break;
        case YumiMediationStatisticsClick:
            adModel.adClickCount = 1;
            break;
        case YumiMediationStatisticsOpportunity:
            adModel.adOpportunityCount = 1;
            break;
        case YumiMediationStatisticsStart:
            adModel.adStartCount = 1;
            break;
        case YumiMediationStatisticsEnd:
            adModel.adEndCount = 1;
            break;
        case YumiMediationStatisticsReward:
            adModel.adRewardCount = 1;
            break;
        default:
            break;
    }
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 28.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 28)];
    bgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *show = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, bgView.bounds.size.width, 28)];
    show.font = [UIFont systemFontOfSize:15];
    show.text = self.ads.allKeys[section];
    [bgView addSubview:show];
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([self.adType intValue]) {
        case 2:
            return 248.f;
            break;
        case 3:
            return 289.f;
            break;
        case 5:
            return 288.f;
            break;
        default:
            return 0;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.ads.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.adType isEqualToString:@"2"]) {
        static NSString *cellID = @"YumiLocalStatisticsCellBanner";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YumiLocalStatisticsCell" owner:self options:nil]
                objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        UITextField *tf1 = (UITextField *)[cell.contentView viewWithTag:90];
        UITextField *tf2 = (UITextField *)[cell.contentView viewWithTag:91];
        UITextField *tf3 = (UITextField *)[cell.contentView viewWithTag:92];
        UITextField *tf4 = (UITextField *)[cell.contentView viewWithTag:93];
        UITextField *tf5 = (UITextField *)[cell.contentView viewWithTag:94];
        UITextField *tf6 = (UITextField *)[cell.contentView viewWithTag:95];

        NSString *adKey = self.ads.allKeys[indexPath.section];
        YumiLocalStatistics *model = self.ads[adKey];

        tf1.text = [NSString stringWithFormat:@"%ld", (long)model.adRequestCount];
        tf2.text = [NSString stringWithFormat:@"%ld", (long)(model.adResponseSuccessCount + model.adResponseFailCount)];
        tf3.text = [NSString stringWithFormat:@"%ld", (long)model.adImpressionCount];
        tf4.text = [NSString stringWithFormat:@"%ld", (long)model.adClickCount];
        tf5.text = [NSString stringWithFormat:@"%ld", (long)model.adResponseSuccessCount];
        tf6.text = [NSString stringWithFormat:@"%ld", (long)model.adResponseFailCount];

        return cell;
    } else if ([self.adType isEqualToString:@"3"]) {
        static NSString *cellID = @"YUMIDetailInterstitalCellInterstitial";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YumiLocalStatisticsCell" owner:self options:nil]
                objectAtIndex:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        UITextField *tf1 = (UITextField *)[cell.contentView viewWithTag:100];
        UITextField *tf2 = (UITextField *)[cell.contentView viewWithTag:101];
        UITextField *tf3 = (UITextField *)[cell.contentView viewWithTag:102];
        UITextField *tf4 = (UITextField *)[cell.contentView viewWithTag:103];
        UITextField *tf5 = (UITextField *)[cell.contentView viewWithTag:104];
        UITextField *tf6 = (UITextField *)[cell.contentView viewWithTag:105];
        UITextField *tf7 = (UITextField *)[cell.contentView viewWithTag:106];

        NSString *adKey = self.ads.allKeys[indexPath.section];
        YumiLocalStatistics *model = self.ads[adKey];

        tf1.text = [NSString stringWithFormat:@"%ld", (long)model.adRequestCount];
        tf2.text = [NSString stringWithFormat:@"%ld", (long)(model.adResponseSuccessCount + model.adResponseFailCount)];
        tf3.text = [NSString stringWithFormat:@"%ld", (long)model.adOpportunityCount];
        tf4.text = [NSString stringWithFormat:@"%ld", (long)model.adImpressionCount];
        tf5.text = [NSString stringWithFormat:@"%ld", (long)model.adClickCount];
        tf6.text = [NSString stringWithFormat:@"%ld", (long)model.adResponseSuccessCount];
        tf7.text = [NSString stringWithFormat:@"%ld", (long)model.adResponseFailCount];

        return cell;

    } else {
        static NSString *cellID = @"YUMIDetailInterstitalCellVideo";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YumiLocalStatisticsCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        UITextField *tf1 = (UITextField *)[cell.contentView viewWithTag:110];
        UITextField *tf2 = (UITextField *)[cell.contentView viewWithTag:111];
        UITextField *tf3 = (UITextField *)[cell.contentView viewWithTag:112];
        UITextField *tf4 = (UITextField *)[cell.contentView viewWithTag:113];
        UITextField *tf5 = (UITextField *)[cell.contentView viewWithTag:114];
        UITextField *tf6 = (UITextField *)[cell.contentView viewWithTag:115];
        UITextField *tf7 = (UITextField *)[cell.contentView viewWithTag:116];

        NSString *adKey = self.ads.allKeys[indexPath.section];
        YumiLocalStatistics *model = self.ads[adKey];

        tf1.text = [NSString stringWithFormat:@"%ld", (long)model.adRequestCount];
        tf2.text = [NSString stringWithFormat:@"%ld", (long)(model.adResponseSuccessCount + model.adResponseFailCount)];
        tf3.text = [NSString stringWithFormat:@"%ld", (long)model.adStartCount];
        tf4.text = [NSString stringWithFormat:@"%ld", (long)model.adEndCount];
        tf5.text = [NSString stringWithFormat:@"%ld", (long)model.adRewardCount];
        tf6.text = [NSString stringWithFormat:@"%ld", (long)model.adResponseSuccessCount];
        tf7.text = [NSString stringWithFormat:@"%ld", (long)model.adResponseFailCount];

        return cell;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
