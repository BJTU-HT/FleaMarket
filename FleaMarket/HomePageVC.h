//
//  HomePageVC.h
//  FleaMarket
//
//  Created by Hou on 6/19/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *homeTableView;

@end
