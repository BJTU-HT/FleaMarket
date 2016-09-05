//
//  AddContactsBLDelegate.h
//  FleaMarket
//
//  Created by Hou on 5/16/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef AddContactsBLDelegate_h
#define AddContactsBLDelegate_h

@protocol AddContactsBLDelegate <NSObject>
@optional

#pragma 添加好友部分
//请求服务器所有用户信息
-(void)addContactsLoadAllUsersInfoFinishedBL:(NSMutableArray *)arr;
-(void)addContactsLoadAllUsersInfoFailedBL:(NSString *)error;

//请求添加好友
-(void)requestAddFriendFinishedBL:(BOOL)value;
-(void)requestAddFriendFailedBL:(NSString *)error;

//同意添加好友 1为同意 0 为不同意
-(void)agreeFriendRequestFinishedBL:(BOOL)value;
#pragma 添加好友部分 end
@end

#endif /* AddContactsBLDelegate_h */
