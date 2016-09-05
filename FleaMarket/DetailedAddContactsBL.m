//
//  DetailedAddContactsBL.m
//  FleaMarket
//
//  Created by Hou on 5/17/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "DetailedAddContactsBL.h"
#import "SysMessage.h"
#import "UserService.h"

@implementation DetailedAddContactsBL


//-(void)agreeFriendRequestBL:(UIButton *)button{
//    SysMessage *msg = self.dataArray[button.tag];
//    
//    
//    [UserService agreeFriendWithObejctId:msg.objectId userId:msg.fromUser.objectId completion:^(BOOL isSuccessful, NSError *error) {
//        if (isSuccessful) {
//            [UserService addFriendWithUser:msg.toUser friend:msg.fromUser completion:^(BOOL isSuccessful, NSError *error) {
//                if (isSuccessful) {
//                    [self showInfomation:@"已同意添加好友"];
//                    [button setTitle:@"已同意" forState:UIControlStateNormal];
//                    button.enabled = NO;
//                }else{
//                    [self showInfomation:@"请稍后再试"];
//                }
//            }];
//        }else{
//            [self showInfomation:@"请稍后再试"];
//        }
//    }];
//    
//}
@end
