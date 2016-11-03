//
//  SecondhandViewController.m
//  FleaMarket
//
//  Created by tom555cat on 16/3/28.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "SecondhandViewController.h"
#import "SecondhandCell.h"
#import "SecondhandBL.h"
#import "SecondhandBLDelegate.h"
#import "SecondhandVO.h"
#import "Help.h"
#import "MenuCell.h"
#import "SecondhandTitleView.h"
#import "SecondhandDetailViewController.h"
#import "LocationViewController.h"
#import "SearchViewController.h"
#import "UserInfoSingleton.h"
#import "SecondhandDetailVC.h"
#import "BookMainPageVC.h"
#import "SecondCateDisplayVC.h"
#import "SchoolGroupModel.h"
#import "SecondhandVC.h"
#import "SchoolFilterVC.h"
#import "SecondhandFilterView.h"
#import "CategoryFilterView.h"
#import "presentLayerPublicMethod.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"

@interface SecondhandViewController () <UITableViewDelegate, UITableViewDataSource, SecondhandBLDelegate, ChooseLocationDelegate, SearchProductDelegate, UIScrollViewDelegate, SecondhandFilterDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *frameArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SecondhandBL *bl;
@property (nonatomic, strong) SecondhandTitleView *titleView;
//@property (nonatomic, strong) WJRefresh *refresh;
@property (nonatomic, strong) SchoolFilterVC *schoolFilterVC;
@property (nonatomic, assign) NSInteger schoolCategory;                          // 学校分类
@property (nonatomic, strong) NSString *currentSchool;
@property (nonatomic, strong) SecondhandTitleView *secondhandTitleView;
@property (nonatomic, strong) NSString *keyString;
@property (nonatomic, strong) MBProgressHUD *hud;
//@property (nonatomic, strong) UITableView *testScrollView;
@end

@implementation SecondhandViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNav];
    [self initViews];
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)initData
{
    self.schoolCategory = 0;
    self.currentSchool = @"全部大学";
    
    // 创建BL
    self.bl = [SecondhandBL new];
    self.bl.delegate = self;
    [self.bl resetOffset];
    [self.dataArray removeAllObjects];
    [self.frameArray removeAllObjects];
    [self.bl findSecondhand:nil];
    
    // 旋转菊花
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.hud.label.text = NSLocalizedString(@"加载中...", @"HUD loading title");
}

- (void)setNav
{
    // trick, 不加这个的话会自动下拉刷新
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidthPCH, 64)];
    [self.view addSubview:backView];
    
    // 中间选择学校标题
    CGFloat titleViewW = screenWidthPCH * 0.6f;
    CGFloat titleViewH = 44 * 0.6f;
    self.secondhandTitleView = [[SecondhandTitleView alloc] initWithFrame:CGRectMake(0, 0, titleViewW, titleViewH)];   // 10.0f是图标和标签之间的间隔
    [self.secondhandTitleView addTarget:self action:@selector(chooseLocation) forControlEvents:UIControlEventTouchUpInside];
    UINavigationItem *navItem = self.navigationItem;
    navItem.titleView = self.secondhandTitleView;
    self.secondhandTitleView.locationName = @"全部大学";
    self.titleView = self.secondhandTitleView;
    
    // 搜索button
    UIBarButtonItem *searchBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchSecondhand)];
    navItem.rightBarButtonItem = searchBarBtn;
}

-(void)initViews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidthPCH, screenHeightPCH-64-49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataAction)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDateAction)];
    [self.view addSubview:self.tableView];
}

