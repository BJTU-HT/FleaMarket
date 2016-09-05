//
//  SecondhandDetailViewController.h
//  FleaMarket
//
//  Created by tom555cat on 16/4/10.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondhandVO.h"

@interface SecondhandDetailViewController : UIViewController

@property (nonatomic, strong) SecondhandVO *model;
@property (nonatomic, strong) UINavigationController *nav;
@end
