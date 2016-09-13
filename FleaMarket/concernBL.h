//
//  concernBL.h
//  FleaMarket
//
//  Created by Hou on 9/6/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "concernBLDelegate.h"
#import "concernDAODelegate.h"

@interface concernBL : NSObject<concernDAODelegate>

@property(nonatomic, weak)id<concernBLDelegate> delegate;
+(concernBL *)sharedManager;
-(void)addConcernUserBL:(NSMutableDictionary *)mudic;
-(void)updateConcernedDataBL:(NSMutableDictionary *)dic;

//从用户表查找关注数据
-(void)requestConcernedDataBL:(NSString *)objectId;
@end
