//
//  bookPubUpLoadInfo.m
//  FleaMarket
//
//  Created by Hou on 7/27/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "bookPubUpLoadInfoDAO.h"
#import <BmobSDK/Bmob.h>

@implementation bookPubUpLoadInfoDAO
static bookPubUpLoadInfoDAO *sharedManager = nil;

+(bookPubUpLoadInfoDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

-(void)uploadInfoDAO:(NSMutableDictionary *)mutDic{
    switch ([[mutDic objectForKey:@"status"] integerValue]) {
        case 0:
            _requestStatus = @"sell";
            break;
        case 1:
            _requestStatus = @"buy";
            break;
        case 2:
            _requestStatus = @"borrow";
            break;
        case 3:
            _requestStatus = @"present";
            break;
        default:
            break;
    }
    NSData *imageData = UIImageJPEGRepresentation([[mutDic objectForKey: _requestStatus] objectForKey:@"bookImage"], 0.5);
    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys: @"bookImage.png", @"filename", imageData, @"data",nil];
    NSArray *array = @[dic1];
    [BmobFile filesUploadBatchWithDataArray:array progressBlock:^(int index, float progress) {
        
        NSLog(@"index %lu progress %f",(unsigned long)index,progress);
    } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
        if(error){
            [self.delegateBookPub uploadPicFailDAO:error];
        }else if(isSuccessful){
            BmobFile *file1 = [array objectAtIndex:0];
            self.pubBookImageURL = file1.url;
            BmobObject *bmObj = [self createBmobObjectTable: _requestStatus mutableDic:[mutDic objectForKey:_requestStatus]];
            [bmObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if(isSuccessful){
                    [self.delegateBookPub uploadBookInfoFinishedDAO:isSuccessful];
                }else{
                    [self.delegateBookPub uploadPicFailDAO:error];
                }
            }];
        }
    }];
}

-(BmobObject *)createBmobObjectTable: (NSString *)tableName mutableDic: (NSMutableDictionary *)dic{
    BmobObject *obj = [BmobObject objectWithClassName:tableName];
    if([tableName isEqualToString:@"sell"]){
        [obj setObject:[dic objectForKey:@"sellPrice"] forKey:@"sellPrice"];
    }else if([tableName isEqualToString:@"buy"]){
        [obj setObject:[dic objectForKey:@"buyPrice"] forKey:@"buyPrice"];
    }else if([tableName isEqualToString:@"borrow"]){
        [obj setObject:[dic objectForKey:@"lostPay"] forKey:@"borrowPrice"];
    }
    [obj setObject:[dic objectForKey:@"userName"] forKey:@"userName"];
    [obj setObject:[dic objectForKey:@"bookName"] forKey:@"bookName"];
    [obj setObject:[dic objectForKey:@"author"] forKey:@"author"];
    [obj setObject:[dic objectForKey:@"pressHouse"] forKey:@"pressHouse"];
    [obj setObject:[dic objectForKey:@"originalPrice"] forKey:@"originalPrice"];
    [obj setObject:[dic objectForKey:@"category"] forKey:@"category"];
    [obj setObject:[dic objectForKey:@"amount"] forKey:@"amount"];
    [obj setObject:[dic objectForKey:@"depreciate"] forKey:@"depreciate"];
    [obj setObject:[dic objectForKey:@"remark"] forKey:@"remark"];
    [obj setObject:self.pubBookImageURL forKey:@"bookImageURL"];
    return obj;
}
@end
