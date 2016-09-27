//
//  LocationViewController.m
//  RW_DropdownMenu
//
//  Created by tom555cat on 16/5/19.
//  Copyright © 2016年 RyanWong. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()

@property (nonatomic, strong) ConditionDoubleTableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *leftArray;
@property (nonatomic, strong) NSArray *rightArray;

@end

@implementation LocationViewController

- (void)viewWillAppear:(BOOL)animated
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_03.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToMain)];
}

- (void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

//测试数据
- (void)testData {
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
    NSArray *One_leftArray = @[@"北京", @"山西", @"上海", @"江苏", @"陕西"];
    NSArray *Two_leftArray = [[NSArray alloc] init];
    //    NSArray *R_leftArray = @[@"Test1", @"Test2"];
    
    
    _leftArray = [[NSArray alloc] initWithObjects:One_leftArray, Two_leftArray, nil];
}

//右边列表不可为空
- (void)testRightArray {
    NSArray *F_rightArray = @[
                              @[
                                  @{@"title":@"清华大学"},
                                  @{@"title":@"北京大学"},
                                  @{@"title":@"北京交通大学"},
                                  @{@"title":@"北京邮电大学"}
                                  ] ,
                              @[
                                  @{@"title":@"山西大学"},
                                  @{@"title":@"太原理工大学"},
                                  @{@"title":@"山西财经大学"},
                                  ],
                              @[
                                  @{@"title":@"上海交通大学"},
                                  @{@"title":@"复旦大学"},
                                  ],
                              @[
                                  @{@"title":@"南京大学"},
                                  @{@"title":@"东南大学"},
                                  ],
                              @[
                                  @{@"title":@"西安交通大学"},
                                  @{@"title":@"西北工业大学"},
                                  ]
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

#pragma mark ---------------ConditionDoubleTableViewDelegate---------------------

- (void)hideMenu
{

}

- (void)selectedFirstValue:(NSString *)first SecondValue:(NSString *)second
{
    NSLog(@"%s : You choice %@ and %@", __FUNCTION__, first, second);
    
    int leftLoc = [first intValue];
    int rightLoc = [second intValue];
    NSArray *temp = _rightArray[0];
    NSArray *ll = temp[leftLoc];
    NSDictionary *lll = ll[rightLoc];
    NSString *value = [lll objectForKey:@"title"];
    
    NSArray *temp1 = _leftArray[0];
    NSString *lt = temp1[leftLoc];
    
    NSLog(@"选择的地址是：%@, %@", lt, value);
    [self.delegate chooseLocation:value];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
