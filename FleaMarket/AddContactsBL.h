//
//  AddContactsBL.h
//  FleaMarket
//
//  Created by Hou on 5/16/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddContactsDAODelegate.h"
#import "AddContactsBLDelegate.h"
#import "SysMessage.h"

@interface AddContactsBL : NSObject<AddContactsDAODelegate>

@property (weak, nonatomic) id<AddContactsBLDelegate> delegate;

//获取所有用户信息
-(void)loadUsersBL;

//请求添加好友
-(void)requestAddFriendBL:(NSString *)userId;


//同意添加好友
-(void)agreeFriendRequest:(SysMessage *)msg;
@end
