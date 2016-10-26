//
//  AddContactsDAO.m
//  FleaMarket
//
//  Created by Hou on 5/16/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "AddContactsDAO.h"

@implementation AddContactsDAO

-(void)loadUsersDAO{
    NSMutableArray *userArray = [[NSMutableArray alloc] init];
    [UserService loadUsersWithDate:[NSDate date] completion:^(NSArray *array, NSError *error) {
        if (error) {
            [self.delegate addContactsLoadAllUsersInfoFailedDAO:GET_USER_DATA_FROM_SERVER_FAILED];
        }else{
            if (array && array.count > 0) {
                [userArray setArray:array];
                [UserService friendsWithCompletion:^(NSArray *array, NSError *error) {
                    if(error){
                        [self.delegate addContactsLoadAllUsersInfoFailedDAO:GET_USER_DATA_FROM_SERVER_FAILED];
                    }else{
                        if(array && array.count > 0){
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
//                                BmobUser *friend = nil;
//                                if ([[(BmobUser *)[obj objectForKey:@"user"] objectId] isEqualToString:loginUser.objectId]) {
//                                    friend = [obj objectForKey:@"friendUser"];
//                                    BmobIMUserInfo *info = [BmobIMUserInfo userInfoWithBmobUser:friend];
//                                    [result addObject:info];
//                                }else{
//                                    friend = [obj objectForKey:@"user"];
//                                    BmobIMUserInfo *info = [BmobIMUserInfo userInfoWithBmobUser:friend];
//                                    [result addObject:info];
//                                }
                            }
                            if(result && result.count > 0) {
                                for(int i = 0; i < result.count; i++){
                                    for(int j = 0; j < userArray.count; j++){
                                        NSString *strResult = [[result objectAtIndex:i] userId];
                                        NSString *strUserArray = [userArray[j] userId];
                                        if([strResult isEqualToString:strUserArray]){
                                            [userArray removeObject:userArray[j]];
                                        }
                                    }
                                }
                            }
                            [self.delegate addContactsLoadAllUsersInfoFinishedDAO:userArray];
                        }else{
                            [self.delegate addContactsLoadAllUsersInfoFinishedDAO:userArray];
                        }
                        
                    }
                }];
            }else{
                [self.delegate addContactsLoadAllUsersInfoFailedDAO:GET_USER_DATA_FROM_SERVER_FAILED];
            }
        }
    }];
}


@end
