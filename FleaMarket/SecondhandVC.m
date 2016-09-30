//
//  SecondhandVC.m
//  FleaMarket
//
//  Created by tom555cat on 16/9/22.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "SecondhandVC.h"
#import "SecondhandFrameModel.h"
#import "SecondhandCell.h"
#import "SecondhandFilterView.h"
#import "CategoryFilterView.h"
#import "SortView.h"
#import "SecondhandBL.h"
#import "WJRefresh.h"
#import "SearchViewController.h"
#import "UserInfoSingleton.h"
#import "SecondhandDetailVC.h"
#import "presentLayerPublicMethod.h"

@interface SecondhandVC () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, SecondhandFilterDelegate, SecondhandBLDelegate, CategoryFilterDelegate, SortDelegate, UISearchBarDelegate,SearchProductDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *frameArray;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) SecondhandFilterView *groupView;
@property (nonatomic, strong) CategoryFilterView *categoryGroupView;
@property (nonatomic, strong) SortView *sortView;
@property (nonatomic, assign) NSInteger KindID;         // 分类查询ID，默认为-1
@property (nonatomic, strong) SecondhandBL *bl;         // 业务调用
@property (nonatomic, strong) WJRefresh *refresh;       // 上下拉刷新
@property (nonatomic, assign) NSInteger mainCategory;   // 物品主分类
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, weak) UIButton *currentMenuBtn;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSString *keyString;      // 当前关键字过滤字符串
@end

@implementation SecondhandVC

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.KindID = -1;
        self.schoolCategory = 0;        // 默认为全部大学
        self.mainCategory = 0;          // 默认为全部种类
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicatorView startAnimating];
    });
    
    // 添加刷新
    __weak SecondhandVC *weakSelf = self;
    self.refresh = [[WJRefresh alloc] init];
    [self.refresh addHeardRefreshTo:self.tableView heardBlock:^{
        [weakSelf loadNewDataAction];
    } footBlok:^{
        [weakSelf loadMoreDateAction];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.refresh removeFromSuperview];
    //[self.tableView removeObserver:self.refresh forKeyPath:@""];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    [self initData];
    [self setNav];
    [self initViews];
    [self initMaskView];
}

- (void)initData
{
    self.bl = [SecondhandBL new];
    self.bl.delegate = self;
    [self getFirstPageData];
}

- (void)setNav
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, screenWidthPCH/3, 44)];
    searchBar.placeholder = @"根据关键字进行查询";
    searchBar.delegate = self;
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    UINavigationItem *navigationItem = [self navigationItem];
    navigationItem.titleView = searchBar;
    self.searchBar = searchBar;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_03.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToMain:)];
}

