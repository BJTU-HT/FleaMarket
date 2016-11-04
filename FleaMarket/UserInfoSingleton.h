//
//  UserInfoSingleton.h
//  FleaMarket
//
//  Created by tom555cat on 16/7/22.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserMO.h"

@interface UserInfoSingleton : NSObject

@property (nonatomic, strong) UserMO *userMO;

/**
 *  登录成功，修改用户信息
 **/
- (void)updateUserMO:(NSDictionary *)userInfo;

/**
 *  用户退出，删除用户信息
 **/
- (void)logOutCurrentUser;

+ (UserInfoSingleton *)sharedManager;


@end
