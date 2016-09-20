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
//#import "FCXRefreshFooterView.h"
//#import "FCXRefreshHeaderView.h"
//#import "UIScrollView+FCXRefresh.h"
#import "LocationViewController.h"
#import "MenuScrollView.h"
#import "SearchViewController.h"
#import "WJRefresh.h"
#import "ImageMenuScrollView.h"
#import "UserInfoSingleton.h"
#import "SecondhandDetailVC.h"
#import "BookMainPageVC.h"
#import "SecondCateDisplayVC.h"

static NSString *IDD = @"AA";
static NSString *IDD_MENU = @"BB";
static NSInteger margin = 10;

@interface SecondhandViewController () <UITableViewDelegate, UITableViewDataSource, SecondhandBLDelegate, SecondhandCategoryDelegate, ChooseLocationDelegate, SearchProductDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *frameArray;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, weak) UITableView *tab;

@property (nonatomic, strong) SecondhandBL *bl;

@property (nonatomic, strong) NSMutableArray *labelArray;

@property (nonatomic, strong) UIScrollView *menu;

//@property (nonatomic, strong) FCXRefreshHeaderView *headerView;

//@property (nonatomic, strong) FCXRefreshFooterView *footerView;

@property (nonatomic, strong) SecondhandTitleView *titleView;
// 菜单
@property (nonatomic, strong) ImageMenuScrollView *imageMenuScrollView;
// 当上推隐藏菜单图标时，弹出这个view
@property (nonatomic, strong) MenuScrollView *menuScrollView;
// 刷新view
@property (nonatomic, strong) WJRefresh *refresh;
// 当前选中的商品分类
@property (nonatomic, assign) NSInteger currentCategory;
// 当前选中的学校
@property (nonatomic, strong) NSString *currentSchool;
// activityIndicator
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation SecondhandViewController



-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}

//暂时没有找到你在哪个位置隐藏了导航栏，在此处添加导航栏显示 2016-04-10 18：54 by houym
#pragma 添加导航栏显示
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    
    // 添加刷新
    __weak SecondhandViewController *weakSelf = self;
    self.refresh = [[WJRefresh alloc] init];
    [self.refresh addHeardRefreshTo:self.mainScrollView heardBlock:^{
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

#pragma 添加导航栏显示end 当前VC退出后隐藏导航栏

-(void)setup
{
    // 自己调整
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.title = @"二手商品";
    //self.autoLoadMore = YES;
    
    // 设置navigationItem
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    CGFloat navigationBarH = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    CGFloat titleViewW = winSize.width * 0.6f;
    CGFloat titleViewH = navigationBarH * 0.6f;
    SecondhandTitleView *secondhandTitleView = [[SecondhandTitleView alloc] initWithFrame:CGRectMake(0, 0, titleViewW, titleViewH)];   // 10.0f是图标和标签之间的间隔
    [secondhandTitleView addTarget:self action:@selector(chooseLocation) forControlEvents:UIControlEventTouchUpInside];
    UINavigationItem *navItem = self.navigationItem;
    navItem.titleView = secondhandTitleView;
    secondhandTitleView.locationName = @"全部大学";
    self.titleView = secondhandTitleView;
    
    
    // 搜索button
    UIBarButtonItem *searchBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchSecondhand)];
    navItem.rightBarButtonItem = searchBarBtn;
    
    // 设置mainScroll
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navigationBarH+statusBarH, winSize.width, winSize.height - navigationBarH - statusBarH)];
    mainScrollView.contentSize = CGSizeMake(0, winSize.height+100);
    mainScrollView.backgroundColor = grayColorPCH;
    mainScrollView.delegate = self;
    self.mainScrollView = mainScrollView;
    [self.view addSubview:self.mainScrollView];
    
    // 创建菜单
