//
//  userInfoVO.m
//  FleaMarket
//
//  Created by Hou on 4/22/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "userInfoVO.h"

@implementation userInfoVO

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    userInfoVO *vo = [[userInfoVO alloc] init];
    [vo setValuesForKeysWithDictionary:dict];
    return vo;
}
@end
