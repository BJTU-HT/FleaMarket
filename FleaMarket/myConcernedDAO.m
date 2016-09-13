//
//  myConcernedDAO.m
//  FleaMarket
//
//  Created by Hou on 9/12/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "myConcernedDAO.h"
#import <BmobSDK/BmobQuery.h>

@implementation myConcernedDAO

static myConcernedDAO *sharedManager;

+(myConcernedDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

//我的模块 我的关注查询
-(void)requestMyConcernedConcretedDAO:(NSString *)objectId{
    BmobQuery *query = [[BmobQuery alloc] initWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
        if(error){
            [self.delegate myConcernedDataRequestFailedDAO:error];
        }else{
            if(array.count == 0){
                [self.delegate myCocnernedDataRequestNODataDAO: 1];
            }else{
                BmobObject *obj = array[0];
                [self.delegate myConcernedDataRequestFinishedDAO:[obj objectForKey:@"concernedArr"]];
            }
        }
    }];
}
@end
