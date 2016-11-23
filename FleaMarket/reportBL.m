//
//  reportBL.m
//  FleaMarket
//
//  Created by Hou on 21/11/2016.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "reportBL.h"
#import "reportDAO.h"

@implementation reportBL

static reportBL *sharedManager = nil;

+ (reportBL *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

-(void)uploadReportInfoBL:(NSDictionary *)dic{
    reportDAO *report = [reportDAO sharedManager];
    report.delegate = self;
    [report uploadReportInfoDAO:dic];
}

-(void)reportDAOFinished:(BOOL)isSuccessful{
    [self.delegate reportBLFinished:isSuccessful];
}

-(void)reportDAOFailed:(NSError *)error{
    [self.delegate reportBLFailed:error];
}

@end
