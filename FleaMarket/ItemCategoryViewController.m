//
//  ItemCategoryViewController.m
//  FleaMarket
//
//  Created by tom555cat on 16/6/17.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "ItemCategoryViewController.h"

@interface ItemCategoryViewController ()

@property (nonatomic, strong) ConditionDoubleTableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *leftArray;
@property (nonatomic, strong) NSArray *rightArray;

@end

@implementation ItemCategoryViewController

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.view.frame = frame;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self testData];
    
    ConditionDoubleTableView *tableView = [[ConditionDoubleTableView alloc] initWithFrame:self.view.bounds andLeftItems:self.leftArray andRightItems:self.rightArray];
    tableView.delegate = self;
    [tableView showTableView:0 WithSelectedLeft:@"0" Right:@"0"];
    self.tableView = tableView;
    [self.view addSubview:self.tableView.view];
}

// 物品种类数据
- (void)testData
{
    [self testTitleArray];
    [self testLeftArray];
    [self testRightArray];
}

//每个下拉的标题
- (void) testTitleArray {
    //_titleArray = @[@"附近", @"菜品"];
    _titleArray = @[@"附近"];
}

//左边列表可为空，则为单下拉菜单，可以根据需要传参
- (void)testLeftArray {
    //NSArray *One_leftArray = @[@"附近", @"北京", @"山西", @"斗門區", @"金灣區"];
    NSArray *One_leftArray = SecondhandCategory;
    NSArray *Two_leftArray = [[NSArray alloc] init];
    //    NSArray *R_leftArray = @[@"Test1", @"Test2"];
    
    
    _leftArray = [[NSArray alloc] initWithObjects:One_leftArray, Two_leftArray, nil];
}

//右边列表不可为空
- (void)testRightArray {
    NSArray *F_rightArray = @[
                              @[
                                  @{@"title":@"手机"},
                                  @{@"title":@"相机/摄像机"},
                                  @{@"title":@"MP3/MP4"},
                                  @{@"title":@"移动硬盘"},
                                  @{@"title":@"U盘"},
                                  @{@"title":@"游戏机"},
                                  ] ,
                              @[
                                  @{@"title":@"台式机"},
                                  @{@"title":@"平板电脑"},
                                  @{@"title":@"显示器"},
                                  @{@"title":@"台式机配件"},
                                  @{@"title":@"笔记本电脑"},
                                  @{@"title":@"笔记本配件"},
                                  ],
                              @[
                                  @{@"title":@"女装"},
                                  @{@"title":@"女鞋"},
                                  @{@"title":@"男装"},
                                  @{@"title":@"男鞋"},
                                  ],
                              @[
                                  @{@"title":@"普通自行车"},
                                  @{@"title":@"山地自行车"},
                                  @{@"title":@"公路自行车"},
                                  @{@"title":@"小轮车"},
                                  @{@"title":@"死飞车"},
                                  @{@"title":@"折叠自行车"},
                                  ],
                              @[
                                  @{@"title":@"大球类"},
                                  @{@"title":@"羽毛球/乒乓球"},
                                  @{@"title":@"健身器材"},
                                  ],
                              @[
                                  @{@"title":@"其他"},
                                  ],
                              ];
    
    NSArray *S_rightArray = @[
                              @[
                                  @{@"title":@"one"},
                                  @{@"title":@"two"},
                                  @{@"title":@"three"}
                                  ] ,
                              @[
                                  @{@"title":@"four"}
                                  ]
                              ];
    
    _rightArray = [[NSArray alloc] initWithObjects:F_rightArray, S_rightArray, nil];
}

#pragma mark ---------- ConditionDoubleTableViewDelegate -------------

- (void)hideMenu
{
}

- (void)selectedFirstValue:(NSString *)first SecondValue:(NSString *)second
{
    int leftLoc = [first intValue];
    int rightLoc = [second intValue];
    NSArray *temp = _rightArray[0];
    NSArray *ll = temp[leftLoc];
    NSDictionary *lll = ll[rightLoc];
    NSString *value = [lll objectForKey:@"title"];
    
    NSArray *temp1 = _leftArray[0];
    NSString *lt = temp1[leftLoc];
    
    //[self.delegate chooseCategory:value];
    [self.delegate chooseCategory:lt category:value];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
