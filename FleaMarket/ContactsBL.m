//
//  ContactsBL.m
//  FleaMarket
//
//  Created by Hou on 5/9/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "ContactsBL.h"
#import "UserService.h"
#import "MessageService.h"

@implementation ContactsBL

//获取当前用户的好友列表
-(void)getMyFriendUsersArrBL{
    [UserService friendsWithCompletion:^(NSArray *array, NSError *error) {
        if(error){
            [self.delegate getMyFriendUsersFaileddBL:SEARCH_FRIEND_LIST_FAILED];
        }else{
            BmobUser *loginUser = [BmobUser getCurrentUser];
            NSMutableArray *result  = [NSMutableArray array];
            for (BmobObject *obj in array) {
                
                BmobUser *friend = nil;
                if ([[(BmobUser *)[obj objectForKey:@"user"] objectId] isEqualToString:loginUser.objectId]) {
                    friend = [obj objectForKey:@"friendUser"];
                }else{
                    friend = [obj objectForKey:@"user"];
                }
                BmobIMUserInfo *info = [BmobIMUserInfo userInfoWithBmobUser:friend];
                
                [result addObject:info];
            }
            if (result && result.count > 0) {
//                NSMutableArray *userArrConBL = [[NSMutableArray alloc] init];
//                [userArrConBL setArray: result];
                [self.delegate getMyFriendUsersFinishedBL: result];
            }
            
        }
    }];
}

//获取请求添加好友的通知
-(void)loadInvitedMessagesBL{
    [MessageService inviteMessages:[NSDate date] completion:^(NSArray *array, NSError *error) {
        if (error) {
            [self.delegate requesInvitedMessageFailedBL:REQUEST_INVITED_MESSAGE_FAILED];
        }else{
            if (array && array.count > 0) {
                NSMutableArray *dataArr = [[NSMutableArray alloc] init];
                [dataArr setArray:array];
                [self.delegate requesInvitedMessageFinishedBL:dataArr];
            }
        }
    }];
    
}


@end
