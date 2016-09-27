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
                                  @{@"title":@"书籍"},
                                  @{@"title":@"期刊杂志"},
                                  @{@"title":@"CD/DVD"},
                                  @{@"title":@"其他"},
                                  ] ,
                              @[
                                  @{@"title":@"电脑"},
                                  @{@"title":@"手机"},
                                  @{@"title":@"相机"},
                                  @{@"title":@"U盘"},
                                  @{@"title":@"移动硬盘"},
                                  @{@"title":@"耳机"},
                                  ],
                              @[
                                  @{@"title":@"自行车"},
                                  @{@"title":@"其他"},
                                  ],
                              @[
                                  @{@"title":@"男上衣"},
                                  @{@"title":@"男裤"},
                                  @{@"title":@"女上衣"},
                                  @{@"title":@"女裙"},
                                  @{@"title":@"女裤"},
                                  @{@"title":@"其他"},
                                  ],
                              @[
                                  @{@"title":@"男鞋"},
                                  @{@"title":@"男包"},
                                  @{@"title":@"女鞋"},
                                  @{@"title":@"女包"},
                                  @{@"title":@"配饰"},
                                  @{@"title":@"其他"},
                                  ],
                              @[
                                  @{@"title":@"足球"},
                                  @{@"title":@"篮球"},
                                  @{@"title":@"乒乓球/拍/"},
                                  @{@"title":@"羽毛球/拍"},
                                  @{@"title":@"健身器材"},
                                  @{@"title":@"其他"},
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
