//
//  YUMIStatisticDetailTableViewController.m
//  YUMIVideoSample
//
//  Created by wxl on 15/10/12.
//  Copyright (c) 2015年 AdsYuMI. All rights reserved.
//

#import "YUMIStatisticDetailTableViewController.h"
#import "YUMIAdStatisticModel.h"

@interface YUMIStatisticDetailTableViewController ()
{
    YUMIAdStatisticModel* adModel;
}
@property (nonatomic, strong) NSArray * adArray;

@end

@implementation YUMIStatisticDetailTableViewController

static YUMIStatisticDetailTableViewController * statistic;
+(YUMIStatisticDetailTableViewController*)shareViewController{
  if (!statistic) {
    statistic=[[YUMIStatisticDetailTableViewController alloc] initWithNibName:@"YUMIStatisticTableViewController" bundle:nil];
  }
  return  statistic;
}

+(void)load{
  statistic = [YUMIStatisticDetailTableViewController shareViewController];
  [statistic addObserver];
}


-(void)viewWillAppear:(BOOL)animated{
  if (self.tableView) {
    [self.tableView reloadData];
  }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(0, 0, 60, 30)];
    [back setTitle:@"Back" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    back.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = left;
  
    self.adArray =[[YUMIAdStatisticModelManager shareStatisticModelManager]getStatisticArray:self.adType];
}

- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestObserver:) name:@"YUMIRequestCount"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseSuccessObserver:)
                                                 name:@"YUMIResponseSuccessCount"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseFailObserver:)
                                                 name:@"YUMIResponseFailCount"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exposureObserver:) name:@"YUMIexposureCount"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(opportObserver:) name:@"YUMIopportCount"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickObserver:) name:@"YUMIClickCount"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rewardObserver:) name:@"YUMIRewardCount"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshObserver) name:@"YUMIRefresh"object:nil];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - NoticationCenter
- (void)requestObserver:(NSNotification *)nf {
  id obj = [nf userInfo];//获取到传递的对象
  NSString * adName = obj[@"name"];
  NSString * adType = obj[@"adType"];
  adName = adName==nil?@"NilName":[adName lowercaseString];
  adType = adType==nil?@"NilAdType":[adType lowercaseString];
  adModel= [[YUMIAdStatisticModel alloc] init];
  adModel.YUMIAdName = adName;
  adModel.YUMIAdType = adType;
  adModel.YUMIRequestCount = 1;
  [[YUMIAdStatisticModelManager shareStatisticModelManager]setStatisticDic:adModel];
}

- (void)responseSuccessObserver:(NSNotification *)nf {
  id obj = [nf userInfo];//获取到传递的对象
  NSString * adName = obj[@"name"];
  NSString * adType = obj[@"adType"];
  adName = adName==nil?@"NilName":[adName lowercaseString];
  adType = adType==nil?@"NilAdType":[adType lowercaseString];
  adModel= [[YUMIAdStatisticModel alloc] init];
  adModel.YUMIAdName = adName;
  adModel.YUMIAdType = adType;
  adModel.YUMIResponseSuccessCount = 1;
  [[YUMIAdStatisticModelManager shareStatisticModelManager]setStatisticDic:adModel];
}

- (void)responseFailObserver:(NSNotification *)nf {
  id obj = [nf userInfo];//获取到传递的对象
  NSString * adName = obj[@"name"];
  NSString * adType = obj[@"adType"];
  adName = adName==nil?@"NilName":[adName lowercaseString];
  adType = adType==nil?@"NilAdType":[adType lowercaseString];
  adModel= [[YUMIAdStatisticModel alloc] init];
  adModel.YUMIAdName = adName;
  adModel.YUMIAdType = adType;
  adModel.YUMIResponseFailCount = 1;
  [[YUMIAdStatisticModelManager shareStatisticModelManager]setStatisticDic:adModel];
}

