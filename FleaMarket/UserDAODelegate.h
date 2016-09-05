//
//  UserDAODelegate.h
//  FleaMarket
//
//  Created by tom555cat on 16/3/31.
//  Copyright © 2016年 H-T. All rights reserved.
//

@class UserVO;

@protocol UserDAODelegate

@optional

// 查询所有数据方法 成功
- (void)findUserFinished:(NSMutableArray *)list;
// 查询所有数据方法 失败
- (void)findUserFailed:(NSError *)error;

@end

