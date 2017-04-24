//
//  YuMIDebugIntegratedTableViewController.m
//  AdsYUMISample
//
//  Created by weixiaolei on 16/11/17.
//  Copyright © 2016年 AdsYuMI. All rights reserved.
//

#import "YuMIDebugIntegratedTableViewController.h"
#import "YuMIToolDevice.h"
#import "YuMIDebugCenter.h"
#import "YuMIDebugDetailViewController.h"

@interface YuMIDebugIntegratedTableViewController ()

@property (nonatomic, strong) NSMutableDictionary *singleDict;
@property (nonatomic, strong) NSMutableArray *providerIDArray;
@property (nonatomic, strong) NSMutableArray *adArray;

@end

@implementation YuMIDebugIntegratedTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.title = @"AdPlatform";
  self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
  
  self.singleDict  = [[NSMutableDictionary alloc]init];
  self.providerIDArray = [[NSMutableArray alloc] init];
  self.adArray  = [[NSMutableArray alloc]init];
  
  UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
  [btn setFrame:CGRectMake(0, 10, 50, 27)];
  [btn setTitle:@"<back" forState:UIControlStateNormal];
  [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
  [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
  [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
  self.navigationItem.leftBarButtonItem = left;
  
  UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [rbtn setFrame:CGRectMake(0, 10, 50, 27)];
  [rbtn setTitle:@"refresh" forState:UIControlStateNormal];
  [rbtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
  [rbtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
  [rbtn addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rbtn];
  self.navigationItem.rightBarButtonItem = right;
  
  [self getProviderIDArrayBy:self.resultDictionary];
  
}

- (void)backAction {
  [self dismissViewControllerAnimated:YES completion:^{
    
  }];
}

- (void)refreshAction {
  NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
  NSDictionary *dic = [[YuMIDebugCenter shareInstance] getPathDictionary];
  NSArray *arr = dic.allKeys;
  for (int i=0; i<arr.count; i++) {
    //获取路径
    NSString *path = dic[arr[i]];
    //获取广告类型
    NSString *adtype = [[arr[i] componentsSeparatedByString:@"_"] lastObject];
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
        [resultDic setObject:old_dic forKey:pro_key];
      }
    }
  }
  //生成平台名列表
  [self getProviderIDArrayBy:resultDic];
  [self.tableView reloadData];
}

//处理传过来的数组，整理成一个只含广告平台ID的数组
- (void)getProviderIDArrayBy:(NSMutableDictionary *)resultDic {
  for (NSString *key in resultDic.allKeys) {
    NSString *providerID = [[key componentsSeparatedByString:@"_"] firstObject];
    if (![self.providerIDArray containsObject:providerID]) {
      [self.providerIDArray addObject:providerID];
    }
  }
}

//筛选同一个平台的不同广告类型
- (void)selectAdButton:(NSString *)providerID  {
  [self.adArray removeAllObjects];
  
  for (NSString *key in self.resultDictionary.allKeys) {
    //平台名称
    NSString *proID = [[key componentsSeparatedByString:@"_"] firstObject];
    if ([providerID isEqualToString:proID]) {
      [self.adArray addObject:self.resultDictionary[key]];
    }
  }
}

//选出同一个平台不同类型的广告显示是否正常
- (void)selectAppointAdPlatform:(NSString *)providerID {
  [self.singleDict removeAllObjects];
  
  for (NSString *key in self.valuableDict.allKeys) {
    //平台名称
    NSString *proID = [[key componentsSeparatedByString:@"_"] firstObject];
    //平台类型
    NSString *adtype = [[key componentsSeparatedByString:@"_"] lastObject];
    if ([providerID isEqualToString:proID]) {
      [self.singleDict setObject:self.valuableDict[key] forKey:adtype];
    }
  }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.providerIDArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *integratedID = @"integratedID";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:integratedID];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:integratedID];
  }
  cell.textLabel.font = [UIFont systemFontOfSize:14];
  cell.textLabel.text = [[YuMIToolDevice shareToolDevice] getProviderNameById:self.providerIDArray[indexPath.row]];
  return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  //根据当前平台ID，筛选出这个平台的所有类型和是否可以展示
  [self selectAppointAdPlatform:self.providerIDArray[indexPath.row]];
  //这个界面的button按钮的显示和当前传过的array显示有关
  [self selectAdButton:self.providerIDArray[indexPath.row]];
  
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  
  YuMIDebugDetailViewController *detail = [[YuMIDebugDetailViewController alloc] init];
  detail.providerName = cell.textLabel.text;
  detail.singleDict = self.singleDict;
  detail.adArray = self.adArray;
  detail.delegate=self;
  [self.navigationController pushViewController:detail animated:YES];
}

- (void)dealloc {
  _resultDictionary = nil;
  _valuableDict = nil;
  _providerIDArray = nil;
  _singleDict = nil;
  _adArray = nil;
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
