//
//  myConcernedVC.h
//  FleaMarket
//
//  Created by Hou on 9/12/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myConcernedBL.h"
#import "myConcernedBLDelegate.h"
#import <BmobSDK/BmobUser.h>
#import "myConcernedTableViewCell.h"

@interface myConcernedVC : UIViewController<UITableViewDelegate, UITableViewDataSource, myConcernedBLDelegate>

@property(nonatomic, weak) id <myConcernedBLDelegate> delegate;
@property(nonatomic, strong) UITableView *tableViewConcerned;
@property(nonatomic, strong) NSMutableArray *muArrMyConcerned;
@property(nonatomic, strong) BmobUser *curUserMyConcerned;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end
