//
//  dataDic.m
//  FleaMarket
//
//  Created by Hou on 7/29/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "dataDic.h"

@implementation dataDic

-(NSMutableDictionary *)readDic{
    [self testLeftArray];
    [self testRightArray];
    NSMutableDictionary *schoolMuDic = [[NSMutableDictionary alloc] init];
    for(int i = 0; i < _leftArray.count ; i++){
        NSString *str = _leftArray[i];
        NSArray *arrTemp = _rightArray[i];
        NSMutableArray *rightArrTemp = [[NSMutableArray alloc] init];
        [rightArrTemp removeAllObjects];
        for(int j = 0; j < arrTemp.count; j++){
            [rightArrTemp addObject:[arrTemp[j] objectForKey:@"title"]];
        }
        NSString *str1 = str;
        str1 = [str1 stringByAppendingString:@"所有高校"];
        if([rightArrTemp count]){
            [rightArrTemp insertObject:str1 atIndex:0];
            [schoolMuDic setObject:rightArrTemp forKey:str];
        }
    }
    return schoolMuDic;
}

//左边列表可为空，则为单下拉菜单，可以根据需要传参
- (void)testLeftArray {
    NSArray *One_leftArray = @[@"北京", @"上海", @"天津", @"重庆", @"河北",@"山西",@"内蒙古",@"辽宁",@"吉林",@"黑龙江",@"江苏",@"浙江",@"安徽",@"福建",@"江西",@"山东",@"河南",@"湖北",@"湖南",@"广东",@"广西",@"四川",@"云南",@"贵州",@"陕西",@"甘肃",@"新疆",@"海南",@"宁夏",@"青海",@"西藏"];
    if(!_leftArray){
        _leftArray = [[NSMutableArray alloc] init];
    }
    [_leftArray setArray: One_leftArray];
}

