
//
//  ChatBLDelegate.h
//  FleaMarket
//
//  Created by Hou on 5/9/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef ChatBLDelegate_h
#define ChatBLDelegate_h

@protocol ChatBLDelegate <NSObject>
@optional

//请求好友列表
-(void)getMyFriendUsersFinishedBL:(NSMutableArray *)array;
-(void)getMyFriendUsersFaileddBL:(NSString *)error;

//请求好友通知
-(void)requesInvitedMessageFinishedBL:(NSMutableArray *)array;
-(void)requesInvitedMessageFailedBL:(NSString *)error;
@end

#endif /* ChatBLDelegate_h */
