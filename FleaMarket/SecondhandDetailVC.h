//
//  SecondhandDetailVC.h
//  FleaMarket
//
//  Created by tom555cat on 16/9/14.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondhandVO.h"

@interface SecondhandDetailVC : UIViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) SecondhandVO *model;

@end
