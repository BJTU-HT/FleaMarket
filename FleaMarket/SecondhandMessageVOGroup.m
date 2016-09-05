//
//  SecondhandMessageVOGroup.m
//  FleaMarket
//
//  Created by tom555cat on 16/4/13.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "SecondhandMessageVOGroup.h"
#import "SecondhandMessageVO.h"

@implementation SecondhandMessageVOGroup

+ (NSMutableArray *)groupWithNameOfContent:(NSString *)name
{
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
    
    for (NSDictionary *dic in arr) {
        SecondhandMessageVO *vo = [SecondhandMessageVO modelWithDict:dic];
        [dataArr addObject:vo];
    }
    
    return dataArr;
}

@end