-(void)drawSection0:(CGRect)S0Frame{
    self.viewS0 = [[UIView alloc] initWithFrame:S0Frame];
    UIView *viewLine = [[UIView alloc] init];
    viewLine.frame = CGRectMake(0, 204, screenWidthPCH, 5.0f);
    viewLine.backgroundColor = grayColorPCH;
    [self.viewS0 addSubview:viewLine];
    float btnWidth = 48;
    float btnHegiht = 72;
    float marginHorizontal = (screenWidthPCH - 4 * btnWidth - 40) / 3.0;
    float marginVertical = 20.0f;
    float tagCount = 0;
    for(int i = 0; i < 2; i++){
        for(int j = 0; j < 4; j++){
            float btn_x = j * (btnWidth + marginHorizontal) + 20;
            float btn_y = i * (btnHegiht + marginVertical) + marginVertical;
            firstPageSection0Btn *btn = [[firstPageSection0Btn alloc] initWithFrame:self.view.frame];
            btn.frame = CGRectMake(btn_x, btn_y, btnWidth, btnHegiht);
            btn.tag = tagCount++;
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
            [self.viewS0 addSubview:btn];
            switch (j) {
                case 0:
                    if(i == 0)
                    {
                        btn.labelS0.text = @"全部";
                        btn.imageViewS0.image = [UIImage imageNamed:@"2@2x.png"];
                    }
                    else
                    {
                        btn.labelS0.text = @"衣服";
                        btn.imageViewS0.image = [UIImage imageNamed:@"1@2x.png"];
                    }
                    break;
                case 1:
                    if(i == 0)
                    {
                        btn.labelS0.text = @"书籍";
                        btn.imageViewS0.image = [UIImage imageNamed:@"3@2x.png"];
                    }
                    else
                    {
                        btn.labelS0.text = @"自行车";
                        btn.imageViewS0.image = [UIImage imageNamed:@"4@2x.png"];
                    }
                    break;
                case 2:
                    if(i == 0)
                    {
                        btn.labelS0.text = @"数码";
                        btn.imageViewS0.image = [UIImage imageNamed:@"5@2x.png"];
                    }
                    else
                    {
                        btn.labelS0.text = @"运动";
                        btn.imageViewS0.image = [UIImage imageNamed:@"6@2x.png"];
                    }
                    break;
                case 3:
                    if(i == 0)
                    {
                        btn.labelS0.text = @"电脑";
                        btn.imageViewS0.image = [UIImage imageNamed:@"7@2x.png"];
                    }
                    else
                    {
                        btn.labelS0.text = @"其他";
                        btn.imageViewS0.image = [UIImage imageNamed:@"8@2x.png"];
                    }
                    break;
                default:
                    break;
            }
        }
    }
    
}

-(void)btnClicked:(UIButton *)sender{
    //NSMutableDictionary *filter = [[NSMutableDictionary alloc] init];
    //NSArray *cate = SecondhandCategoryDisplay;
    //NSString *category = cate[sender.tag];
    if(sender.tag == 1){
        BookMainPageVC *bookMain = [[BookMainPageVC alloc] init];
        [self.navigationController pushViewController:bookMain animated:NO];
    }else{
        SecondhandVC *secondhandVC = [[SecondhandVC alloc] init];
        secondhandVC.schoolCategory = self.schoolCategory;
        switch (sender.tag) {
            case 2:
                secondhandVC.viceCategory = 200;
                break;
            case 3:
                secondhandVC.viceCategory = 300;
                break;
            case 4:
                secondhandVC.viceCategory = 400;
                break;
            case 5:
                secondhandVC.viceCategory = 500;
                break;
            case 6:
                secondhandVC.viceCategory = 600;
                break;
            case 7:
                secondhandVC.viceCategory = 700;
                break;
            default:
                break;
        }
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:secondhandVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

#pragma mark ------------------- get data -------------------

- (void)searchByKey:(NSString *)keyString
{
    // 先清空当前数据
    [self.bl resetOffset];
    [self.dataArray removeAllObjects];
    [self.frameArray removeAllObjects];
    
    // 条件过滤字典
    NSMutableDictionary *filterDic = [[NSMutableDictionary alloc] init];
    
    // ********************** 学校条件过滤 *************************
    // 读取学校区域字典
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"SchoolAreaDictionary" ofType:@"plist"];
    NSMutableDictionary *schoolAreaDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    // 读取学校字典
    NSString *plistPath1 = [[NSBundle mainBundle] pathForResource:@"SchoolDictionary" ofType:@"plist"];
    NSMutableDictionary *schoolDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath1];
    if (self.schoolCategory != 0) {
        NSMutableArray *schoolArray = [[NSMutableArray alloc] initWithArray:[schoolAreaDic objectForKey:[NSString stringWithFormat:@"%ld", self.schoolCategory]]];
        if (schoolArray.count == 0) {
            [schoolArray addObject:[schoolDic objectForKey:[NSString stringWithFormat:@"%ld", self.schoolCategory]]];
        }
        
        [filterDic setObject:schoolArray forKey:@"school"];
    }
    
    // ********************* 关键字搜索过滤 ***********************
    if (keyString.length > 0) {
        [filterDic setObject:keyString forKey:@"product_name"];
    }
    
    [self.bl findSecondhand:filterDic];
}