- (void)initViews
{
    // 过滤
    UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screenWidthPCH, 40)];
    filterView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:filterView];
    
    // 读取学校字典
    NSString *plistPath1 = [[NSBundle mainBundle] pathForResource:@"SchoolDictionary" ofType:@"plist"];
    NSMutableDictionary *schoolDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath1];
    // 读取分类字典
    NSString *plistPath2 = [[NSBundle mainBundle] pathForResource:@"CategoryDictionary" ofType:@"plist"];
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath2];
    NSString *schoolStr = [schoolDic objectForKey:[NSString stringWithFormat:@"%ld", self.schoolCategory]];
    NSString *categoryStr = [categoryDic objectForKey:[NSString stringWithFormat:@"%ld", self.viceCategory]];
    NSArray *filterName = @[schoolStr,categoryStr,@"智能排序"];
    for (int i = 0; i < 3; i++) {
        // 文字
        UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        filterBtn.frame = CGRectMake(i*screenWidthPCH/3, 0, screenWidthPCH/3-15, 40);
        filterBtn.tag = 100 + i;
        //filterBtn.font = FontSize12;
        filterBtn.titleLabel.font = FontSize14;
        [filterBtn setTitle:filterName[i] forState:UIControlStateNormal];
        [filterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [filterBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
        [filterBtn addTarget:self action:@selector(OnFilterBtn:) forControlEvents:UIControlEventTouchUpInside];
        [filterView addSubview:filterBtn];
        
        // 指示三角
        UIButton *sanjiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sanjiaoBtn.frame = CGRectMake((i+1)*screenWidthPCH/3-15, 16, 10, 10);
        sanjiaoBtn.tag = 120+i;
        [sanjiaoBtn setImage:[UIImage imageNamed:@"icon_arrow_dropdown_normal"] forState:UIControlStateNormal];
        [sanjiaoBtn setImage:[UIImage imageNamed:@"icon_arrow_dropdown_selected"] forState:UIControlStateSelected];
        [filterView addSubview:sanjiaoBtn];
    }
    
    //下划线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, screenWidthPCH, 0.5)];
    lineView.backgroundColor = darkGrayColorPCH;
    [filterView addSubview:lineView];
    
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, screenWidthPCH, screenHeightPCH-64-40)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

// 遮罩页
- (void)initMaskView
{
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+40, screenWidthPCH, screenHeightPCH-64-40)];
    self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:self.maskView];
    self.maskView.hidden = YES;
    
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapMaskView:)];
    tap.delegate = self;
    [self.maskView addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- action ---

- (void)backToMain:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)OnFilterBtn:(UIButton *)sender
{
    for (int i = 0; i < 3; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:100+i];
        UIButton *sanjiaoBtn = (UIButton *)[self.view viewWithTag:120+i];
        btn.selected = NO;
        sanjiaoBtn.selected = NO;
    }
    sender.selected = YES;;
    UIButton *sjBtn = (UIButton *)[self.view viewWithTag:sender.tag+20];
    sjBtn.selected = YES;
    self.maskView.hidden = NO;
    
    self.currentMenuBtn = sender;
    
    // 将三个置为空，避免sortView无法遮蔽前面的view
    [self.groupView removeFromSuperview];
    [self.categoryGroupView removeFromSuperview];
    [self.sortView removeFromSuperview];
    
    if (sender.tag == 100) {
        self.groupView = [[SecondhandFilterView alloc] initWithFrame:CGRectMake(0, 0, screenWidthPCH, self.maskView.frame.size.height-90)];
        self.groupView.delegate = self;
        [self.maskView addSubview:self.groupView];
    } else if (sender.tag == 101){
        self.categoryGroupView = [[CategoryFilterView alloc] initWithFrame:CGRectMake(0, 0, screenWidthPCH, self.maskView.frame.size.height-90)];
        self.categoryGroupView.delegate = self;
        [self.maskView addSubview:self.categoryGroupView];
    } else if (sender.tag == 102){
        self.sortView = [[SortView alloc] initWithFrame:CGRectMake(0, 0, screenWidthPCH, self.maskView.frame.size.height-90)];
        self.sortView.delegate = self;
        [self.maskView addSubview:self.sortView];
    }
}

-(void)OnTapMaskView:(UITapGestureRecognizer *)sender{
    self.maskView.hidden = YES;
}

#pragma mark --- ScrollView Delegate ---

/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 49是触发操作的的阈值
    if (scrollView.contentOffset.y == fmaxf(.0f, scrollView.contentSize.height - scrollView.frame.size.height) + 49) {
        [self moreData];
    }
}
 */

#pragma mark ------------- SearchProductDelegate ----------------
- (void)searchSecondhandByKey:(NSString *)keyString
{
    self.keyString = keyString;
    self.searchBar.placeholder = keyString;
    [self searchByKey:keyString];
}

#pragma mark ----- UISearchBarDelegate ------

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.delegate = self;
    //searchVC.hidesBottomBarWhenPushed = YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    return NO;
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //    NSLog(@"touch view  1:%@",touch.view);
    //    NSLog(@"touch view  11:%@",touch.view.superview);
    //    NSLog(@"touch view  111:%@",touch.view.superview.superview);
    if ([touch.view isKindOfClass:[UITableView class]]) {
        //        NSLog(@"111111");
        return NO;
    }
    if ([touch.view.superview isKindOfClass:[UITableView class]]) {
        //        NSLog(@"22222");
        return NO;
    }
    if ([touch.view.superview.superview isKindOfClass:[UITableView class]]) {
        //        NSLog(@"33333");
        return NO;
    }
    if ([touch.view.superview.superview.superview isKindOfClass:[UITableView class]]) {
        //        NSLog(@"44444");
        return NO;
    }
    return YES;
}

#pragma mark --- request for data ---

- (void)getFirstPageData
{
    [self refreshData];
}

