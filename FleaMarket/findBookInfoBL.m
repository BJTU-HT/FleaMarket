//
//  findBookInfoBL.m
//  FleaMarket
//
//  Created by Hou on 8/1/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "findBookInfoBL.h"

@implementation findBookInfoBL

static findBookInfoBL *sharedManager;

+(findBookInfoBL *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

-(void)getBookDataFromBmobBL:(NSDictionary *)dic{
    findBooKInfoDAO *findInfo = [findBooKInfoDAO sharedManager];
    findInfo.delegate = self;
    [findInfo getBookDataFromBmobDAO:dic];
}

-(void)getBookDataDownDragFromBmobBL:(NSDictionary *)dic{
    findBooKInfoDAO *findInfo = [findBooKInfoDAO sharedManager];
    findInfo.delegate = self;
    [findInfo downDragGetDataFromDAO:dic];
}

-(void)getBookDataAccordBookNameFromBmobBL:(NSDictionary *)dic{
    findBooKInfoDAO *findInfo = [findBooKInfoDAO sharedManager];
    findInfo.delegate = self;
    [findInfo getBookDataAccordBookNameFromBmobDAO:dic];
}

//add vistitor
-(void)updateVisitorDataBL:(NSMutableDictionary *)dic{
    NSMutableArray *urlArr = [dic objectForKey:@"visitorURLArr"];
    NSString *newURL = [dic objectForKey:@"visitorURL"];
    int i = 0;
    if(urlArr){
        for(i = 0; i < urlArr.count; i++){
            if([newURL isEqualToString:[urlArr objectAtIndex:i]])
            {
                [urlArr removeObjectAtIndex:i];
                [urlArr insertObject:newURL atIndex:0];
                break;
            }
        }
        if((i == urlArr.count) && (![newURL isEqualToString:[urlArr objectAtIndex:(i - 1)]])){
            [urlArr insertObject: newURL atIndex:0];
        }
    }else{
        urlArr = [[NSMutableArray alloc] init];
        [urlArr addObject:newURL];
    }
    [dic removeObjectForKey:@"visitorURLArr"];
    [dic setObject:urlArr forKey:@"visitorURLArr"];
    findBooKInfoDAO *findDAO = [[findBooKInfoDAO alloc] init];
    [findDAO updateVisitorDataDAO:dic];
}

- (void)resetOffset{
    findBooKInfoDAO *findBookInfo = [findBooKInfoDAO sharedManager];
    findBookInfo.bookOffset = 0;
}

-(void)resetOffsetDownDrag{
    findBooKInfoDAO *findBookInfo = [findBooKInfoDAO sharedManager];
    findBookInfo.bookOffsetUp = 0;
}

-(void)searchBookInfoFailedDAO:(NSError *)error{
    [self.delegate searchBookInfoFailedBL:error];
}

-(void)searchBookInfoFinishedDAO:(NSMutableArray *)arr{
    [self.delegate searchBookInfoFinishedBL: arr];
}

-(void)searchBookInfoFinishedNODataDAO:(NSString *)str{
    [self.delegate searchBookInfoFinishedNODataBL:str];
}

//search book from searchBar
-(void)searchBookInfoFromSearchDAO:(NSMutableArray *)arr{
    [self.delegate searchBookInfoFromSearchBL:arr];
}
@end