//右边列表不可为空
- (void)testRightArray {
    NSArray *F_rightArray = @[
                              @[
                                  @{@"title":@"清华大学"},
                                  @{@"title":@"北京大学"},
                                  @{@"title":@"中国人民大学"},
                                  @{@"title":@"北京工业大学"},
                                  @{@"title":@"北京理工大学"},
                                  @{@"title":@"北京航空航天大学"},
                                  @{@"title":@"北京化工大学"},
                                  @{@"title":@"北京邮电大学"},
                                  @{@"title":@"对外经济贸易大学"},
                                  @{@"title":@"中国传媒大学"},
                                  @{@"title":@"中央名族大学"},
                                  @{@"title":@"中国矿业大学(北京)"},
                                  @{@"title":@"中央财经大学"},
                                  @{@"title":@"中国政法大学"},
                                  @{@"title":@"中国石油大学(北京)"},
                                  @{@"title":@"中央音乐学院"},
                                  @{@"title":@"北京体育大学"},
                                  @{@"title":@"北京外国语大学"},
                                  @{@"title":@"北京交通大学"},
                                  @{@"title":@"北京科技大学"},
                                  @{@"title":@"北京林业大学"},
                                  @{@"title":@"中国农业大学"},
                                  @{@"title":@"北京中医药大学"},
                                  @{@"title":@"华北电力大学(北京)"},
                                  @{@"title":@"北京师范大学"},
                                  @{@"title":@"中国地质大学(北京)"},
                                  ] ,
                              @[
                                  @{@"title":@"复旦大学"},
                                  @{@"title":@"华东师范大学"},
                                  @{@"title":@"上海外国语大学"},
                                  @{@"title":@"上海大学"},
                                  @{@"title":@"同济大学"},
                                  @{@"title":@"华东理工大学"},
                                  @{@"title":@"东华大学"},
                                  @{@"title":@"上海财经大学"},
                                  @{@"title":@"上海交通大学"},
                                  ],
                              @[
                                  @{@"title":@"南开大学"},
                                  @{@"title":@"天津大学"},
                                  @{@"title":@"天津医科大学"},
                                  ],
                              @[
                                  @{@"title":@"重庆大学"},
                                  @{@"title":@"西南大学"},
                                  ],
                              @[
                                  @{@"title":@"华北电力大学(保定)"},
                                  @{@"title":@"河北工业大学"},
                                  ],
                              @[
                                  @{@"title":@"太原理工大学"},
                                  ],
                              @[
                                  @{@"title":@"内蒙古大学"},
                                  ],
                              @[
                                  @{@"title":@"大连理工大学"},
                                  @{@"title":@"东北大学"},
                                  @{@"title":@"辽宁大学"},
                                  @{@"title":@"大连海事大学"},
                                  ],
                              @[
                                  @{@"title":@"吉林大学"},
                                  @{@"title":@"东北师范大学"},
                                  @{@"title":@"延边大学"},
                                  ],
                              @[
                                  @{@"title":@"哈尔滨理工大学"},
                                  @{@"title":@"东北农业大学"},
                                  @{@"title":@"东北林业大学"},
                                  @{@"title":@"哈尔滨工业大学"},
                                  @{@"title":@"哈尔滨工程大学"},
                                  ],
                              @[
                                  @{@"title":@"南京大学"},
                                  @{@"title":@"东南大学"},
                                  @{@"title":@"江苏大学"},
                                  @{@"title":@"河海大学"},
                                  @{@"title":@"中国医科大学"},
                                  @{@"title":@"中国矿业大学(徐州)"},
                                  @{@"title":@"南京师范大学"},
                                  @{@"title":@"南京理工大学"},
                                  @{@"title":@"南京航空航天大学"},
                                  @{@"title":@"江南大学"},
                                  @{@"title":@"南京农业大学"},
                                  ],
                              @[
                                  @{@"title":@"浙江大学"},
                                  ],
                              @[
                                  @{@"title":@"安徽大学"},
                                  @{@"title":@"合肥工业大学"},
                                  @{@"title":@"中国科技大学"},
                                  ],
                              @[
                                  @{@"title":@"厦门大学"},
                                  @{@"title":@"福州大学"},
                                  ],
                              @[
                                  @{@"title":@"南昌大学"},
                                  ],
                              @[
                                  @{@"title":@"山东大学"},
                                  @{@"title":@"中国海洋大学"},
                                  @{@"title":@"中国石油大学(华东)"},
                                  ],
                              @[
                                  @{@"title":@"郑州大学"},
                                  ],
                              @[
                                  @{@"title":@"武汉大学"},
                                  @{@"title":@"华中科技大学"},
                                  @{@"title":@"中国地质大学(武汉)"},
                                  @{@"title":@"华中师范大学"},
                                  @{@"title":@"华中农业大学"},
                                  @{@"title":@"中南财经大学"},
                                  @{@"title":@"武汉理工大学"},
                                  ],
                              @[
                                  @{@"title":@"湖南大学"},
                                  @{@"title":@"中南大学"},
                                  @{@"title":@"湖南师范大学"},
                                  ],
                              @[
                                  @{@"title":@"中山大学"},
                                  @{@"title":@"暨南大学"},
                                  @{@"title":@"华南理工大学"},
                                  @{@"title":@"华南师范大学"},
                                  ],
                              @[
                                  @{@"title":@"广西大学"},
                                  ],
                              @[
                                  @{@"title":@"四川大学"},
                                  @{@"title":@"西南交通大学"},
                                  @{@"title":@"电子科技大学"},
                                  @{@"title":@"西南财经大学"},
                                  @{@"title":@"四川农业大学"},
                                  ],
                              @[
                                  @{@"title":@"云南大学"},
                                  ],
                              @[
                                  @{@"title":@"贵州大学"},
                                  ],
                              @[
                                  @{@"title":@"西北大学"},
                                  @{@"title":@"西安交通大学"},
                                  @{@"title":@"西北工业大学"},
                                  @{@"title":@"陕西师范大学"},
                                  @{@"title":@"西北农林科大"},
                                  @{@"title":@"西安电子科技大学"},
                                  @{@"title":@"长安大学"},
                                  ],
                              @[
                                  @{@"title":@"兰州大学"},
                                  ],
                              @[
                                  @{@"title":@"新疆大学"},
                                  @{@"title":@"石河子大学"},
                                  ],
                              @[
                                  @{@"title":@"海南大学"},
                                  ],
                              @[
                                  @{@"title":@"宁夏大学"},
                                  ],
                              @[
                                  @{@"title":@"青海大学"},
                                  ],
                              @[
                                  @{@"title":@"西藏大学"},
                                  ]                              ];
    
//    NSArray *S_rightArray = @[
//                              @[
//                                  @{@"title":@"one"},
//                                  @{@"title":@"two"},
//                                  @{@"title":@"three"}
//                                  ] ,
//                              @[
//                                  @{@"title":@"four"}
//                                  ]
//                              ];
    
    //_rightArray = [[NSArray alloc] initWithObjects:F_rightArray, S_rightArray, nil];
    if(!_rightArray){
        _rightArray = [[NSMutableArray alloc] init];
    }
    [_rightArray setArray: F_rightArray];
}
@end
