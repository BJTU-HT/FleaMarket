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
            if(array && array.count){
                BmobUser *loginUser = [BmobUser getCurrentUser];
                NSMutableArray *result  = [NSMutableArray array];
                int i = 0;
                for (BmobObject *obj in array) {
                    BmobUser *friend = nil;
                    if ([[(BmobUser *)[obj objectForKey:@"user"] objectId] isEqualToString:loginUser.objectId]) {
                        friend = [obj objectForKey:@"friendUser"];
                        BmobIMUserInfo *info = [BmobIMUserInfo userInfoWithBmobUser:friend];
                        if(i == 0){
                            [result addObject:info];
                        }else{
                            for(int j = 0; j < result.count; j++){
                                if(![info.userId isEqualToString:[result[j] userId]]){
                                    [result addObject:info];
                                }
                            }
                        }
                    }else{
                        friend = [obj objectForKey:@"user"];
                        BmobIMUserInfo *info = [BmobIMUserInfo userInfoWithBmobUser:friend];
                        if(i == 0){
                            [result addObject:info];
                        }else{
                            for(int j = 0; j < result.count; j++){
                                if(![info.userId isEqualToString:[result[j] userId]]){
                                    [result addObject:info];
                                }
                            }
                        }
                    }
                    i++;
                }
                if (result && result.count > 0) {
                    [self.delegate getMyFriendUsersFinishedBL: result];
                }
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
            NSMutableArray *muArr0 = [[NSMutableArray alloc] init];
            NSMutableArray *muArr1 = [[NSMutableArray alloc] init];
            if (array && array.count > 0) {
                NSMutableArray *dataArr = [[NSMutableArray alloc] init];
                for(int i = 0; i < array.count; i++){
                    SysMessage *msg = array[i];
                    if([msg.type intValue] == 0){
                        [muArr0 addObject:array[i]];
                    }else if([msg.type intValue] == 1){
                        [muArr1 addObject:array[i]];
                    }
                }
                if(muArr0.count == 0 || muArr1.count == 0){
                    [dataArr setArray:array];
                    [self.delegate requesInvitedMessageFinishedBL:dataArr];
                }else{
                    for(int i = 0; i < muArr0.count; i++){
                        for(int j = 0; j < muArr1.count; j++){
                            if([[muArr0[i] fromUser] isEqual:[muArr1[j] fromUser]]){
                                [muArr0 removeObject:muArr0[i]];
                            }
                        }
                    }
                    //[dataArr setArray:array];
                    if(muArr0.count){
                        for(int i = 0; i < muArr0.count; i++){
                            [dataArr addObject:muArr0[i]];
                        }
                    }
                    if(muArr1.count){
                        for(int i = 0; i < muArr1.count; i++){
                            [dataArr addObject:muArr1[i]];
                        }
                    }
                    [self.delegate requesInvitedMessageFinishedBL:dataArr];
                }
            }
        }
    }];
}


@end