- (void)exposureObserver:(NSNotification *)nf {
  id obj = [nf userInfo];//获取到传递的对象
  NSString * adName = obj[@"name"];
  NSString * adType = obj[@"adType"];
  adName = adName==nil?@"NilName":[adName lowercaseString];
  adType = adType==nil?@"NilAdType":[adType lowercaseString];
  adModel= [[YUMIAdStatisticModel alloc] init];
  adModel.YUMIAdName = adName;
  adModel.YUMIAdType = adType;
  adModel.YUMIexposureCount = 1;
  [[YUMIAdStatisticModelManager shareStatisticModelManager]setStatisticDic:adModel];
}

- (void)opportObserver:(NSNotification *)nf {
  id obj = [nf userInfo];//获取到传递的对象
  NSString * adName = obj[@"name"];
  NSString * adType = obj[@"adType"];
  adName = adName==nil?@"NilName":[adName lowercaseString];
  adType = adType==nil?@"NilAdType":[adType lowercaseString];
  adModel= [[YUMIAdStatisticModel alloc] init];
  adModel.YUMIAdName = adName;
  adModel.YUMIAdType = adType;
  adModel.YUMIopportCount = 1;
  [[YUMIAdStatisticModelManager shareStatisticModelManager]setStatisticDic:adModel];
}

- (void)clickObserver:(NSNotification *)nf {
  id obj = [nf userInfo];//获取到传递的对象
  NSString * adName = obj[@"name"];
  NSString * adType = obj[@"adType"];
  adName = adName==nil?@"NilName":[adName lowercaseString];
  adType = adType==nil?@"NilAdType":[adType lowercaseString];
  adModel= [[YUMIAdStatisticModel alloc] init];
  adModel.YUMIAdName = adName;
  adModel.YUMIAdType = adType;
  adModel.YUMIClickCount = 1;
  [[YUMIAdStatisticModelManager shareStatisticModelManager]setStatisticDic:adModel];
}

- (void)rewardObserver:(NSNotification *)nf {
  id obj = [nf userInfo];//获取到传递的对象
  NSString * adName = obj[@"name"];
  NSString * adType = obj[@"adType"];
  adName = adName==nil?@"NilName":[adName lowercaseString];
  adType = adType==nil?@"NilAdType":[adType lowercaseString];
  adModel= [[YUMIAdStatisticModel alloc] init];
  adModel.YUMIAdName = adName;
  adModel.YUMIAdType = adType;
  adModel.YUMIRewardCount = 1;
  [[YUMIAdStatisticModelManager shareStatisticModelManager]setStatisticDic:adModel];
}

- (void)refreshObserver {
  self.adArray =[[YUMIAdStatisticModelManager shareStatisticModelManager]getStatisticArray:self.adType];
  [self performSelectorOnMainThread:@selector(refreshObserver_table) withObject:nil waitUntilDone:YES];
}


-(void)refreshObserver_table{  
    if (self.tableView) {
        [self.tableView reloadData];
    }
}


