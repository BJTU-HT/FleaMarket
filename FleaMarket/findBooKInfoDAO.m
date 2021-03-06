//
//  findBooKInfoDAO.m
//  FleaMarket
//
//  Created by Hou on 8/1/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "findBooKInfoDAO.h"
#import <BmobSDK/BmobQuery.h>
#import <BmobSDK/Bmob.h>

@implementation findBooKInfoDAO
static findBooKInfoDAO *sharedManager;
NSMutableArray *muArrURL;

+(findBooKInfoDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
        sharedManager.bookOffset = 0;
        sharedManager.bookOffsetUp = 0;
    });
    return sharedManager;
}

#pragma uploadInfo begin
-(void)updateVisitorDataDAO:(NSMutableDictionary *)dic{
    NSString *strExchangeCate = [dic objectForKey:@"exchangeCategory"];
    //BmobQuery *query = [[BmobQuery alloc] initWithClassName:strExchangeCate];
    NSString *objectID = [dic objectForKey:@"objectId"];
    BmobObject *obj = [BmobObject objectWithoutDatatWithClassName:strExchangeCate objectId:objectID];
    [obj setObject:[dic objectForKey:@"visitorURLArr"] forKey:@"visitorURLArr"];
    [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"更新成功");
            
        }else{
            NSLog(@"更新失败");
        }
    }];
}

#pragma uploadInfo end

#pragma findBookInfo begin
-(void)downDragGetDataFromDAO:(NSDictionary *)dic{
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    NSMutableArray *constraintArr = [[NSMutableArray alloc] init];
    NSString *strExchange = [dic objectForKey:@"exchangeCategory"];
    BmobQuery *query = [[BmobQuery alloc] initWithClassName:strExchange];
    if (self.bookLastestTime) {
        [query whereKey:@"createdAt" greaterThan:self.bookLastestTime];
    }
    for(NSString *key in [dic allKeys]){
        if([key isEqualToString:@"university"]){
            [constraintArr setValue:dic[key] forKey:@"school"];
            [query whereKey:@"school" equalTo:dic[key]];
        }
        if([key isEqualToString:@"bookCategory"]){
            [constraintArr setValue:dic[key] forKey:@"category"];
            [query whereKey:@"category" equalTo:dic[key]];
        }
    }
    query.limit = pageOffset;
    query.skip = _bookOffsetUp;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if(error){
            [self.delegate searchBookInfoFailedDAO:error];
        }else{
            if(array.count == 0){
                [self.delegate searchBookInfoFinishedNODataDAO:@"当前页面数据已是最新"];
            }else{
                for(int i = 0; i < array.count; i++){
                    BmobObject *obj = [array objectAtIndex:i];
                    [muArr addObject:[self objToDic:obj]];
                }
                [muArr addObject:@"downDrag"];
                [self.delegate searchBookInfoFinishedDAO:muArr];
            }
        }
    }];
    _bookOffsetUp += pageOffset;
}

//上拉获取数据
-(void)getBookDataFromBmobDAO:(NSDictionary *)dic{
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    NSString *strExchange = [dic objectForKey:@"exchangeCategory"];
    BmobQuery *query = [[BmobQuery alloc] initWithClassName:strExchange];
    for(NSString *key in [dic allKeys]){
        if([key isEqualToString:@"university"]){
            if([dic[key] isKindOfClass:[NSArray class]]){
                [query whereKey:@"school" containedIn:dic[key]];
            }else{
                [query whereKey:@"school" equalTo:dic[key]];
            }
        }
        if([key isEqualToString:@"bookCategory"]){
            [query whereKey:@"category" equalTo:dic[key]];
        }
    }
    query.limit = pageOffset;
    query.skip = _bookOffset;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if(error){
            [self.delegate searchBookInfoFailedDAO:error];
        }else{
            if(array.count == 0){
                if(_bookOffset == 0){
                   [self.delegate searchBookInfoFinishedNODataDAO:@"服务器无数据"];
                }else{
                    [self.delegate searchBookInfoFinishedNODataDAO:@"没有更多数据"];
                }
            }else{
                for(int i = 0; i < array.count; i++){
                    BmobObject *obj = [array objectAtIndex:i];
                    [muArr addObject:[self objToDic:obj]];
                }
                [self.delegate searchBookInfoFinishedDAO:muArr];
                // 记录最新二手商品的创建时间
                if (array.count) {
                    NSString *dateStr = [array[0] objectForKey:@"createdAt"];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    self.bookLastestTime = [[NSDate date] initWithTimeInterval:1 sinceDate:[formatter dateFromString:dateStr]];
                }
                _bookOffset += pageOffset;
            }
        }
    }];
}

