//
//  concernDAO.m
//  FleaMarket
//
//  Created by Hou on 9/6/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "concernDAO.h"
#import <BmobSDK/Bmob.h>

@implementation concernDAO

static concernDAO *sharedManager;

+(concernDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

//添加关注
-(void)addConcernUserDAO:(NSMutableDictionary *)mudic{
    BmobObject *concern = [BmobObject objectWithClassName:@"concernUser"];
    [concern setObject:[mudic objectForKey:@"hostUserName"] forKey:@"hostUserName"];
    [concern setObject:[mudic objectForKey:@"concernedUserName"] forKey:@"concernedUserName"];
    
    [concern saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if(error){
            [self.delegate concernedUserUploadFailedDAO:error];
        }else{
            [self.delegate concernedUserUploadFinishedDAO:isSuccessful];
        }
    }];
}

//添加关注 用于更新数据库各个表格中的关注数组
-(void)updateConcernedDataDAO:(NSMutableDictionary *)dic{
    NSMutableArray *muArrURL = [[NSMutableArray alloc] init];
    BmobQuery *query = [[BmobQuery alloc] initWithClassName:@"_User"];
    NSString *objectID = [dic objectForKey:@"currentUserObjectId"];
    [query whereKey:@"objectId" equalTo:objectID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
        if(error){
            [self.delegate concernedUserUploadFailedDAO:error];
        }else{
            if(array.count == 0){
                NSLog(@"test12");
            }else{
                BmobObject *obj = array[0];
                if(![[obj objectForKey:@"concernedArr"] isEqual: @""])
                    [muArrURL setArray:[obj objectForKey:@"concernedArr"]];
                NSMutableDictionary *mudic1 = [[NSMutableDictionary alloc] init];
                if([dic objectForKey:@"concernedObjectId"]){
                    [mudic1 setObject:[dic objectForKey:@"concernedObjectId"] forKey:@"concernedObjectId"];
                if([dic objectForKey:@"concernedSchool"])
                    [mudic1 setObject:[dic objectForKey:@"concernedSchool"] forKey:@"concernedSchool"];
                if([dic objectForKey:@"concernedUserName"])
                    [mudic1 setObject:[dic objectForKey:@"concernedUserName"] forKey:@"concernedUserName"];
                if([dic objectForKey:@"concernedAvatar"])
                    [mudic1 setObject:[dic objectForKey:@"concernedAvatar"] forKey:@"concernedAvatar"];
                [muArrURL addObject:mudic1];
            }
            NSMutableDictionary *mudic = [[NSMutableDictionary alloc] init];
            [mudic setObject:muArrURL forKey: @"concernedArr"];
                            BmobObjectsBatch *bmobBatch = [[BmobObjectsBatch alloc] init];
                            [bmobBatch updateBmobObjectWithClassName:@"_User" objectId:objectID parameters:mudic];
                            [bmobBatch batchObjectsInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                if(isSuccessful)
                                {   //访客数据添加成功与否不做数据返回处理
                                    [self.delegate concernedUserUploadFinishedDAO:isSuccessful];
                                    NSLog(@"更新数据成功");
                                }else{
                                    [self.delegate concernedUserUploadFailedDAO:error];
                                    NSLog(@"%@", error.localizedDescription);
                                }
                            }];
//            BmobObject *objUpdate = [BmobObject objectWithoutDatatWithClassName:@"_User" objectId:objectID];
//            BmobUser *curUser = [BmobUser getCurrentUser];
//            [objUpdate addObjectsFromArray:muArrURL forKey:@"concernedArr"];
//            [objUpdate updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//                if(isSuccessful)
//                {   //访客数据添加成功与否不做数据返回处理
//                    [self.delegate concernedUserUploadFinishedDAO:isSuccessful];
//                    NSLog(@"更新数据成功");
//                }else{
//                    [self.delegate concernedUserUploadFailedDAO:error];
//                    NSLog(@"%@", error.localizedDescription);
//                }
//            }];

        }
    }
  }];
}

//            BmobObjectsBatch *bmobBatch = [[BmobObjectsBatch alloc] init];
//            [bmobBatch updateBmobObjectWithClassName:@"_User" objectId:objectID parameters:mudic];
//            [bmobBatch batchObjectsInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//                if(isSuccessful)
//                {   //访客数据添加成功与否不做数据返回处理
//                    [self.delegate concernedUserUploadFinishedDAO:isSuccessful];
//                    NSLog(@"更新数据成功");
//                }else{
//                    [self.delegate concernedUserUploadFailedDAO:error];
//                    NSLog(@"%@", error.localizedDescription);
//                }
//            }];
-(void)requestConcernedDataDAO:(NSString *)objectId{
    BmobQuery *query = [[BmobQuery alloc] initWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if(error){
            [self.delegate concernedDataRequestFailedDAO:error];
        }else{
            if(array.count == 0){
                [self.delegate cocnernedDataRequestNODataDAO: 1];
            }else{
                BmobObject *obj = array[0];
                if(![[obj objectForKey:@"concernedArr"] isEqual: @""]){
                    [self.delegate concernedDataRequestFinishedDAO:[obj objectForKey:@"concernedArr"]];
                }else{
                    [self.delegate cocnernedDataRequestNODataDAO: 1];
                }
            }
        }
            
    }];
}

@end
