//
//  SecondhandMessageBL.h
//  FleaMarket
//
//  Created by tom555cat on 16/4/13.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondhandMessageBLDelegate.h"
#import "SecondhandMessageDAODelegate.h"
#import "SecondhandMessageDAO.h"

@interface SecondhandMessageBL : NSObject <SecondhandMessageDAODelegate>

@property (weak, nonatomic) id <SecondhandMessageBLDelegate> delegate;

// 根据二手商品id查询一个二手商品的评论
- (void)findSecondhandMessage:(NSString *)productID;

// 创建新评论
- (void)createComment:(SecondhandMessageVO *)model;

// 重置分页查询偏移量
- (void)reset;

@end