#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectZero];
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 28.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 28)];
    bgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel * show = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, bgView.bounds.size.width, 28)];
    show.font = [UIFont systemFontOfSize:15];
    
    show.text = self.adArray[section];

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
    return self.adArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.adType isEqualToString:@"2"]) {
        
        static NSString * cellID = @"YUMIDetailBannerCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YUMIStatisticCell" owner:self options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UITextField * tf1 = (UITextField *)[cell.contentView viewWithTag:90];
        UITextField * tf2 = (UITextField *)[cell.contentView viewWithTag:91];
        UITextField * tf3 = (UITextField *)[cell.contentView viewWithTag:92];
        UITextField * tf4 = (UITextField *)[cell.contentView viewWithTag:93];
        UITextField * tf5 = (UITextField *)[cell.contentView viewWithTag:94];
        UITextField * tf6 = (UITextField *)[cell.contentView viewWithTag:95];

    
       YUMIAdStatisticModel * model =[[YUMIAdStatisticModelManager shareStatisticModelManager] getStatisticDic:self.adArray[indexPath.section] YUMIAdType:@"2"];
        
        tf1.text = [NSString stringWithFormat:@"%ld",(long)model.YUMIRequestCount];
        tf2.text = [NSString stringWithFormat:@"%ld",(long)(model.YUMIResponseSuccessCount+model.YUMIResponseFailCount)];
        tf3.text = [NSString stringWithFormat:@"%ld",(long)model.YUMIexposureCount];
        tf4.text = [NSString stringWithFormat:@"%ld",(long)model.YUMIClickCount];
        tf5.text = [NSString stringWithFormat:@"%ld",(long)model.YUMIResponseSuccessCount];
        tf6.text = [NSString stringWithFormat:@"%ld",(long)model.YUMIResponseFailCount];

        return cell;
        
    }else if ([self.adType isEqualToString:@"3"]) {
        
        static NSString * cellID = @"YUMIDetailInterstitalCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YUMIStatisticCell" owner:self options:nil] objectAtIndex:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UITextField * tf1 = (UITextField *)[cell.contentView viewWithTag:100];
        UITextField * tf2 = (UITextField *)[cell.contentView viewWithTag:101];
        UITextField * tf3 = (UITextField *)[cell.contentView viewWithTag:102];
        UITextField * tf4 = (UITextField *)[cell.contentView viewWithTag:103];
        UITextField * tf5 = (UITextField *)[cell.contentView viewWithTag:104];
        UITextField * tf6 = (UITextField *)[cell.contentView viewWithTag:105];
        UITextField * tf7 = (UITextField *)[cell.contentView viewWithTag:106];

        
        YUMIAdStatisticModel * model =[[YUMIAdStatisticModelManager shareStatisticModelManager] getStatisticDic:self.adArray[indexPath.section] YUMIAdType:@"3"];
        tf1.text = [NSString stringWithFormat:@"%ld",(long)model.YUMIRequestCount];
        tf2.text = [NSString stringWithFormat:@"%ld",(long)(model.YUMIResponseSuccessCount+model.YUMIResponseFailCount)];
        tf3.text = [NSString stringWithFormat:@"%ld",(long)model.YUMIopportCount];
        tf4.text = [NSString stringWithFormat:@"%ld",(long)model.YUMIexposureCount];
        tf5.text = [NSString stringWithFormat:@"%ld",(long)model.YUMIClickCount];
        tf6.text = [NSString stringWithFormat:@"%ld",(long)model.YUMIResponseSuccessCount];
        tf7.text = [NSString stringWithFormat:@"%ld",(long)model.YUMIResponseFailCount];

        return cell;
        
    }else {
        
        static NSString * cellID = @"YUMIDetailVideoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YUMIStatisticCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UITextField * tf1 = (UITextField *)[cell.contentView viewWithTag:110];
        UITextField * tf2 = (UITextField *)[cell.contentView viewWithTag:111];
        UITextField * tf3 = (UITextField *)[cell.contentView viewWithTag:112];
        UITextField * tf4 = (UITextField *)[cell.contentView viewWithTag:113];
        UITextField * tf5 = (UITextField *)[cell.contentView viewWithTag:114];
        UITextField * tf6 = (UITextField *)[cell.contentView viewWithTag:115];
        UITextField * tf7 = (UITextField *)[cell.contentView viewWithTag:116];

        YUMIAdStatisticModel * model =[[YUMIAdStatisticModelManager shareStatisticModelManager] getStatisticDic:self.adArray[indexPath.section] YUMIAdType:@"5"];
        tf1.text = [NSString stringWithFormat:@"%ld",(long)model.YUMIRequestCount];
        tf2.text = [NSString stringWithFormat:@"%ld",(long)(model.YUMIResponseSuccessCount+model.YUMIResponseFailCount)];
        tf3.text = [NSString stringWithFormat:@"%ld",(long)model.YUMIexposureCount];
        tf4.text = [NSString stringWithFormat:@"%ld",(long)model.YUMIRewardCount];
        tf5.text = [NSString stringWithFormat:@"%ld",(long)model.YUMIClickCount];
        tf6.text = [NSString stringWithFormat:@"%ld",(long)model.YUMIResponseSuccessCount];
        tf7.text = [NSString stringWithFormat:@"%ld",(long)model.YUMIResponseFailCount];

        
        return cell;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
