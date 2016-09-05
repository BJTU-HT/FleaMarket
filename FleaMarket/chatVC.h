//
//  chatVC.h
//  FleaMarket
//
//  Created by Hou on 4/7/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobIMSDK/BmobIM.h>

@interface chatVC : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

//用于和服务器建立连接 connect to server
@property (strong, nonatomic) BmobIM *sharedIM;
@property (copy  , nonatomic) NSString *userId;
@property (copy  , nonatomic) NSString *token;
@end
