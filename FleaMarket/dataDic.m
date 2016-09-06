//
//  dataDic.m
//  FleaMarket
//
//  Created by Hou on 7/29/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "dataDic.h"

@implementation dataDic

+(NSMutableDictionary *)readDic{
    NSMutableDictionary *schoolMuDic = [[NSMutableDictionary alloc] init];
    NSArray *bjSchoolArr = @[@"北京所有高校", @"北京大学",@"中国人民大学", @"清华大学",@"北京交通大学",@"北京航空航天大学",@"北京理工大学",@"北京科技大学",@"北京化工大学",@"北京邮电大学",@"华北电力大学",@"中国石油大学(北京)",@"中国矿业大学(北京)",@"中国地质大学(北京)",@"中国农业大学",@"北京林业大学",@"北京中医药大学",@"北京师范大学",@"北京外国语大学",@"北京语言大学",@"中国传媒大学",@"中央财经大学",@"对外经济贸易大学",@"中国人民公安大学",@"中国政法大学", @"北京体育大学",@"中央民族大学",@"北京电子科技学院",@"北京协和医学院",@"外交学院",@"中华女子学院",@"国际关系学院",@"中国青年政治学院",@"中国劳动关系学院",@"中央音乐学院",@"中央美术学院",@"中央戏剧学院",@"北京联合大学",@"北京工业大学",@"北方工业大学",@"北京信息科技大学",@"首都医科大学",@"首都师范大学",@"北京工商大学",@"首都经济贸易大学",@"北京城市学院",@"北京服装学院",@"北京印刷学院",@"北京建筑大学",@"北京石油化工学院",@"北京第二外国语学院"];
    NSArray *shSchoolArr = @[@"上海所有高校", @"复旦大学", @"上海交通大学"];
    [schoolMuDic setObject:bjSchoolArr forKey:@"北京"];
    [schoolMuDic setObject:shSchoolArr forKey:@"上海"];
    return schoolMuDic;
}
@end
