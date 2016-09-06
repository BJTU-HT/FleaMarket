//
//  mySellBL.m
//  FleaMarket
//
//  Created by Hou on 8/24/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "mySellBL.h"
#import "mySellDAO.h"

@implementation mySellBL
static mySellBL *sharedManager = nil;

+(mySellBL *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

-(void)getSellGoodsInfoBL:(NSString *)userName{
    mySellDAO *myDAO = [mySellDAO sharedManager];
    myDAO.delegate = self;
    [myDAO getSellGoodsInfoDAO:userName];
}


-(void)sellGoodsInfoSearchFinishedDAO:(NSMutableArray *)arr{
    [self.delegate sellGoodsInfoSearchFinishedBL:arr];
}

-(void)sellGoodsInfoSearchFailedDAO:(NSError *)error{
    [self.delegate sellGoodsInfoSearchFailedBL:error];
}

-(void)sellGoodsInfoSearchFinishedNoDataDAO:(BOOL)value{
    [self.delegate sellGoodsInfoSearchFinishedNoDataBL:value];
}

@end
