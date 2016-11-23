//
//  reportDAO.m
//  FleaMarket
//
//  Created by Hou on 21/11/2016.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "reportDAO.h"
#import <BmobSDK/Bmob.h>

@implementation reportDAO

static reportDAO *sharedManager = nil;

+ (reportDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

-(void)uploadReportInfoDAO:(NSDictionary *)dic{
    BmobObject *obj = [[BmobObject alloc] initWithClassName:@"reportUnhealthy"];
    if([dic objectForKey:@"productId"]){
        [obj setObject:[dic objectForKey:@"productId"] forKey:@"productId"];
    }
    if([dic objectForKey:@"reporterId"]){
        [obj setObject:[dic objectForKey:@"reporterId"] forKey:@"reporterId"];
    }
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if(isSuccessful){
            [self.delegate reportDAOFinished:isSuccessful];
        }else{
            [self.delegate reportDAOFailed:error];
        }
    }];
}
@end
