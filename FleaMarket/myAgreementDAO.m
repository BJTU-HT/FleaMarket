//
//  myAgreementDAO.m
//  FleaMarket
//
//  Created by Hou on 17/11/2016.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "myAgreementDAO.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobQuery.h>

@implementation myAgreementDAO
static myAgreementDAO *sharedManager;

+(myAgreementDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

-(void)requestAgreementFromSeverDAO{
    BmobQuery *query = [BmobQuery queryWithClassName:@"userAgreement"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if(error){
            [self.delegate myAgreementDataRequestFailedDAO:error];
        }else{
            if(![array count]){
                [self.delegate myAgreementDataRequestNODataDAO:[array count]];
            }else{
                NSString *str = [array[0] objectForKey:@"agreement"];
                NSMutableDictionary *mudic = [[NSMutableDictionary alloc] init];
                [mudic setObject:str forKey:@"agreement"];
                [self.delegate myAgreementDataRequestFinishedDAO: mudic];
            }
        }
    }];
}

@end