//通过书名搜索数据
-(void)getBookDataAccordBookNameFromBmobDAO:(NSDictionary *)dic{
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    NSString *strExchange = [dic objectForKey:@"exchangeCategory"];
    BmobQuery *query = [[BmobQuery alloc] initWithClassName:strExchange];
    for(NSString *key in [dic allKeys]){
        if([key isEqualToString:@"bookName"]){
            [query whereKey:@"bookName" equalTo:dic[key]];
        }
    }
    query.limit = pageOffset;
    //query.skip = _bookOffset;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
        if(error){
            [self.delegate searchBookInfoFailedDAO:error];
        }else{
            if(array.count == 0){
                [self.delegate searchBookInfoFinishedNODataDAO:@"没有您所需要的数据"];
            }else{
                for(int i = 0; i < array.count; i++){
                    BmobObject *obj = [array objectAtIndex:i];
                    [muArr addObject:[self objToDic:obj]];
                }
                [self.delegate searchBookInfoFromSearchDAO:muArr];
                //[self.delegate searchBookInfoFinishedDAO:muArr];
                // 记录最新二手商品的创建时间
                if(array.count) {
                    NSString *dateStr = [array[0] objectForKey:@"createdAt"];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    self.bookLastestTime = [[NSDate date] initWithTimeInterval:1 sinceDate:[formatter dateFromString:dateStr]];
                }
                _bookOffset += pageOffset;
            }
        }
    }];
}

-(NSMutableDictionary *)objToDic:(BmobObject *)obj{
    NSMutableDictionary *mudic = [[NSMutableDictionary alloc] init];
    if([obj objectForKey:@"author"])
        [mudic setObject:[obj objectForKey:@"author"] forKey:@"author"];
    if([obj objectForKey:@"depreciate"])
        [mudic setObject:[obj objectForKey:@"depreciate"] forKey:@"depreciate"];
    if([obj objectForKey:@"pressHouse"])
        [mudic setObject:[obj objectForKey:@"pressHouse"] forKey:@"pressHouse"];
    if([obj objectForKey:@"remark"])
        [mudic setObject:[obj objectForKey:@"remark"] forKey:@"remark"];
    if([obj objectForKey:@"sellPrice"])
        [mudic setObject:[obj objectForKey:@"sellPrice"] forKey:@"sellPrice"];
    if([obj objectForKey:@"buyPrice"])
        [mudic setObject:[obj objectForKey:@"buyPrice"] forKey:@"buyPrice"];
    if([obj objectForKey:@"borrowPrice"])
        [mudic setObject:[obj objectForKey:@"borrowPrice"] forKey:@"borrowPrice"];
    if([obj objectForKey:@"userName"])
        [mudic setObject:[obj objectForKey:@"userName"] forKey:@"userName"];
    if([obj objectForKey:@"amount"])
        [mudic setObject:[obj objectForKey:@"amount"] forKey:@"amount"];
    if([obj objectForKey:@"bookName"])
        [mudic setObject:[obj objectForKey:@"bookName"] forKey:@"bookName"];
    if([obj objectForKey:@"category"])
        [mudic setObject:[obj objectForKey:@"category"] forKey:@"category"];
    if([obj objectForKey:@"originalPrice"])
        [mudic setObject:[obj objectForKey:@"originalPrice"] forKey:@"originalPrice"];
    if([obj objectForKey:@"bookImageURL"])
        [mudic setObject:[obj objectForKey:@"bookImageURL"] forKey:@"bookImageURL"];
    if([obj objectForKey:@"createdAt"])
        [mudic setObject:[obj objectForKey:@"createdAt"] forKey:@"createdAt"];
    if([obj objectForKey:@"userHeadImageURL"])
        [mudic setObject:[obj objectForKey:@"userHeadImageURL"] forKey:@"userHeadImageURL"];
    if([obj objectForKey:@"school"])
        [mudic setObject:[obj objectForKey:@"school"] forKey:@"school"];
    if([obj objectForKey:@"visitorURLArr"])
        [mudic setObject:[obj objectForKey:@"visitorURLArr"] forKey:@"visitorURLArr"];
    if([obj objectForKey:@"ownerObjectId"])
        [mudic setObject:[obj objectForKey:@"ownerObjectId"] forKey:@"ownerObjectId"];
    //if([obj.objectId != nil){
        [mudic setObject: obj.objectId forKey:@"objectId"];
    //}
    return mudic;
}
#pragma findBookInfo end
@end
