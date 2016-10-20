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
    NSArray *One_leftArray = @[@"北京", @"上海", @"天津", @"重庆", @"河北",@"山西",@"内蒙古",@"辽宁",@"吉林",@"黑龙江",@"江苏",@"浙江",@"安徽",@"福建",@"江西",@"山东",@"河南",@"湖北",@"湖南",@"广东",@"广西",@"四川",@"云南",@"贵州",@"陕西",@"甘肃",@"新疆",@"海南",@"宁夏",@"青海",@"西藏"];
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
                                  @{@"title":@"中国人民大学"},
                                  @{@"title":@"北京工业大学"},
                                  @{@"title":@"北京理工大学"},
                                  @{@"title":@"北京航空航天大学"},
                                  @{@"title":@"北京化工大学"},
                                  @{@"title":@"北京邮电大学"},
                                  @{@"title":@"对外经济贸易大学"},
                                  @{@"title":@"中国传媒大学"},
                                  @{@"title":@"中央名族大学"},
                                  @{@"title":@"中国矿业大学(北京)"},
                                  @{@"title":@"中央财经大学"},
                                  @{@"title":@"中国政法大学"},
                                  @{@"title":@"中国石油大学(北京)"},
                                  @{@"title":@"中央音乐学院"},
                                  @{@"title":@"北京体育大学"},
                                  @{@"title":@"北京外国语大学"},
                                  @{@"title":@"北京交通大学"},
                                  @{@"title":@"北京科技大学"},
                                  @{@"title":@"北京林业大学"},
                                  @{@"title":@"中国农业大学"},
                                  @{@"title":@"北京中医药大学"},
                                  @{@"title":@"华北电力大学(北京)"},
                                  @{@"title":@"北京师范大学"},
                                  @{@"title":@"中国地质大学(北京)"},
                                  ] ,
                              @[
                                  @{@"title":@"复旦大学"},
                                  @{@"title":@"华东师范大学"},
                                  @{@"title":@"上海外国语大学"},
                                  @{@"title":@"上海大学"},
                                  @{@"title":@"同济大学"},
                                  @{@"title":@"华东理工大学"},
                                  @{@"title":@"东华大学"},
                                  @{@"title":@"上海财经大学"},
                                  @{@"title":@"上海交通大学"},
                                  ],
                              @[
                                  @{@"title":@"南开大学"},
                                  @{@"title":@"天津大学"},
                                  @{@"title":@"天津医科大学"},
                                  ],
                              @[
                                  @{@"title":@"重庆大学"},
                                  @{@"title":@"西南大学"},
                                  ],
                              @[
                                  @{@"title":@"华北电力大学(保定)"},
                                  @{@"title":@"河北工业大学"},
                                  ],
                              @[
                                  @{@"title":@"太原理工大学"},
                                  ],
                              @[
                                  @{@"title":@"内蒙古大学"},
                                  ],
                              @[
                                  @{@"title":@"大连理工大学"},
                                  @{@"title":@"东北大学"},
                                  @{@"title":@"辽宁大学"},
                                  @{@"title":@"大连海事大学"},
                                  ],
                              @[
                                  @{@"title":@"吉林大学"},
                                  @{@"title":@"东北师范大学"},
                                  @{@"title":@"延边大学"},
                                  ],
                              @[
                                  @{@"title":@"东北农业大学"},
                                  @{@"title":@"东北林业大学"},
                                  @{@"title":@"哈尔滨工业大学"},
                                  @{@"title":@"哈尔滨工程大学"},
                                  ],
                              @[
                                  @{@"title":@"南京大学"},
                                  @{@"title":@"东南大学"},
                                  @{@"title":@"江苏大学"},
                                  @{@"title":@"河海大学"},
                                  @{@"title":@"中国医科大学"},
                                  @{@"title":@"中国矿业大学(徐州)"},
                                  @{@"title":@"南京师范大学"},
                                  @{@"title":@"南京理工大学"},
                                  @{@"title":@"南京航空航天大学"},
                                  @{@"title":@"江南大学"},
                                  @{@"title":@"南京农业大学"},
                                  ],
                              @[
                                  @{@"title":@"浙江大学"},
                                  ],
                              @[
                                  @{@"title":@"安徽大学"},
                                  @{@"title":@"合肥工业大学"},
                                  @{@"title":@"中国科技大学"},
                                  ],
                              @[
                                  @{@"title":@"厦门大学"},
                                  @{@"title":@"福州大学"},
                                  ],
                              @[
                                  @{@"title":@"南昌大学"},
                                  ],
                              @[
                                  @{@"title":@"山东大学"},
                                  @{@"title":@"中国海洋大学"},
                                  @{@"title":@"中国石油大学(华东)"},
                                  ],
                              @[
                                  @{@"title":@"郑州大学"},
                                  ],
                              @[
                                  @{@"title":@"武汉大学"},
                                  @{@"title":@"华中科技大学"},
                                  @{@"title":@"中国地质大学(武汉)"},
                                  @{@"title":@"华中师范大学"},
                                  @{@"title":@"华中农业大学"},
                                  @{@"title":@"中南财经大学"},
                                  @{@"title":@"武汉理工大学"},
                                  ],
                              @[
                                  @{@"title":@"湖南大学"},
                                  @{@"title":@"中南大学"},
                                  @{@"title":@"湖南师范大学"},
                                  ],
                              @[
                                  @{@"title":@"中山大学"},
                                  @{@"title":@"暨南大学"},
                                  @{@"title":@"华南理工大学"},
                                  @{@"title":@"华南师范大学"},
                                  ],
                              @[
                                  @{@"title":@"广西大学"},
                                  ],
                              @[
                                  @{@"title":@"四川大学"},
                                  @{@"title":@"西南交通大学"},
                                  @{@"title":@"电子科技大学"},
                                  @{@"title":@"西南财经大学"},
                                  @{@"title":@"四川农业大学"},
                                  ],
                              @[
                                  @{@"title":@"云南大学"},
                                  ],
                              @[
                                  @{@"title":@"贵州大学"},
                                  ],
                              @[
                                  @{@"title":@"西北大学"},
                                  @{@"title":@"西安交通大学"},
                                  @{@"title":@"西北工业大学"},
                                  @{@"title":@"陕西师范大学"},
                                  @{@"title":@"西北农林科大"},
                                  @{@"title":@"西安电子科技大学"},
                                  @{@"title":@"长安大学"},
                                  ],
                              @[
                                  @{@"title":@"兰州大学"},
                                  ],
                              @[
                                  @{@"title":@"新疆大学"},
                                  @{@"title":@"石河子大学"},
                                  ],
                              @[
                                  @{@"title":@"海南大学"},
                                  ],
                              @[
                                  @{@"title":@"宁夏大学"},
                                  ],
                              @[
                                  @{@"title":@"青海大学"},
                                  ],
                              @[
                                  @{@"title":@"西藏大学"},
                                  ]                              ];
    
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
