//
//  dataDic.h
//  FleaMarket
//
//  Created by Hou on 7/29/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dataDic : NSObject

@property(strong, nonatomic) NSMutableDictionary *schoolMuDic;

+(NSMutableDictionary *)readDic;
@end
