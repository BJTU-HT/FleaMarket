//
//  SecondhandMessage.m
//  FleaMarket
//
//  Created by tom555cat on 16/4/12.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "SecondhandMessageVO.h"

@implementation SecondhandMessageVO

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    SecondhandMessageVO *vo = [[SecondhandMessageVO alloc] init];
    [vo setValuesForKeysWithDictionary:dict];
    return vo;
}

@end
