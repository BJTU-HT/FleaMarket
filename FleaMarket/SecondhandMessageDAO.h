//
//  SecondhandMessageDAO.h
//  FleaMarket
//
//  Created by tom555cat on 16/4/12.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondhandMessageDAODelegate.h"
#import "SecondhandMessageVO.h"

@interface SecondhandMessageDAO : NSObject

// 保存数据列表
@property (nonatomic, strong) NSMutableArray *listData;

// 分页查询的偏置量
@property (nonatomic, assign) NSInteger readSkip;

@property (nonatomic, weak) id <SecondhandMessageDAODelegate> delegate;

// 插入评论
- (void)createMessage:(SecondhandMessageVO *)model;

// 查询评论
- (void)findSecondhandMessage:(NSString *)productID;

+ (SecondhandMessageDAO *)sharedManager;

@end