- (void)refreshData
{
    // 先清空当前数据
    [self.bl resetOffset];
    [self.dataArray removeAllObjects];
    [self.frameArray removeAllObjects];
    
    // 条件过滤字典
    NSMutableDictionary *filterDic = [[NSMutableDictionary alloc] init];
    
    // ********************** 学校条件过滤 *************************
    // 读取学校区域字典
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"SchoolAreaDictionary" ofType:@"plist"];
    NSMutableDictionary *schoolAreaDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    // 读取学校字典
    NSString *plistPath1 = [[NSBundle mainBundle] pathForResource:@"SchoolDictionary" ofType:@"plist"];
    NSMutableDictionary *schoolDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath1];
    if (self.schoolCategory != 0) {
        NSMutableArray *schoolArray = [[NSMutableArray alloc] initWithArray:[schoolAreaDic objectForKey:[NSString stringWithFormat:@"%ld", self.schoolCategory]]];
        if (schoolArray.count == 0) {
            [schoolArray addObject:[schoolDic objectForKey:[NSString stringWithFormat:@"%ld", self.schoolCategory]]];
        }
        
        [filterDic setObject:schoolArray forKey:@"school"];
    }
    
    // ********************* 关键字搜索过滤 ***********************
    if (self.keyString.length > 0) {
        [filterDic setObject:self.keyString forKey:@"product_name"];
    }
    
    [self.bl findSecondhand:filterDic];
    
    // 旋转菊花
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    //self.hud.label.text = NSLocalizedString(@"加载中...", @"HUD loading title");
}

// 根据商品分类查询时的下拉刷新
- (void)loadNewDataAction
{
    __weak SecondhandViewController *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 条件过滤字典
        NSMutableDictionary *filterDic = [[NSMutableDictionary alloc] init];
        
        // ********************** 学校条件过滤 *************************
        // 读取学校区域字典
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"SchoolAreaDictionary" ofType:@"plist"];
        NSMutableDictionary *schoolAreaDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        // 读取学校字典
        NSString *plistPath1 = [[NSBundle mainBundle] pathForResource:@"SchoolDictionary" ofType:@"plist"];
        NSMutableDictionary *schoolDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath1];
        if (weakSelf.schoolCategory != 0) {
            NSMutableArray *schoolArray = [[NSMutableArray alloc] initWithArray:[schoolAreaDic objectForKey:[NSString stringWithFormat:@"%ld", weakSelf.schoolCategory]]];
            if (schoolArray.count == 0) {
                [schoolArray addObject:[schoolDic objectForKey:[NSString stringWithFormat:@"%ld", weakSelf.schoolCategory]]];
            }
            
            [filterDic setObject:schoolArray forKey:@"school"];
        }
        
        // ********************* 关键字搜索过滤 ***********************
        if (self.keyString.length > 0) {
            [filterDic setObject:self.keyString forKey:@"product_name"];
        }
        
        [weakSelf.bl findNewComming:filterDic];
    });
}

// 上拉加载
- (void)loadMoreDateAction
{
    __weak SecondhandViewController *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 条件过滤字典
        NSMutableDictionary *filterDic = [[NSMutableDictionary alloc] init];
        
        // ********************** 学校条件过滤 *************************
        // 读取学校区域字典
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"SchoolAreaDictionary" ofType:@"plist"];
        NSMutableDictionary *schoolAreaDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        // 读取学校字典
        NSString *plistPath1 = [[NSBundle mainBundle] pathForResource:@"SchoolDictionary" ofType:@"plist"];
        NSMutableDictionary *schoolDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath1];
        if (weakSelf.schoolCategory != 0) {
            NSMutableArray *schoolArray = [[NSMutableArray alloc] initWithArray:[schoolAreaDic objectForKey:[NSString stringWithFormat:@"%ld", weakSelf.schoolCategory]]];
            if (schoolArray.count == 0) {
                [schoolArray addObject:[schoolDic objectForKey:[NSString stringWithFormat:@"%ld", weakSelf.schoolCategory]]];
            }
            
            [filterDic setObject:schoolArray forKey:@"school"];
        }
        
        // ********************* 关键字搜索过滤 ***********************
        if (self.keyString.length > 0) {
            [filterDic setObject:self.keyString forKey:@"product_name"];
        }
        [weakSelf.bl findSecondhand:filterDic];
    });
}

