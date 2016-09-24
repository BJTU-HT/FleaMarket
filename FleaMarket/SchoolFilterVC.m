//
//  SchoolFilterVC.m
//  FleaMarket
//
//  Created by tom555cat on 16/9/23.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "SchoolFilterVC.h"
#import "SecondhandFilterView.h"

@interface SchoolFilterVC ()

@property (nonatomic, strong) SecondhandFilterView *groupView;

@end

@implementation SchoolFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNav];
    [self initViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

// trick，必须要有这个
- (void)setNav
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidthPCH, 64)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
}


 - (void)initViews
{
    self.view.backgroundColor = darkGrayColorPCH;
    self.navigationItem.title = @"选择学校";
    
    self.groupView = [[SecondhandFilterView alloc] initWithFrame:CGRectMake(0, 64, screenWidthPCH, screenHeightPCH-64-49-50)];
    // groupView的点击代理由上一层viewController去实现
    self.groupView.delegate = [self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count]-2)];
    [self.view addSubview:self.groupView];
}

- (void)OnBackBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