//    CGFloat categoryW = winSize.width/5.0f;
//    CGFloat categoryH = categoryW * 1.5f;
//    CGFloat menuX = 0;
//    CGFloat menuY = 0;
//    CGFloat menuW = winSize.width;
//    CGFloat menuH = categoryH;
//    ImageMenuScrollView *imageMenuScrollView = [[ImageMenuScrollView alloc] initWithFrame:CGRectMake(menuX, menuY, menuW, menuH)];
//    imageMenuScrollView.delegate = self;
//    self.imageMenuScrollView = imageMenuScrollView;
//    [self.mainScrollView addSubview:self.imageMenuScrollView];
    
    
    // 创建tableview
//    CGRect newBounds = CGRectMake(0, CGRectGetMaxY(self.imageMenuScrollView.frame) + margin, screenWidthPCH, screenHeightPCH - navigationBarH - statusBarH);
    CGRect newBounds = CGRectMake(0, 0, screenWidthPCH, screenHeightPCH - navigationBarH - statusBarH);
    UITableView *vi = [[UITableView alloc] initWithFrame:newBounds style:UITableViewStylePlain];
    vi.delegate = self;
    vi.dataSource = self;
    vi.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    vi.showsVerticalScrollIndicator = NO;
    vi.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainScrollView addSubview:vi];
    [vi registerClass:[SecondhandCell class] forCellReuseIdentifier:IDD];
    //[vi registerClass:[MenuCell class] forCellReuseIdentifier:IDD_MENU];
    self.tab = vi;
    
    // 创建BL
    self.bl = [SecondhandBL new];
    self.bl.delegate = self;
    [self.bl resetOffset];
    [self.dataArray removeAllObjects];
    [self.frameArray removeAllObjects];
    //[self.bl findAllSecondhand];
    [self.bl findSecondhand:nil];
    [self.activityIndicatorView startAnimating];
    self.currentCategory = 0;    // 0为所有商品
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
                        btn.labelS0.text = @"鞋包";
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
                        btn.labelS0.text = @"自行车";
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
    NSMutableDictionary *filter = [[NSMutableDictionary alloc] init];
    NSArray *cate = SecondhandCategoryDisplay;
    NSString *category = cate[sender.tag];
    if(sender.tag == 1){
        BookMainPageVC *bookMain = [[BookMainPageVC alloc] init];
        [self.navigationController pushViewController:bookMain animated:NO];
    }else{
        [filter setObject:category forKey:@"main_category"];
        SecondCateDisplayVC *secCateVC = [[SecondCateDisplayVC alloc] init];
        self.delegate = secCateVC;
        [self.delegate passValueForVC:filter];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:secCateVC animated:NO];
        self.hidesBottomBarWhenPushed = NO;
    }
}
/*
 - (void)labelClick:(UITapGestureRecognizer *)recognizer
 {
 for (UIView *view in self.labelArray) {
 view.backgroundColor = [UIColor whiteColor];
 }
 recognizer.view.backgroundColor = [UIColor yellowColor];
 }
 */

/*
 - (void)dealloc
 {
 [self.imageMenuScrollView removeObserver:self forKeyPath:@"contentOffset"];
 }
 */

#pragma mark ------------------- action --------------------

-(void)chooseLocation
{
    LocationViewController *dropDown = [[LocationViewController alloc] initWithFrame:[UIScreen mainScreen].bounds];
    dropDown.delegate = self;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dropDown animated:YES];
}

