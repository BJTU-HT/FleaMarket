//
//  ViewController.m
//  FleaMarket
//
//  Created by tom555cat on 16/4/13.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "ViewController.h"
#import "publishVC.h"
#import "chatVC.h"
#import "myVC.h"
#import "HomePageVC.h"
#import "SecondhandViewController.h"
#import "BookMainPageVC.h"

#define TABBARITEM_PIC_OFFSET_TOP 5
#define TABBARITEM_PIC_OFFSET_BOTTOM 5
#define TABBARITEM_PIC_OFFSET_LEFT 5
#define TABBARITEM_PIC_OFFSET_RIGHT 5

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.delegate = self;
    
    //HomePageVC *homeVC = [[HomePageVC alloc] init];
    //firstPageVC *firstVC = [[firstPageVC alloc] init];
    SecondhandViewController *secondHandVC = [[SecondhandViewController alloc] init];
    UINavigationController *firstPageNav = [[UINavigationController alloc] initWithRootViewController: secondHandVC];
    firstPageNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"ic_tabbar_dicovery@2x.png"] tag:0];
    firstPageNav.navigationBarHidden = YES;
    
    BookMainPageVC *bookMain = [[BookMainPageVC alloc] init];
    UINavigationController *bookMainNav = [[UINavigationController alloc] initWithRootViewController: bookMain];
    bookMainNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"书籍" image:[UIImage imageNamed:@"ic_tabbar_dicovery@2x.png"] tag:0];
    bookMainNav.navigationBarHidden = YES;
    
    publishVC *pubVC = [[publishVC alloc] init];
    UINavigationController *pubPageNav = [[UINavigationController alloc] initWithRootViewController:pubVC];
    pubPageNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发布" image:[UIImage imageNamed:@"ic_tabbar_local@2x.png"] tag:1];
    //pubPageNav.tabBarItem.imageInsets = UIEdgeInsetsMake(TABBARITEM_PIC_OFFSET_TOP, TABBARITEM_PIC_OFFSET_LEFT, TABBARITEM_PIC_OFFSET_BOTTOM, TABBARITEM_PIC_OFFSET_RIGHT);
    pubPageNav.navigationBarHidden = YES;
    
    chatVC *chat = [[chatVC alloc] init];
    UINavigationController *chatNav = [[UINavigationController alloc] initWithRootViewController:chat];
    chatNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"聊天" image:[UIImage imageNamed:@"ic_tabbar_chat@2x.png"] tag:2];
    // chatNav.tabBarItem.imageInsets = UIEdgeInsetsMake(TABBARITEM_PIC_OFFSET_TOP, TABBARITEM_PIC_OFFSET_LEFT, TABBARITEM_PIC_OFFSET_BOTTOM, TABBARITEM_PIC_OFFSET_RIGHT);
    //chatNav.navigationBarHidden = YES;
    
    myVC *my = [[myVC alloc] init];
    UINavigationController *myNav = [[UINavigationController alloc] initWithRootViewController:my];
    myNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"ic_tabbar_mine@2x.png"] tag:3];
    //myNav.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    myNav.navigationBarHidden = YES;
    tabBarController.viewControllers = [NSArray arrayWithObjects:firstPageNav, bookMainNav, pubPageNav, chatNav, myNav,nil];
    self.topTabBarController = tabBarController;
    [self.view addSubview:tabBarController.view];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.}
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end