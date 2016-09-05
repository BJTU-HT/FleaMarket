//
//  SecondhandVO.m
//  FleaMarket
//
//  Created by tom555cat on 16/3/31.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "SecondhandVO.h"

@implementation SecondhandVO

+(instancetype)modelWithDict:(NSDictionary *)dict
{
    SecondhandVO *vo = [[SecondhandVO alloc] init];
    [vo setValuesForKeysWithDictionary:dict];
    return vo;
}

@end
