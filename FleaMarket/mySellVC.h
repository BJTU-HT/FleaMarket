//
//  mySellVC.h
//  FleaMarket
//
//  Created by Hou on 8/24/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mySellBL.h"
#import "mySellBLDelegate.h"
@interface mySellVC : UIViewController<UITableViewDelegate, UITableViewDataSource, mySellBLDelegate>

@property(nonatomic, strong) UITableView *tableViewSell;
@property(nonatomic, strong) NSMutableArray *recMutableArrSell;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorViewSell;
@end
