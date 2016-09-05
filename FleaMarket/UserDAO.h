//
//  UserDAO.h
//  FleaMarket
//
//  Created by tom555cat on 16/3/31.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDAODelegate.h"
#import "UserVO.h"

@interface UserDAO : NSObject

// 保存的数据列表
@property (nonatomic, strong) NSMutableArray *listData;

@property (weak, nonatomic) id <UserDAODelegate> delegate;

// 插入User方法
- (void)create:(UserVO *)model;

// 修改User方法
- (void)modify:(UserVO *)model;

// 查询所有数据方法
- (void)findAll;

+ (UserDAO *)sharedManager;

@end
