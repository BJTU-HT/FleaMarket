//
//  ContactsBL.h
//  FleaMarket
//
//  Created by Hou on 5/9/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatBLDelegate.h"

@interface ContactsBL : NSObject

@property (nonatomic, weak) id<ChatBLDelegate> delegate;

//获取好友列表
-(void)getMyFriendUsersArrBL;

//获取添加好友申请
-(void)loadInvitedMessagesBL;
@end
