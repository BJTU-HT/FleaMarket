//
//  ChatDAODelegate.h
//  FleaMarket
//
//  Created by Hou on 5/9/16.
//  Copyright © 2016 H-T. All rights reserved.
//


@class ContactsDAO;

@protocol ChatDAODelegate <NSObject>


//查询当前用户信息
-(void)searchCurUserFinishedChatDAO:(NSArray *)array;
-(void)searchCurUserFailedChatDAO:(NSString *)error;

//更新服务器数据
-(void)updateCurUserInfoFromServerFinishedDAO:(NSInteger)value;
-(void)updateCurUserInfoFromServerFailedDAO:(NSError *)error;

//已从服务器中找到该用户但该用户下无数据
-(void)connectServerSuccessedButNoDataDAO:(NSString *)error;

//查询用户具体信息时出错
-(void)findUserSuccessButSearchDetailedInfoFailedDAO:(NSString *)error;

//获取好友列表时回传 好友用户名和头像url字典
//-(void)returnBackFriendUserNameAndHeadImageURLDAO:(NSMutableArray *)mutArr  headImgaeURLs:(NSMutableDictionary *)mutDic;


@end