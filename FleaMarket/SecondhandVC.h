//
//  SecondhandVC.h
//  FleaMarket
//
//  Created by tom555cat on 16/9/22.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondhandVC : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger viceCategory;   // 物品副分类
@property (nonatomic, assign) NSInteger schoolCategory; // 学校分类
@end
