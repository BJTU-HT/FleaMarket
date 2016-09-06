//
//  mySellDAO.m
//  FleaMarket
//
//  Created by Hou on 8/24/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "mySellDAO.h"
#import <BmobSDK/BmobQuery.h>
#import <BmobSDK/Bmob.h>

@implementation mySellDAO
static mySellDAO *sharedManager = nil;

+(mySellDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

-(void)getSellGoodsInfoDAO:(NSString *)userName{
    [self.tempMuArr removeAllObjects];
    BmobQuery *querySell = [BmobQuery queryWithClassName:@"Secondhand"];
    if(userName){
        [querySell whereKey:@"user_name" equalTo:userName];
    }
    querySell.limit = pageOffset;
    [querySell findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if(error){
            [self.delegate sellGoodsInfoSearchFailedDAO:error];
        }else{
            [self.tempMuArr addObjectsFromArray:array];
            BmobQuery *queryBook = [BmobQuery queryWithClassName:@"sell"];
            if(userName){
                [queryBook whereKey:@"userName" equalTo:userName];
            }
            queryBook.limit = pageOffset;
            [queryBook findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if(error){
                    [self.delegate sellGoodsInfoSearchFailedDAO:error];
                }else{
                    [self.tempMuArr addObjectsFromArray:array];
                    if(self.tempMuArr.count == 0){
                        [self.delegate sellGoodsInfoSearchFinishedNoDataDAO:1];
                    }else{
                        for(int i = 0; i < self.tempMuArr.count; i++){
                            BmobObject *obj = [self.tempMuArr objectAtIndex:i];
                            [self.recMuArr addObject: [self objToDic:obj]];
                        }
                        [self.delegate sellGoodsInfoSearchFinishedDAO: self.tempMuArr];
                    }
                }
            }];
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
    //if([obj.objectId != nil){
    [mudic setObject: obj.objectId forKey:@"objectId"];
    
    //secondhand
    if([obj objectForKey:@"visitor_url_array"])
        [mudic setObject:[obj objectForKey:@"visitor_url_array"] forKey:@"visitor_url_array"];
    if([obj objectForKey:@"location"])
        [mudic setObject:[obj objectForKey:@"location"] forKey:@"location"];
    if([obj objectForKey:@"main_category"])
        [mudic setObject:[obj objectForKey:@"main_category"] forKey:@"main_category"];
    if([obj objectForKey:@"now_price"])
        [mudic setObject:[obj objectForKey:@"now_price"] forKey:@"now_price"];
    if([obj objectForKey:@"original_price"])
        [mudic setObject:[obj objectForKey:@"original_price"] forKey:@"original_price"];
    if([obj objectForKey:@"picture_array"])
        [mudic setObject:[obj objectForKey:@"picture_array"] forKey:@"picture_array"];
    if([obj objectForKey:@"product_description"])
        [mudic setObject:[obj objectForKey:@"product_description"] forKey:@"product_description"];
    if([obj objectForKey:@"product_name"])
        [mudic setObject:[obj objectForKey:@"product_name"] forKey:@"product_name"];
    if([obj objectForKey:@"school"])
        [mudic setObject:[obj objectForKey:@"school"] forKey:@"school"];
    if([obj objectForKey:@"sex"])
        [mudic setObject:[obj objectForKey:@"sex"] forKey:@"sex"];
    if([obj objectForKey:@"skim_times"])
        [mudic setObject:[obj objectForKey:@"skim_times"] forKey:@"skim_times"];
    if([obj objectForKey:@"user_icon_url"])
        [mudic setObject:[obj objectForKey:@"user_icon_url"] forKey:@"user_icon_url"];
    if([obj objectForKey:@"user_id"])
        [mudic setObject:[obj objectForKey:@"user_id"] forKey:@"user_id"];
    if([obj objectForKey:@"user_name"])
        [mudic setObject:[obj objectForKey:@"user_name"] forKey:@"user_name"];
    if([obj objectForKey:@"vice_category"])
        [mudic setObject:[obj objectForKey:@"vice_category"] forKey:@"vice_category"];
    if([obj objectForKey:@"createdAt"])
        [mudic setObject:[obj objectForKey:@"createdAt"] forKey:@"createdAt"];
    //}
    return mudic;
}
-(NSMutableArray *)recMuArr{
    if(!_recMuArr){
        _recMuArr = [[NSMutableArray alloc] init];
    }
    return _recMuArr;
}

-(NSMutableDictionary *)recMudic{
    if(!_recMudic){
        _recMudic = [[NSMutableDictionary alloc] init];
    }
    return _recMudic;
}

-(NSMutableArray *)tempMuArr{
    if(!_tempMuArr){
        _tempMuArr = [[NSMutableArray alloc] init];
    }
    return _tempMuArr;
}
@end