- (void)searchByKey:(NSString *)keyString
{
    // 先清空当前数据
    [self.activityIndicatorView startAnimating];
    [self.bl resetOffset];
    [self.dataArray removeAllObjects];
    [self.frameArray removeAllObjects];
    [self.activityIndicatorView startAnimating];
    
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
    
    // ******************** 商品类别条件过滤 ************************
    // 读取商品大分类字典
    NSString *plistPath2 = [[NSBundle mainBundle] pathForResource:@"CategoryClassDictionary" ofType:@"plist"];
    NSMutableDictionary *categoryClassDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath2];
    // 读取所有商品分类字典
    NSString *plistPath3 = [[NSBundle mainBundle] pathForResource:@"CategoryDictionary" ofType:@"plist"];
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath3];
    if (self.viceCategory != 0) {
        NSMutableArray *categoryArray = [[NSMutableArray alloc] initWithArray:[categoryClassDic objectForKey:[NSString stringWithFormat:@"%ld", self.viceCategory]]];
        if (categoryArray.count == 0) {
            [categoryArray addObject:[categoryDic objectForKey:[NSString stringWithFormat:@"%ld", self.viceCategory]]];
        }
        
        [filterDic setObject:categoryArray forKey:@"vice_category"];
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
    [self.activityIndicatorView startAnimating];
    [self.bl resetOffset];
    [self.dataArray removeAllObjects];
    [self.frameArray removeAllObjects];
    [self.activityIndicatorView startAnimating];
    
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
    
    // ******************** 商品类别条件过滤 ************************
    // 读取商品大分类字典
    NSString *plistPath2 = [[NSBundle mainBundle] pathForResource:@"CategoryClassDictionary" ofType:@"plist"];
    NSMutableDictionary *categoryClassDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath2];
    // 读取所有商品分类字典
    NSString *plistPath3 = [[NSBundle mainBundle] pathForResource:@"CategoryDictionary" ofType:@"plist"];
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath3];
    if (self.viceCategory != 0) {
        NSMutableArray *categoryArray = [[NSMutableArray alloc] initWithArray:[categoryClassDic objectForKey:[NSString stringWithFormat:@"%ld", self.viceCategory]]];
        if (categoryArray.count == 0) {
            [categoryArray addObject:[categoryDic objectForKey:[NSString stringWithFormat:@"%ld", self.viceCategory]]];
        }
        
        [filterDic setObject:categoryArray forKey:@"vice_category"];
    }
    
    // ********************* 关键字搜索过滤 ***********************
    if (self.keyString.length > 0) {
        [filterDic setObject:self.keyString forKey:@"product_name"];
    }
    
    [self.bl findSecondhand:filterDic];
}

// 根据商品分类查询时的下拉刷新
- (void)loadNewDataAction
{
    __weak SecondhandVC *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /*
        
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
        
        // ******************** 商品类别条件过滤 ************************
        // 读取商品大分类字典
        NSString *plistPath2 = [[NSBundle mainBundle] pathForResource:@"CategoryClassDictionary" ofType:@"plist"];
        NSMutableDictionary *categoryClassDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath2];
        // 读取所有商品分类字典
        NSString *plistPath3 = [[NSBundle mainBundle] pathForResource:@"CategoryDictionary" ofType:@"plist"];
        NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath3];
        if (self.viceCategory != 0) {
            NSMutableArray *categoryArray = [[NSMutableArray alloc] initWithArray:[categoryClassDic objectForKey:[NSString stringWithFormat:@"%ld", self.viceCategory]]];
            if (categoryArray.count == 0) {
                [categoryArray addObject:[categoryDic objectForKey:[NSString stringWithFormat:@"%ld", self.viceCategory]]];
            }
            
            [filterDic setObject:categoryArray forKey:@"vice_category"];
        }
        
        [weakSelf.bl findNewComming:filterDic];
        */
        
        [weakSelf.refresh endRefresh];
    });
}

