//
//  concernBL.m
//  FleaMarket
//
//  Created by Hou on 9/6/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "concernBL.h"
#import "concernDAO.h"

@implementation concernBL
static concernBL *sharedManager;

+(concernBL *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

//添加关注
-(void)addConcernUserBL:(NSMutableDictionary *)mudic{
    concernDAO *conDAO = [concernDAO sharedManager];
    conDAO.delegate = self;
    [conDAO addConcernUserDAO:mudic];
}

-(void)updateConcernedDataBL:(NSMutableDictionary *)dic{
    concernDAO *conDAO = [concernDAO sharedManager];
    conDAO.delegate = self;
    [conDAO updateConcernedDataDAO:dic];
}

//从用户表查找关注数据
-(void)requestConcernedDataBL:(NSString *)objectId{
    concernDAO *conDAO = [concernDAO sharedManager];
    conDAO.delegate = self;
    [conDAO requestConcernedDataDAO: objectId];
}

#pragma 添加关注更新用户表数据 begin
-(void)concernedUserUploadFailedDAO:(NSError *)error{
    [self.delegate concernedUserUploadFailedBL:error];
}

-(void)concernedUserUploadFinishedDAO:(BOOL)value{
    [self.delegate concernedUserUploadFinishedBL:value];
}
#pragma 添加关注更新用户表数据 end

#pragma 从用户表查找关注数据 begin
-(void)concernedDataRequestFinishedDAO:(NSArray *)arr{
    [self.delegate concernedDataRequestFinishedBL:arr];
}
-(void)concernedDataRequestFailedDAO:(NSError *)error{
    [self.delegate concernedDataRequestFailedBL:error];
}
-(void)cocnernedDataRequestNODataDAO:(BOOL)value{
    [self.delegate cocnernedDataRequestNODataBL: value];
}
#pragma 从用户表查找关注数据 end
@end
