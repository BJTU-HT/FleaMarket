//
//  UserDAO.m
//  FleaMarket
//
//  Created by tom555cat on 16/3/31.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <BmobSDK/Bmob.h>
#import "UserDAO.h"

@implementation UserDAO

static UserDAO *sharedManager = nil;

+ (UserDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

// 插入User方法
- (void)create:(UserVO *)model
{

}

// 修改User方法
- (void)modify:(UserVO *)model
{

}

// 查询User方法
- (void)findAll
{
}

@end