// 根据商品分类查询时的下拉刷新
- (void)loadNewDataAction
{
    __weak SecondhandViewController *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.currentCategory == 0) {
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
            NSArray *temp = SecondhandCategoryDisplay;
            NSString *category = temp[self.currentCategory];
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
    __weak SecondhandViewController *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.currentCategory == 0) {
            //[weakSelf.bl findAllSecondhand];
            //[weakSelf.bl findSecondhand:nil];
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
            NSArray *temp = SecondhandCategoryDisplay;
            NSString *category = temp[self.currentCategory];
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

- (void)searchSecondhand
{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.navigationController.navigationBarHidden = NO;
    searchVC.delegate = self;
    searchVC.bl = [SecondhandBL new];
    searchVC.bl.delegate = searchVC;
    searchVC.currentCategory = self.currentCategory;
    searchVC.currentSchool = self.currentSchool;
    [self.navigationController pushViewController:searchVC animated:NO];
}

#pragma mark ------------------- ScrollViewDelegate ---------------------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"%f", scrollView.contentOffset.y);
    
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    CGFloat categoryW = winSize.width/5.0f;
    CGFloat offset = winSize.width / 5.0f;
    
    CGFloat navigationBarH = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    if (scrollView.contentOffset.y > offset) {
        if (!self.menuScrollView) {
            MenuScrollView *menuScrollView = [[MenuScrollView alloc] initWithFrame:CGRectMake(0, navigationBarH+statusBarH, winSize.width, categoryW * 0.5f)];
            menuScrollView.delegate = self;
            self.menuScrollView = menuScrollView;
            // 保证当前的菜单选项
            self.menuScrollView.currentCategory = self.currentCategory;
            [self.view addSubview:self.menuScrollView];
        } else {
            self.menuScrollView.hidden = NO;
        }
    } else {
        if (self.menuScrollView) {
            self.menuScrollView.hidden = YES;
        }
    }
}

#pragma mark ------------- SearchProductDelegate ----------------

-(void)getSearchResult:(NSMutableArray *)list
{
    self.dataArray = list;
    self.frameArray = [SecondhandFrameModel frameModelWithArray:self.dataArray];
    
    [self.tab reloadData];
}

#pragma mark --------------------tableViewDelegate--------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return 2;
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 204.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        CGRect S0Frame = CGRectMake(0, 0, screenWidthPCH, 204);
        [self drawSection0:S0Frame];
        return self.viewS0;
    }
    return nil;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if(section == 0){
//        return 10.0f;
//    }
//    return 10;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if(section == 0){
//        UIView *viewS0Footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidthPCH, 10.0f)];
//        viewS0Footer.backgroundColor = [UIColor lightGrayColor];
//        return viewS0Footer;
//    }
//    return nil;
//}
/*
 - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
 {
 if (section == 0) {
 return 10;
 } else {
 return 0;
 }
 }
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondhandCell *cell = [tableView dequeueReusableCellWithIdentifier:IDD];
    //MenuCell *menuCell = [tableView dequeueReusableCellWithIdentifier:IDD_MENU];
    
    /*
     if (indexPath.section == 0) {
     menuCell.delegate = self;
     menuCell.currentCategory = self.currentCategory;
     return menuCell;
     return nil;
     } else {
     cell.model = [_dataArray objectAtIndex:indexPath.row];
     cell.frameModel = [_frameArray objectAtIndex:indexPath.row];
     return cell;
     }
     */
    
    cell.model = [_dataArray objectAtIndex:indexPath.row];
    cell.frameModel = [_frameArray objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
     if (section == 0) {
     return 1;
     } else {
     // 根据tableView的高度来设置mainScroll的frame高度
     // 10是菜单栏和tableView的间隔，244是一个cell的高度
     CGFloat height = self.imageMenuScrollView.frame.size.height + 10 + 244 * self.dataArray.count;
     self.mainScrollView.contentSize = CGSizeMake(0, height);
     
     return self.dataArray.count;
     }
     */
    
    // 根据tableView的高度来设置mainScroll的frame高度
    // 10是菜单栏和tableView的间隔，244是一个cell的高
    
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
    
    /*
     SecondhandDetailViewController *detail = [[SecondhandDetailViewController alloc] init];
     detail.model = model;
     self.hidesBottomBarWhenPushed = YES;
     [self.navigationController pushViewController:detail animated:YES];
     self.hidesBottomBarWhenPushed = NO;
     */
    
    SecondhandDetailVC *detail = [[SecondhandDetailVC alloc] init];
    detail.model = model;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    
    [self.tab reloadData];
    
    //[self.footerView endRefresh];
    // 更新mainScroll的frame的高度
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    CGFloat height = self.imageMenuScrollView.frame.size.height + margin + self.tab.contentSize.height;
    self.mainScrollView.contentSize = CGSizeMake(0, height);
    
    CGPoint tabOrgin = self.tab.frame.origin;
    CGFloat tabHeight = self.tab.contentSize.height;
    self.tab.frame = CGRectMake(tabOrgin.x, tabOrgin.y, winSize.width, tabHeight);
    
    // 结束刷新
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
        [self.tab reloadData];
    }
    
    //[self.headerView endRefresh];
    // 更新mainScroll的frame的高度
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    CGFloat height = self.imageMenuScrollView.frame.size.height + margin + self.tab.contentSize.height;
    self.mainScrollView.contentSize = CGSizeMake(0, height);
    
    // 更新tableView的frame
    CGPoint tabOrgin = self.tab.frame.origin;
    CGFloat tabHeight = self.tab.contentSize.height;
    self.tab.frame = CGRectMake(tabOrgin.x, tabOrgin.y, winSize.width, tabHeight);
    
    // 结束刷新
    [self.refresh endRefresh];
}