// 上拉加载
- (void)loadMoreDateAction
{
    __weak SecondhandVC *weakSelf = self;
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
        
        // ******************** 商品类别条件过滤 ************************
        // 读取商品大分类字典
        NSString *plistPath2 = [[NSBundle mainBundle] pathForResource:@"CategoryClassDictionary" ofType:@"plist"];
        NSMutableDictionary *categoryClassDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath2];
        // 读取所有商品分类字典
        NSString *plistPath3 = [[NSBundle mainBundle] pathForResource:@"CategoryDictionary" ofType:@"plist"];
        NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath3];
        if (self.viceCategory != 0) {
            NSMutableArray *categoryArray = [[NSMutableArray alloc] initWithArray:[categoryClassDic objectForKey:[NSString stringWithFormat:@"%ld", self.viceCategory]]];
            if (categoryArray.count == 0) {
                [categoryArray addObject:[categoryDic objectForKey:[NSString stringWithFormat:@"%ld", self.viceCategory]]];
            }
            
            [filterDic setObject:categoryArray forKey:@"vice_category"];
        }
        
        // ********************* 关键字搜索过滤 ***********************
        if (self.keyString.length > 0) {
            [filterDic setObject:self.keyString forKey:@"product_name"];
        }
        
        [weakSelf.bl findSecondhand:filterDic];
        
    });
}

- (void)moreData
{
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
    
    // ******************** 商品类别条件过滤 ************************
    // 读取商品大分类字典
    NSString *plistPath2 = [[NSBundle mainBundle] pathForResource:@"CategoryClassDictionary" ofType:@"plist"];
    NSMutableDictionary *categoryClassDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath2];
    // 读取所有商品分类字典
    NSString *plistPath3 = [[NSBundle mainBundle] pathForResource:@"CategoryDictionary" ofType:@"plist"];
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath3];
    if (self.viceCategory != 0) {
        NSMutableArray *categoryArray = [[NSMutableArray alloc] initWithArray:[categoryClassDic objectForKey:[NSString stringWithFormat:@"%ld", self.viceCategory]]];
        if (categoryArray.count == 0) {
            [categoryArray addObject:[categoryDic objectForKey:[NSString stringWithFormat:@"%ld", self.viceCategory]]];
        }
        
        [filterDic setObject:categoryArray forKey:@"vice_category"];
    }
    
    // ********************* 关键字搜索过滤 ***********************
    if (self.keyString.length > 0) {
        [filterDic setObject:self.keyString forKey:@"product_name"];
    }
    
    [self.bl findSecondhand:filterDic];
}

#pragma mark --- UITableViewDelegate ---

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"secondhandVCCell";
    SecondhandCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SecondhandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.model = _dataArray[indexPath.row];
    cell.frameModel = _frameArray[indexPath.row];
    return cell;
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

#pragma mark --- SecondhandFilterDelegate ---
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withId:(NSNumber *)ID withName:(NSString *)name{
    NSLog(@"ID:%@  name:%@",ID,name);
    _KindID = [ID integerValue];
    _maskView.hidden = YES;
    self.schoolCategory = [ID integerValue];
    [self.currentMenuBtn setTitle:name forState:UIControlStateNormal];
    [self getFirstPageData];
    
    //self.schoolCategory = [ID integerValue];
}

#pragma mark -- CategoryFilterDelegate ---
- (void)categoryTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withId:(NSNumber *)ID withName:(NSString *)name
{
    NSLog(@"ID:%@  name:%@",ID,name);
    _maskView.hidden = YES;
    self.viceCategory = [ID integerValue];
    [self.currentMenuBtn setTitle:name forState:UIControlStateNormal];
    [self getFirstPageData];
}

#pragma mark --- SortDelegate ---
- (void)sortTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withId:(NSNumber *)ID withName:(NSString *)name
{
    NSLog(@"%@", name);
    _maskView.hidden = YES;
    [self.currentMenuBtn setTitle:name forState:UIControlStateNormal];
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
    
    // 结束刷新
    [self.refresh endRefresh];
    [self.activityIndicatorView stopAnimating];
}

- (void)findSecondhandFailed:(NSError *)error
{
    /*
    [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"服务器开小差了哦"];
    [self.activityIndicatorView stopAnimating];
    [self.refresh endRefresh];
     */
    /*
    [self.activityIndicatorView stopAnimating];
    [self.refresh endRefresh];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"请求失败" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:ac animated:YES completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(createAlert:) userInfo:ac repeats:NO];
     */
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
    [self.refresh endRefresh];
}

- (void)findNewCommingSecondhandFailed:(NSError *)error
{
    // 结束刷新
    /*
    [self.activityIndicatorView stopAnimating];
    [self.refresh endRefresh];
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

#pragma mark --- getter && setter ---

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    return _dataArray;
}

- (NSMutableArray *)frameArray
{
    if (!_frameArray) {
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

@end
