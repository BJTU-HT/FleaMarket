//
//  AddContactsBL.m
//  FleaMarket
//
//  Created by Hou on 5/16/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "AddContactsBL.h"
#import "AddContactsDAO.h"
#import "UserService.h"

@implementation AddContactsBL

-(void)loadUsersBL{
    AddContactsDAO *add = [[AddContactsDAO alloc] init];
    add.delegate = self;
    [add loadUsersDAO];
}

//请求添加为好友
-(void)requestAddFriendBL:(NSString *)userId{
    [UserService addFriendNoticeWithUserId:userId completion:^(BOOL isSuccessful, NSError *error) {
        if(isSuccessful){
            [self.delegate requestAddFriendFinishedBL:1];
        }else{
            [self.delegate requestAddFriendFailedBL:SEND_ADD_FRIEND_REQUEST_FAILED];
        }
    }];
}

-(void)agreeFriendRequest:(SysMessage *)msg{
    [UserService agreeFriendWithObejctId:msg.objectId userId:msg.fromUser.objectId completion:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [UserService addFriendWithUser:msg.toUser friend:msg.fromUser completion:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    //1为同意
                    [self.delegate agreeFriendRequestFinishedBL:1];
                }else{
                    // 0为出错
                    [self.delegate agreeFriendRequestFinishedBL:0];
                }
            }];
        }else{
            // 0为出错
            [self.delegate agreeFriendRequestFinishedBL:0];
        }
    }];

}
#pragma 实现添加好友DAO层代理方法----------
-(void)addContactsLoadAllUsersInfoFinishedDAO:(NSMutableArray *)arr{
    [self.delegate addContactsLoadAllUsersInfoFinishedBL:arr];
}
-(void)addContactsLoadAllUsersInfoFailedDAO:(NSString *)error{
    [self.delegate addContactsLoadAllUsersInfoFailedBL:error];
}

#pragma 实现添加好友DAO层代理方法 end------
@end
