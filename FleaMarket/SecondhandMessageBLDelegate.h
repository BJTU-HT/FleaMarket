//
//  SecondhandMessageBLDelegate.h
//  FleaMarket
//
//  Created by tom555cat on 16/4/13.
//  Copyright © 2016年 H-T. All rights reserved.
//

#ifndef SecondhandMessageBLDelegate_h
#define SecondhandMessageBLDelegate_h

#import "SecondhandMessageVO.h"

@protocol SecondhandMessageBLDelegate

@optional

// 查询一个二手商品对应的所有评论
- (void)findSecondhandMessageFinished:(NSMutableArray *)list;
- (void)findSecondhandMessageFailed:(NSError *)error;

- (void)insertCommentFinished:(SecondhandMessageVO *)model;
- (void)insertCommentFailed:(NSError *)error;

@end

#endif /* SecondhandMessageBLDelegate_h */
