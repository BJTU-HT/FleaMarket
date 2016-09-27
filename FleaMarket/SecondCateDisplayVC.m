//
//  SecondCateDisplayVC.m
//  FleaMarket
//
//  Created by Hou on 9/19/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "SecondCateDisplayVC.h"

@interface SecondCateDisplayVC ()

@end

@implementation SecondCateDisplayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect tableViewFrame = CGRectMake(0, 64, screenWidthPCH, screenHeightPCH - 64);
    _tableViewCateDisplay = [[UITableView alloc] initWithFrame: tableViewFrame style:UITableViewStylePlain];
    _tableViewCateDisplay.delegate = self;
    _tableViewCateDisplay.dataSource = self;
    // 创建BL
    self.bl = [SecondhandBL new];
    self.bl.delegate = self;
    [self.bl resetOffset];
    [self.dataArray removeAllObjects];
    [self.frameArray removeAllObjects];
    //[self.bl findAllSecondhand];
    [self.bl findSecondhand:self.filterDic];
    [self.activityIndicatorView startAnimating];
    //self.currentCategory = 0;    // 0为所有商品
    // Do any additional setup after loading the view.
}

#pragma 添加导航栏显示
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    
    // 添加刷新
    __weak SecondCateDisplayVC *weakSelf = self;
    self.refresh = [[WJRefresh alloc] init];
    [self.refresh addHeardRefreshTo:self.tableViewCateDisplay heardBlock:^{
        [weakSelf loadNewDataAction];
    } footBlok:^{
        [weakSelf loadMoreDateAction];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [self.refresh removeFromSuperview];
    //[self.imageMenuScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

-(void)passValueForVC:(NSDictionary *)dic{
    [self.filterDic addEntriesFromDictionary:dic];
    self.title = [self.filterDic objectForKey:@"main_category"];
    if(![self.filterDic objectForKey:@"main_category"]){
        self.title = @"全部";
    }
    self.currentSchool = [dic objectForKey:@"specifySchool"];
    self.currentCate = [dic objectForKey:@"main_category"];
}

#pragma ---------------上拉刷新，下拉加载 begin ---------------------------------
// 根据商品分类查询时的下拉刷新
- (void)loadNewDataAction
{
    __weak SecondCateDisplayVC *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([weakSelf.currentCate isEqualToString:@"全部"]) {
            NSLog(@"下拉刷新");
            NSMutableDictionary *filterDic = [[NSMutableDictionary alloc] init];
            
            if (weakSelf.currentSchool) {
                NSMutableArray *schoolArray = [[NSMutableArray alloc] init];
                [schoolArray addObject:weakSelf.currentSchool];
                [filterDic setObject:schoolArray forKey:@"school"];
            }
            
            [weakSelf.bl findNewComming:filterDic];
        } else {
            // 过滤查询查询新结果
            // 。。。
            NSLog(@"根据商品分类过滤查询刷新...");
            NSMutableDictionary *filterDic = [[NSMutableDictionary alloc] init];
            
            // 设置商品类别
            //NSArray *temp = SecondhandCategoryDisplay;
            NSString *category = weakSelf.currentCate;
            [filterDic setObject:category forKey:@"main_category"];
            
            // 设置学校
            if (weakSelf.currentSchool) {
                NSMutableArray *schoolArray = [[NSMutableArray alloc] init];
                [schoolArray addObject:weakSelf.currentSchool];
                [filterDic setObject:schoolArray forKey:@"school"];
            }
            [weakSelf.bl findNewComming:filterDic];
        }
    });
}

// 上拉加载
- (void)loadMoreDateAction
{
    __weak SecondCateDisplayVC *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([weakSelf.currentCate isEqualToString:@"全部"]) {
            NSLog(@"上拉加载更多");
            NSMutableDictionary *filterDic = [[NSMutableDictionary alloc] init];
            if (weakSelf.currentSchool) {
                NSMutableArray *schoolArray = [[NSMutableArray alloc] init];
                [schoolArray addObject:weakSelf.currentSchool];
                [filterDic setObject:schoolArray forKey:@"school"];
            }
            
            [weakSelf.bl findSecondhand:filterDic];
        } else {
            // 过滤查询加载更多
            // ...
            NSLog(@"根据商品分类过滤查询加载更多...");
            NSMutableDictionary *filterDic = [[NSMutableDictionary alloc] init];
            
            // 设置商品类别
            //NSArray *temp = SecondhandCategoryDisplay;
            NSString *category = weakSelf.currentCate;
            [filterDic setObject:category forKey:@"main_category"];
            
            // 设置学校
            if (weakSelf.currentSchool) {
                NSMutableArray *schoolArray = [[NSMutableArray alloc] init];
                [schoolArray addObject:weakSelf.currentSchool];
                [filterDic setObject:schoolArray forKey:@"school"];
            }
            [weakSelf.bl findSecondhand:filterDic];
        }
    });
}

