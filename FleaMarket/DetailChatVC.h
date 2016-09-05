//
//  DetailChatVC.h
//  FleaMarket
//
//  Created by Hou on 5/17/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "passValueForVCDelegate.h"
#import <BmobIMSDK/BmobIMSDK.h>
#import "SendAndRecMesDelegateBL.h"

@interface DetailChatVC : UIViewController<passValueForVCDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, SendAndRecMesDelegateBL>

@property(nonatomic, strong) BmobIMConversation *conversation;
@property(nonatomic, strong) UITableView *tableViewChat;

//用于和服务器建立连接 connect to server
@property (strong, nonatomic) BmobIM *sharedIM;
@property (copy  , nonatomic) NSString *userId;
@property (copy  , nonatomic) NSString *token;

@end
