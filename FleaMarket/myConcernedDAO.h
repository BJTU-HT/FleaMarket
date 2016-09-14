//
//  myConcernedDAO.h
//  FleaMarket
//
//  Created by Hou on 9/12/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "myConcernedDAODelegate.h"

@interface myConcernedDAO : NSObject

@property(nonatomic, strong) id<myConcernedDAODelegate> delegate;

+(myConcernedDAO *)sharedManager;
//我的模块 我的关注查询
-(void)requestMyConcernedConcretedDAO:(NSString *)objectId;
@end
