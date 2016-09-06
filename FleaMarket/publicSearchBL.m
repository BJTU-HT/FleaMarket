//
//  publicSearchBL.m
//  FleaMarket
//
//  Created by Hou on 8/8/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "publicSearchBL.h"
#import "publicSearchDAO.h"
@implementation publicSearchBL

static publicSearchBL *sharedManager;

+(publicSearchBL *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

-(void)getUserTableInfoBL:(NSString *)userPara{
    publicSearchDAO *psd = [publicSearchDAO sharedManager];
    psd.delegatePS = self;
    [psd getUserTableInfoDAO:userPara];
}

-(void)publicSearchFinishedDAO:(NSMutableDictionary *)mudicPS{
    [self.delegatePSBL publicSearchFinishedBL:mudicPS];
}

-(void)publicSearchFinishedNODataDAO:(BOOL)val{
    [self.delegatePSBL publicSearchFinishedNODataBL:val];
}

-(void)publicSearchFailedDAO:(NSError *)error{
    [self.delegatePSBL publicSearchFailedBL:error];
}

//leave message
-(void)leaveMessageRequestBL:(NSDictionary *)dic{
    publicSearchDAO *psd = [publicSearchDAO sharedManager];
    psd.delegatePS = self;
    [psd leaveMessageRequestDAO:dic];
}

-(void)leaveMesFinishedDAO:(NSString *)headURL{
    [self.delegatePSBL leaveMesFinishedBL:headURL];
}
-(void)leaveMesFailedDAO:(NSError *)error{
    [self.delegatePSBL leaveMesFailedBL:error];
}

//请求留言数据
-(void)getLeaveMessageFromServerBL:(NSString *)objectId{
    publicSearchDAO *psd = [publicSearchDAO sharedManager];
    psd.delegatePS = self;
    [psd getLeaveMessageFromServerDAO: objectId];
}

-(void)returnLeaveMessageFinishedDAO:(NSMutableArray *)muArrLM{
    [self.delegatePSBL returnLeaveMessageFinishedBL:muArrLM];
}
@end
