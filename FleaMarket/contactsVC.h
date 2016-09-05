//
//  contactsVC.h
//  FleaMarket
//
//  Created by Hou on 5/9/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatBLDelegate.h"
#import "BmobIMUserInfo+BmobUser.h"
#import "passValueForVCDelegate.h"

@interface contactsVC : UIViewController<UITableViewDataSource, UITableViewDelegate, ChatBLDelegate, UISearchBarDelegate, UITextFieldDelegate, passValueForVCDelegate>

@property(nonatomic, strong) UITableView *tableViewContacts;

//用于和服务器建立连接 connect to server
@property (strong, nonatomic) BmobIM *sharedIM;
@property (copy  , nonatomic) NSString *userId;
@property (copy  , nonatomic) NSString *token;

@property(nonatomic, weak) id<passValueForVCDelegate> delegate;
@end
