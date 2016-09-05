//
//  FriendRequestListVC.h
//  FleaMarket
//
//  Created by Hou on 5/16/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatBLDelegate.h"
#import "AddContactsBLDelegate.h"

@interface FriendRequestListVC : UIViewController<UITableViewDelegate, UITableViewDataSource, ChatBLDelegate, AddContactsBLDelegate>

@property (nonatomic, strong) UITableView *tableViewReqList;

@end