#pragma mark --------------------SecondhandCategoryDelegate----------------

// 当用户点击菜单标签时，更新tableview数据
- (void)chooseCategory:(NSInteger)category
{
    NSLog(@"用户选择了 %ld 类二手产品", category);
    self.currentCategory = category;
    [self.dataArray removeAllObjects];
    [self.frameArray removeAllObjects];
    [self.bl resetOffset];
    
    // 统一设置选中的菜单
    self.menuScrollView.currentCategory = category;
    self.imageMenuScrollView.currentCategory = category;
    
    if (category == 0) {
        NSMutableDictionary *filterDic = [[NSMutableDictionary alloc] init];
        
        if (self.currentSchool) {
            NSMutableArray *schoolArray = [[NSMutableArray alloc] init];
            [schoolArray addObject:self.currentSchool];
            [filterDic setObject:schoolArray forKey:@"school"];
        }
        
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
        
        [self.bl findSecondhand:filterDic];
    }
    
    [self.activityIndicatorView startAnimating];
}

#pragma mark -------------------ChooseLocationDelegate--------------------

// 选择地址后更新标题中的内容
-(void)chooseLocation:(NSString *)locationStr
{
    self.titleView.locationName = locationStr;
    self.currentSchool = locationStr;
    [self.bl resetOffset];
    [self.dataArray removeAllObjects];
    [self.frameArray removeAllObjects];
    //[self.bl searchBySchool:locationStr];
    if (self.currentCategory == 0) {
        NSMutableDictionary *filterDic = [[NSMutableDictionary alloc] init];
        NSMutableArray *schoolArray = [[NSMutableArray alloc] init];
        [schoolArray addObject:self.currentSchool];
        // 设置学校过滤
        [filterDic setObject:schoolArray forKey:@"school"];
        [self.bl findSecondhand:filterDic];
    } else {
        NSMutableDictionary *filterDic = [[NSMutableDictionary alloc] init];
        
        // 设置商品类别
        NSArray *temp = SecondhandCategoryDisplay;
        NSString *category = temp[self.currentCategory];
        [filterDic setObject:category forKey:@"main_category"];
        
        // 设置学校
        NSMutableArray *schoolArray = [[NSMutableArray alloc] init];
        [schoolArray addObject:self.currentSchool];
        [filterDic setObject:schoolArray forKey:@"school"];
        
        [self.bl findSecondhand:filterDic];
    }
    
    [self.activityIndicatorView startAnimating];
}

#pragma mark --------------------Initialize------------------------------

- (NSMutableArray *)labelArray
{
    if (!_labelArray) {
        _labelArray = [[NSMutableArray alloc] init];
    }
    return _labelArray;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    return _dataArray;
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

@end
