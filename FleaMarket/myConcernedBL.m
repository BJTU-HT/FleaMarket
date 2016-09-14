//
//  myConcernedBL.m
//  FleaMarket
//
//  Created by Hou on 9/12/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "myConcernedBL.h"

@implementation myConcernedBL

static myConcernedBL *sharedManager;

+(myConcernedBL *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

//请求我的关注数据
-(void)requestMyConcernedConcretedBL:(NSString *)objectId{
    myConcernedDAO *myConDAO = [myConcernedDAO sharedManager];
    myConDAO.delegate = self;
    [myConDAO requestMyConcernedConcretedDAO:objectId];
}

#pragma 请求我的关注数据代理方法 begin
-(void)myConcernedDataRequestFinishedDAO:(NSArray *)arr{
    [self.delegate myConcernedDataRequestFinishedBL:arr];
}

-(void)myConcernedDataRequestFailedDAO:(NSError *)error{
    [self.delegate myConcernedDataRequestFailedBL:error];
}

-(void)myCocnernedDataRequestNODataDAO:(BOOL)value{
    [self.delegate myCocnernedDataRequestNODataBL:value];
}
#pragma 请求我的关注数据代理方法 end

@end
