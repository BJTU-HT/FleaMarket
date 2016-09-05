//
//  ContactsDAO.m
//  FleaMarket
//
//  Created by Hou on 5/9/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "ContactsDAO.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobQuery.h>

@implementation ContactsDAO
static ContactsDAO *sharedManager = nil;
NSUserDefaults *userDefaultsChatDAO;
NSString *curUserNameChatDAO;

+(ContactsDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
        userDefaultsChatDAO = [NSUserDefaults standardUserDefaults];
        curUserNameChatDAO = [userDefaultsChatDAO objectForKey:@"userName"];
    });
    return sharedManager;
}

//更新好友数据用于添加好友
//-(void)updateFriendUsersDataDAO:(NSArray *)array{
//    
//    BmobQuery *bmobQuery = [BmobQuery queryWithClassName:@"user"];
//    NSString *bql = @"select * from user where userName = ?";
//    NSArray *placeholderArray = @[curUserNameChatDAO];
//    [bmobQuery queryInBackgroundWithBQL:bql pvalues:placeholderArray block:^(BQLQueryResult *result, NSError *error) {
//        if (error) {
//            NSLog(@"%@",error);
//            [self.delegate searchCurUserFailedChatDAO:FIND_CUR_USER_INFO_FAILED];
//        } else {
//            if(result)
//            {
//                if([result.resultsAry count] == 0){
//                    NSLog(@"%@",error);
//                    [self.delegate connectServerSuccessedButNoDataDAO:CUR_USER_HAS_NO_INFO_IN_SEARVER];
//                }
//                else{
//                    BmobObject *obj = [result.resultsAry objectAtIndex:0];
//                    BmobObject *gameScore = [BmobObject objectWithoutDatatWithClassName:@"user" objectId:obj.objectId];
//                    [gameScore addUniqueObjectsFromArray:array forKey:@"userFriends"];
//                    [gameScore updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//                        if(isSuccessful){
//                            [self.delegate updateCurUserInfoFromServerFinishedDAO:isSuccessful];
//                        }else{
//                            NSLog(@"%@", error.description);
//                            [self.delegate updateCurUserInfoFromServerFailedDAO: error];
//                        }
//                    }];
//                    
//                }
//            }
//            
//        }
//    }];
//}
//
////获取当前用户的所有好友，用于好友列表
//-(void)getCurUserFriendUsersDataDAO{
//    BmobQuery *bmobQuery = [BmobQuery queryWithClassName:@"user"];
//    NSString *bql = @"select * from user where userName = ?";
//    NSArray *placeholderArray = @[curUserNameChatDAO];
//    [bmobQuery queryInBackgroundWithBQL:bql pvalues:placeholderArray block:^(BQLQueryResult *result, NSError *error) {
//        if (error) {
//            NSLog(@"%@",error);
//            [self.delegate searchCurUserFailedChatDAO:FIND_CUR_USER_INFO_FAILED];
//        } else {
//            if(result)
//            {
//                if([result.resultsAry count] == 0){
//                    NSLog(@"%@",error);
//                    [self.delegate connectServerSuccessedButNoDataDAO:FIND_CUR_USER_INFO_FAILED];
//                }
//                else{
//                    BmobObject *obj = [result.resultsAry objectAtIndex:0];
//                    NSArray *userFriendArr = [obj objectForKey:@"userFriends"];
//                    BmobQuery *query = [BmobQuery queryWithClassName:@"user"];
//                    [query whereKey:@"nickName" containedIn:userFriendArr];
//                    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//                        if(error){
//                            [self.delegate findUserSuccessButSearchDetailedInfoFailedDAO: CUR_USER_HAS_NO_INFO_IN_SEARVER];
//                        }else{
//                            //用于存储用户名
//                            NSMutableArray *userArr = [[NSMutableArray alloc] init];
//                            //用于存储头像url
//                            NSMutableDictionary *headImageURLMutableArr = [[NSMutableDictionary alloc] init];
//                            for(BmobObject *obj1 in array){
//                                NSString *str = [obj1 objectForKey:@"nickName"];
//                                [userArr addObject:str];
//                                [headImageURLMutableArr setObject:[obj1 objectForKey:@"headImageURL"] forKey:str];
//                                [self.delegate returnBackFriendUserNameAndHeadImageURLDAO:userArr headImgaeURLs:headImageURLMutableArr];
//                            }
//                        }
//                        
//                    }];
//                }
//            }
//            
//        }
//    }];
//
//
//}
//
////删除当前用户的好友列表中的 某一个好友
//-(void)deleteCurUserUnFriendlyUserDAO:(NSString *)curUser{
//    
//}
@end
