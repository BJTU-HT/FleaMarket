//
//  SecondhandBL.m
//  FleaMarket
//
//  Created by tom555cat on 16/3/31.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "SecondhandBL.h"

@implementation SecondhandBL

- (void)createSecondhand:(SecondhandVO *)model
{
    // 创建二手商品信息
    SecondhandDAO *secondhandDAO = [SecondhandDAO sharedManager];
    secondhandDAO.delegate = self;
    [secondhandDAO create:model];
}

- (void)removeSecondhand:(SecondhandVO *)model
{
    
}

- (void)modifySecondhand:(SecondhandVO *)model
{
    
}

- (void)resetOffset
{
    SecondhandDAO *secondhandDAO = [SecondhandDAO sharedManager];
    secondhandDAO.offset = 0;
}

- (void)findSecondhand:(NSDictionary *)filterDic
{
    SecondhandDAO *secondhandDAO = [SecondhandDAO sharedManager];
    secondhandDAO.delegate = self;
    [secondhandDAO findSecondhand:filterDic];
}

- (void)findNewComming:(NSDictionary *)filterDic
{
    SecondhandDAO *secondhandDAO = [SecondhandDAO sharedManager];
    secondhandDAO.delegate = self;
    [secondhandDAO findNewComming:filterDic];
}

- (void)newVisitor:(NSString *)visitorURL secondhand:(SecondhandVO *)model
{
    SecondhandDAO *secondhandDAO = [SecondhandDAO sharedManager];
    secondhandDAO.delegate = self;
    [secondhandDAO oneMoreVisitor:visitorURL secondhand:model];
}


#pragma --mark ----------SecondhandDAODelegate 委托方法--------------

- (void)findSecondhandFinished:(NSMutableArray *)list
{
    [self.delegate findSecondhandFinished:list];
}

- (void)findSecondhandFailed:(NSError *)error
{
    [self.delegate findSecondhandFailed:error];
}

- (void)findNewCommingFinished:(NSMutableArray *)list
{
    [self.delegate findNewCommingSecondhandFinished:list];
}

- (void)findNewCommingFailed:(NSError *)error
{
    [self.delegate findNewCommingSecondhandFailed:error];
}

- (void)createSecondhandFinished
{
    [self.delegate publishSecondhandFinished];
}

- (void)createSecondhandFailed
{
    [self.delegate publishSecondhandFailed];
}


@end
