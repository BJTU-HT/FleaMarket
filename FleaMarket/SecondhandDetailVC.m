//
//  SecondhandDetailVC.m
//  FleaMarket
//
//  Created by tom555cat on 16/9/14.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "SecondhandDetailVC.h"

@interface SecondhandDetailVC () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation SecondhandDetailVC

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNav];
    [self initViews];
}

- (void)setNav
{
    //UIView *backView = [[UIView alloc] initWithFrame:(CGRect)];
}

- (void)initViews
{
    
}

@end