#pragma mark ------------------- action --------------------

-(void)chooseLocation
{
    self.schoolFilterVC = [[SchoolFilterVC alloc] init];
    self.schoolFilterVC.hidesBottomBarWhenPushed = YES;
    //self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.schoolFilterVC animated:YES];
    //self.hidesBottomBarWhenPushed = NO;
}

- (void)searchSecondhand
{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.navigationController.navigationBarHidden = NO;
    searchVC.delegate = self;
    [self.navigationController pushViewController:searchVC animated:NO];
}

#pragma mark ------------- SearchProductDelegate ----------------

- (void)searchSecondhandByKey:(NSString *)keyString
{
    self.keyString = keyString;
    [self searchByKey:keyString];
    
    // 旋转菊花
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.hud.label.text = NSLocalizedString(@"搜索中...", @"HUD loading title");
}

#pragma mark --------------------tableViewDelegate--------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return self.dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 204.0f;
    } else {
        SecondhandFrameModel *frameModel = self.frameArray[indexPath.row];
        return frameModel.cellHeight;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    } else {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidthPCH, 10)];
    headerView.backgroundColor = lightGrayColorPCH;
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifier = @"menucell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGRect S0Frame = CGRectMake(0, 0, screenWidthPCH, 204);
        [self drawSection0:S0Frame];
        [cell.contentView addSubview:self.viewS0];
        return cell;
        
    } else {
        static NSString *identifier = @"secondhandscell";
        SecondhandCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[SecondhandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.model = [_dataArray objectAtIndex:indexPath.row];
        cell.frameModel = [_frameArray objectAtIndex:indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
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
}

#pragma mark --------------------SecondhandBLDelegate----------------------

- (void)findSecondhandFinished:(NSMutableArray *)list
{
    for (long i = 0; i < list.count; i++) {
        [_dataArray addObject:list[i]];
    }
    
    if (list.count) {
        _frameArray = [SecondhandFrameModel frameModelWithArray:_dataArray];
    }
    
    [self.tableView reloadData];
    
    if (list.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud hideAnimated:YES];
    });
}

- (void)findSecondhandFailed:(NSError *)error
{
    // 结束刷新
    //[self.refresh endRefresh];
    [self.tableView.mj_footer endRefreshing];
    [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"服务器开小差了哦"];
    /*
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"请求失败" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:ac animated:YES completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(createAlert:) userInfo:ac repeats:NO];
    */
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud hideAnimated:YES];
    });
}

- (void)findNewCommingSecondhandFinished:(NSMutableArray *)list
{
    // 按时间排序从头插入
    for (long i = list.count - 1; i >= 0 ; i--) {
        [_dataArray insertObject:list[i] atIndex:0];
    }
    
    if (list.count) {
        _frameArray = [SecondhandFrameModel frameModelWithArray:_dataArray];
        [self.tableView reloadData];
    }
    
    // 结束刷新
    //[self.refresh endRefresh];
    [self.tableView.mj_header endRefreshing];
}

- (void)findNewCommingSecondhandFailed:(NSError *)error
{
    // 结束刷新
    //[self.refresh endRefresh];
    [self.tableView.mj_header endRefreshing];
    [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"服务器开小差了哦"];
    /*
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"请求失败" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:ac animated:NO completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(createAlert:) userInfo:ac repeats:NO];
     */
}

- (void)createAlert:(NSTimer *)timer{
    UIAlertController *alert = [timer userInfo];
    [alert dismissViewControllerAnimated:YES completion:nil];
    alert = nil;
}

#pragma mark --- SecondhandFilterDelegate ---

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withId:(NSNumber *)ID withName:(NSString *)name{
    NSLog(@"ID:%@  name:%@",ID,name);
    self.schoolCategory = [ID integerValue];
    self.currentSchool = name;
    [self.navigationController popViewControllerAnimated:YES];
    
    [self refreshData];
}

#pragma mark --------------------Initialize------------------------------

- (void)setCurrentSchool:(NSString *)currentSchool
{
    _currentSchool = currentSchool;
    self.secondhandTitleView.locationName = currentSchool;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    return _dataArray;
}

- (NSMutableArray *)frameArray
{
    if (_frameArray == nil) {
        _frameArray = [[NSMutableArray alloc] init];
    }
    
    return _frameArray;
}

@end
