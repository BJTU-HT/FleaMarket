//
//  SearchViewController.m
//  FleaMarket
//
//  Created by tom555cat on 16/6/30.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
// 搜索记录tableView
@property (nonatomic, strong) UITableView *searchRecordTableView;
// 历史搜索记录数据
@property (nonatomic, strong) NSMutableArray *recordArray;
//
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation SearchViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = grayColorPCH;
    
    // 搜索框
    [self createSearchBar];
    
    // 获取搜索记录
    [self prepareRecordData];
    
    // 创建记录tableView
    [self createTableView];
    
    // 清楚搜索记录的按钮
    [self createDeleteRecordBtn];
}

#pragma mark ---------------- private ------------------

- (void)prepareRecordData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *tempArray = [defaults arrayForKey:@"SearchRecords"];
    self.recordArray = [[NSMutableArray alloc] initWithArray:tempArray];
}

- (void)createSearchBar
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 2.0f, 44)];
    searchBar.delegate = self;
    self.searchBar = searchBar;
    UINavigationItem *navigationItem = [self navigationItem];
    navigationItem.titleView = self.searchBar;
}

- (void)createTableView
{
    UITableView *searchRecordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    searchRecordTableView.delegate = self;
    searchRecordTableView.dataSource = self;
    self.searchRecordTableView = searchRecordTableView;
    [self.view addSubview:self.searchRecordTableView];
}

- (void)createDeleteRecordBtn
{
    UIButton *deleteSearchRecordBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];    // 设置段落样式
    deleteSearchRecordBtn.backgroundColor = [UIColor lightGrayColor];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *btnAttributeString = [[NSMutableAttributedString alloc]    initWithString:@"删除搜索记录"
                      attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                   NSFontAttributeName:FontSize18,
                                   NSParagraphStyleAttributeName:paragraphStyle}];
    [deleteSearchRecordBtn setAttributedTitle:btnAttributeString forState:UIControlStateNormal];
    [deleteSearchRecordBtn addTarget:self action:@selector(deleteSearchRecords) forControlEvents:UIControlEventTouchUpInside];
    self.searchRecordTableView.tableFooterView = deleteSearchRecordBtn;
}

#pragma mark ---------------- action ------------------

- (void)deleteSearchRecords
{
    [self.recordArray removeAllObjects];
    [self.searchRecordTableView reloadData];
    
    // 保存recordArray
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.recordArray forKey:@"SearchRecords"];
}

#pragma mark ---------------- BL delegate ------------------

- (void)findSecondhandFinished:(NSMutableArray *)list
{
    NSLog(@"%ld", list.count);
    [self.activityIndicatorView stopAnimating];
    [self.delegate getSearchResult:list];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)findSecondhandFailed:(NSError *)error
{
    NSLog(@"主题过滤查询失败！");
}


- (void)searchByProductNameFinished:(NSMutableArray *)list
{
    NSLog(@"%ld", list.count);
    [self.delegate getSearchResult:list];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchByProductNameFailed
{
    NSLog(@"主题过滤查询失败！");
}

#pragma mark ---------------- UISearchBarDelegate ------------------

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *keyString = searchBar.text;
    
    if (keyString == nil) {
        return;
    }
    
    // 调用业务逻辑进行查询
    //[self.bl searchSecondhand:keyString];
    [self.bl resetOffset];
    if (self.currentCategory == 0) {
        NSMutableDictionary *filterDic = [[NSMutableDictionary alloc] init];
        
        // 设置学校过滤
        if (self.currentSchool) {
            NSMutableArray *schoolArray = [[NSMutableArray alloc] init];
            [schoolArray addObject:self.currentSchool];
            [filterDic setObject:schoolArray forKey:@"school"];
        }
        
        // 设置商品标题过滤
        [filterDic setObject:keyString forKey:@"product_name"];
        
        [self.bl findSecondhand:filterDic];
    } else {
        NSMutableDictionary *filterDic = [[NSMutableDictionary alloc] init];
        
        // 设置商品类别
        NSArray *temp = SecondhandCategoryDisplay;
        NSString *category = temp[self.currentCategory];
        [filterDic setObject:category forKey:@"main_category"];
        
        // 设置学校
        if (self.currentSchool) {
            NSMutableArray *schoolArray = [[NSMutableArray alloc] init];
            [schoolArray addObject:self.currentSchool];
            [filterDic setObject:schoolArray forKey:@"school"];
        }
        
        // 设置商品标题过滤
        [filterDic setObject:keyString forKey:@"product_name"];
        
        [self.bl findSecondhand:filterDic];
    }

    
    // 添加进记录Array
    [self.recordArray addObject:keyString];
    
    // 保存recordArray
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.recordArray forKey:@"SearchRecords"];
    
    [self.activityIndicatorView startAnimating];
}

#pragma mark ---------------- tableViewDelegate ----------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"recordcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"recordcell"];
    }
    cell.textLabel.text = self.recordArray[indexPath.item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *keyString = self.recordArray[indexPath.item];
    
    [self.activityIndicatorView startAnimating];
    
    [self.bl resetOffset];
    // 调用业务逻辑进行查询
    if (self.currentCategory == 0) {
        NSMutableDictionary *filterDic = [[NSMutableDictionary alloc] init];
        
        // 设置学校过滤
        if (self.currentSchool) {
            NSMutableArray *schoolArray = [[NSMutableArray alloc] init];
            [schoolArray addObject:self.currentSchool];
            [filterDic setObject:schoolArray forKey:@"school"];
        }
        
        // 设置商品标题过滤
        [filterDic setObject:keyString forKey:@"product_name"];
        
        [self.bl findSecondhand:filterDic];
    } else {
        NSMutableDictionary *filterDic = [[NSMutableDictionary alloc] init];
        
        // 设置商品类别
        NSArray *temp = SecondhandCategoryDisplay;
        NSString *category = temp[self.currentCategory];
        [filterDic setObject:category forKey:@"main_category"];
        
        // 设置学校
        if (self.currentSchool) {
            NSMutableArray *schoolArray = [[NSMutableArray alloc] init];
            [schoolArray addObject:self.currentSchool];
            [filterDic setObject:schoolArray forKey:@"school"];
        }
        
        // 设置商品标题过滤
        [filterDic setObject:keyString forKey:@"product_name"];
        
        [self.bl findSecondhand:filterDic];
    }
}

#pragma mark ---------------- getter & setter -------------------

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [_activityIndicatorView setBackgroundColor:[UIColor blackColor]];
        _activityIndicatorView.center = self.view.center;
        [self.view addSubview:_activityIndicatorView];
    }
    
    return _activityIndicatorView;
}

@end