#pragma ---------------上拉刷新，下拉加载 end ---------------------------------

#pragma delegate begin
- (void)findSecondhandFinished:(NSMutableArray *)list
{
    for (long i = 0; i < list.count; i++) {
        [self.dataArray addObject:list[i]];
    }
    
    if (list.count) {
        self.frameArray = [SecondhandFrameModel frameModelWithArray:_dataArray];
    }
    
//    [self.tableViewCateDisplay reloadData];
    [self.view addSubview:_tableViewCateDisplay];
    //[self.footerView endRefresh];
    // 更新mainScroll的frame的高度
//    CGSize winSize = [UIScreen mainScreen].bounds.size;
//    CGFloat height = self.imageMenuScrollView.frame.size.height + margin + self.tab.contentSize.height;
//    self.mainScrollView.contentSize = CGSizeMake(0, height);
//    
//    CGPoint tabOrgin = self.tab.frame.origin;
//    CGFloat tabHeight = self.tab.contentSize.height;
//    self.tab.frame = CGRectMake(tabOrgin.x, tabOrgin.y, winSize.width, tabHeight);
//    
//    // 结束刷新
    [self.refresh endRefresh];
    [self.activityIndicatorView stopAnimating];
}

- (void)findSecondhandFailed:(NSError *)error
{
    NSLog(@"过滤查询失败!");
}

- (void)findNewCommingSecondhandFinished:(NSMutableArray *)list
{
    // 按时间排序从头插入
    for (long i = list.count - 1; i >= 0 ; i--) {
        [_dataArray insertObject:list[i] atIndex:0];
    }
    
    if (list.count) {
        _frameArray = [SecondhandFrameModel frameModelWithArray:_dataArray];
        [self.tableViewCateDisplay reloadData];
    }
    
    //[self.headerView endRefresh];
    // 更新mainScroll的frame的高度
    CGSize winSize = [UIScreen mainScreen].bounds.size;
//    CGFloat height = self.imageMenuScrollView.frame.size.height + margin + self.tab.contentSize.height;
//    self.mainScrollView.contentSize = CGSizeMake(0, height);
    
    // 更新tableView的frame
    CGPoint tabOrgin = self.tableViewCateDisplay.frame.origin;
    CGFloat tabHeight = self.tableViewCateDisplay.contentSize.height;
    self.tableViewCateDisplay.frame = CGRectMake(tabOrgin.x, tabOrgin.y, winSize.width, tabHeight);
    
    // 结束刷新
    [self.refresh endRefresh];
}
#pragma delegate end

#pragma ----------------tableView delegate begin---------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondhandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if(cell == nil) {
        cell = [[SecondhandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"cell1"];
    }
    cell.model = [_dataArray objectAtIndex:indexPath.row];
    cell.frameModel = [_frameArray objectAtIndex:indexPath.row];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondhandFrameModel *frameModel = self.frameArray[indexPath.row];
    return frameModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondhandVO *model = _dataArray[indexPath.row];
    
    // 为当前选中的二手商品新增1位来访者
    UserMO *userMO = [UserInfoSingleton sharedManager].userMO;
    if (userMO != nil) {
        if (![userMO.user_id isEqualToString:model.userID]) {
            // 如果不是自己发布的二手商品
            [self.bl newVisitor:userMO.head_image_url secondhand:model];
        }
    }
    SecondhandDetailVC *detail = [[SecondhandDetailVC alloc] init];
    detail.model = model;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//清除无数据的多余分割线
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidthPCH, screenHeightPCH * 0.04)];
    v.backgroundColor = grayColorPCH;
    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return grayLineHeightPCH;
}
#pragma ----------------tableView delegate end-------------------------------------

#pragma getter setter method begin
-(NSMutableDictionary *)filterDic{
    if(!_filterDic){
        _filterDic = [[NSMutableDictionary alloc] init];
    }
    return _filterDic;
}

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(NSMutableArray *)frameArray{
    if(!_frameArray){
        _frameArray = [[NSMutableArray alloc] init];
    }
    return _frameArray;
}

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
#pragma getter setter method end

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
