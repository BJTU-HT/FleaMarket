//
//  VOGroup.m
//  FleaMarket
//
//  Created by tom555cat on 16/4/3.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "VOGroup.h"
#import "SecondhandVO.h"

@implementation VOGroup

+(NSMutableArray *)groupWithNameOfContent:(NSString *)name
{
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
    
    for (NSDictionary *dic in arr) {
        SecondhandVO *vo = [SecondhandVO modelWithDict:dic];
        [dataArr addObject:vo];
    }
    
    return dataArr;
}

@end
