//
//  SecondhandBL.h
//  FleaMarket
//
//  Created by tom555cat on 16/3/31.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondhandBLDelegate.h"
#import "SecondhandDAODelegate.h"
#import "SecondhandDAO.h"

@interface SecondhandBL : NSObject <SecondhandDAODelegate>

@property (weak, nonatomic) id <SecondhandBLDelegate> delegate;

- (void)createSecondhand:(SecondhandVO *)model;

- (void)removeSecondhand:(SecondhandVO *)model;

- (void)modifySecondhand:(SecondhandVO *)model;

// 查询二手商品
// filterDic字典中键为字段，值为过滤比较值
- (void)findSecondhand:(NSDictionary *)filterDic;

// 刷新数据，filterDic字典中键为字段，值为过滤比较值
- (void)findNewComming:(NSDictionary *)filterDic;

// 新增来访者
- (void)newVisitor:(NSString *)visitorURL
        secondhand:(SecondhandVO *)model;

// 重置分页查询偏移量
- (void)resetOffset;

@end
