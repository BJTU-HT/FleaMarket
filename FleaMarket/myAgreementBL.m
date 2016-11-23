//
//  myAgreementBL.m
//  FleaMarket
//
//  Created by Hou on 17/11/2016.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "myAgreementBL.h"
#import "myAgreementDAO.h"

@implementation myAgreementBL
static myAgreementBL *sharedManager;

+(myAgreementBL *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

-(void)requestAgreementFromSeverBL{
    myAgreementDAO *myDAO = [myAgreementDAO sharedManager];
    myDAO.delegate = self;
    [myDAO requestAgreementFromSeverDAO];
}

-(void)myAgreementDataRequestFinishedDAO:(NSMutableDictionary *)mudic{
    [self.delegate myAgreementDataRequestFinishedBL:mudic];
}

-(void)myAgreementDataRequestFailedDAO:(NSError *)error{
    [self.delegate myAgreementDataRequestFailedBL:error];
}

-(void)myAgreementDataRequestNODataDAO:(BOOL)value{
    [self.delegate myAgreementDataRequestNODataBL:value];
}

@end
