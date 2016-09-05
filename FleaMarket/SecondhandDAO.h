//
//  SecondhandDAO.h
//  FleaMarket
//
//  Created by tom555cat on 16/3/31.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondhandVO.h"
#import "SecondhandDAODelegate.h"

@interface SecondhandDAO : NSObject

// 保存数据列表
@property (nonatomic, strong) NSMutableArray *listData;

@property (weak, nonatomic) id <SecondhandDAODelegate> delegate;

// 每次进行分页查询时的偏移量
@property (nonatomic, assign) NSInteger offset;

// 首次载入的二手商品的创建时间，为了刷新新数据
@property (nonatomic, strong) NSDate *lastestTime;

// 插入Secondhand方法
- (void)create:(SecondhandVO *)model;

// 修改Secondhand方法
- (void)modify:(SecondhandVO *)model;

// 删除Secondhand方法
- (void)remove:(SecondhandVO *)model;

// 查询，filterDic字典键为字段，值为过滤值
- (void)findSecondhand:(NSDictionary *)filterDic;

// 查询新增加的商品，filterDic字典键为字段，值为过滤值
- (void)findNewComming:(NSDictionary *)filterDic;

// 新增来访
- (void)oneMoreVisitor:(NSString *)visitorURL
            secondhand:(SecondhandVO *)model;

+ (SecondhandDAO *)sharedManager;




@end
