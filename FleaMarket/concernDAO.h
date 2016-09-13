//
//  concernDAO.h
//  FleaMarket
//
//  Created by Hou on 9/6/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "concernDAODelegate.h"

@interface concernDAO : NSObject

@property(nonatomic, weak)id<concernDAODelegate> delegate;
+(concernDAO *)sharedManager;
-(void)addConcernUserDAO:(NSMutableDictionary *)mudic;

//添加关注
-(void)updateConcernedDataDAO:(NSMutableDictionary *)dic;

//从用户表查找关注数据
-(void)requestConcernedDataDAO:(NSString *)objectId;

@end
