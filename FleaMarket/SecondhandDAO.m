//
//  SecondhandDAO.m
//  FleaMarket
//
//  Created by tom555cat on 16/3/31.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <BmobSDK/Bmob.h>
#import "SecondhandDAO.h"
#import "VOGroup.h"
#import "Help.h"
#import "UIImageView+WebCache.h"

@implementation SecondhandDAO

static SecondhandDAO *sharedManager = nil;

+(SecondhandDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
        sharedManager.offset = 0;
    });
    return sharedManager;
}

- (void)create:(SecondhandVO *)model
{
    BmobObject *secondhand = [BmobObject objectWithClassName:@"Secondhand"];
    
    // 测试
    [secondhand setObject:model.userName forKey:@"user_name"];
    [secondhand setObject:model.sex forKey:@"sex"];
    [secondhand setObject:model.userIconImage forKey:@"user_icon_url"];
    [secondhand setObject:model.userID forKey:@"user_id"];
    [secondhand setObject:model.productName forKey:@"product_name"];
    [secondhand setObject:model.productDescription forKey:@"product_description"];
    [secondhand setObject:[NSNumber numberWithInteger:model.nowPrice] forKey:@"now_price"];
    [secondhand setObject:[NSNumber numberWithFloat:model.originalPrice] forKey:@"original_price"];
    [secondhand setObject:model.mainCategory forKey:@"main_category"];
    [secondhand setObject:model.viceCategory forKey:@"vice_category"];
    [secondhand setObject:model.location forKey:@"location"];
    [secondhand setObject:model.location forKey:@"school"];
    [secondhand setObject:model.pictureArray forKey:@"picture_array"];
    
    [secondhand saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            // 调用代理通知
            [self.delegate createSecondhandFinished];
        } else {
            [self.delegate createSecondhandFailed];
        }
    }];
}

- (void)modify:(SecondhandVO *)model
{
    
}

- (void)remove:(SecondhandVO *)model
{
    
}


- (void)findSecondhand:(NSDictionary *)filterDic
{
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Secondhand"];
    
    // 设置分页查询
    bquery.limit = CommentLimit;
    bquery.skip = _offset;
    
    // 按时间排序
    [bquery orderByDescending:@"createdAt"];
    
    for (NSString *key in [filterDic allKeys]) {
        // 检索
        if ([key isEqualToString:@"product_name"]) {
            NSString *value = filterDic[key];
            [bquery whereKey:@"product_name" matchesWithRegex:[NSString stringWithFormat:@"/*%@/*", value]];
        }
        
        // 按商品分类过滤
        if ([key isEqualToString:@"main_category"]) {
            NSString *value = filterDic[key];
            [bquery whereKey:@"main_category" equalTo:value];
        }
        
        // 按学校过滤
        if ([key isEqualToString:@"school"]) {
            NSArray *schoolArray = filterDic[key];
            for (NSString *school in schoolArray) {
                [bquery whereKey:@"school" equalTo:school];
            }
        }
    }
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            SecondhandVO *vo = [[SecondhandVO alloc] init];
            vo.userID = [obj objectForKey:@"user_id"];
            vo.userName = [obj objectForKey:@"user_name"];
            vo.userIconImage = [obj objectForKey:@"user_icon_url"];
            vo.sex = [obj objectForKey:@"sex"];
            vo.productID = [obj objectForKey:@"objectId"];
            vo.productName = [obj objectForKey:@"product_name"];
            vo.productDescription = [obj objectForKey:@"product_description"];
            vo.school = [obj objectForKey:@"school"];
            vo.nowPrice = [[obj objectForKey:@"now_price"] intValue];
            vo.originalPrice = [[obj objectForKey:@"original_price"] intValue];
            vo.pictureArray = [obj objectForKey:@"picture_array"];
            vo.skimTimes = [[obj objectForKey:@"skim_times"] intValue];
            vo.praiseTimes = [[obj objectForKey:@"praise_times"] intValue];
            vo.location = [obj objectForKey:@"location"];
            vo.publishTime = [obj objectForKey:@"createdAt"];
            vo.mainCategory = [obj objectForKey:@"main_category"];
            vo.viceCategory = [obj objectForKey:@"vice_category"];
            vo.buyerID = [obj objectForKey:@"buyer_id"];
            vo.visitorURLArray = [obj objectForKey:@"visitor_url_array"];
            vo.downLoadPicArray = [[NSMutableArray alloc] init];

            [listData addObject:vo];
        }
        
        // 查询结果按照发布时间排序
        [listData sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *str1 = ((SecondhandVO *)obj1).publishTime;
            NSString *str2 = ((SecondhandVO *)obj2).publishTime;
            return [str2 compare:str1];
        }];
        
        // 记录最新二手商品的创建时间
        if (listData.count) {
            NSString *dateStr = ((SecondhandVO *)listData[0]).publishTime;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            self.lastestTime = [[NSDate date] initWithTimeInterval:1 sinceDate:[formatter dateFromString:dateStr]];
        }
        
        [self.delegate findSecondhandFinished:listData];
        
        // 偏移量后移
        _offset += CommentLimit;
    }];
    
}

- (void)findNewComming:(NSDictionary *)filterDic
{
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Secondhand"];
    if (self.lastestTime) {
        [bquery whereKey:@"createdAt" greaterThan:self.lastestTime];
    }
    
    // 根据过滤条件设置
    for (NSString *key in [filterDic allKeys]) {
        // 检索
        if ([key isEqualToString:@"product_name"]) {
            NSString *value = filterDic[key];
            [bquery whereKey:@"product_name" matchesWithRegex:[NSString stringWithFormat:@"/*%@/*", value]];
        }
        
        // 按商品分类过滤
        if ([key isEqualToString:@"main_category"]) {
            NSString *value = filterDic[key];
            [bquery whereKey:@"main_category" equalTo:value];
        }
        
        // 按学校过滤
        if ([key isEqualToString:@"school"]) {
            NSArray *schoolArray = filterDic[key];
            for (NSString *school in schoolArray) {
                [bquery whereKey:@"school" equalTo:school];
            }
        }
    }
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            SecondhandVO *vo = [[SecondhandVO alloc] init];
            vo.userID = [obj objectForKey:@"user_id"];
            vo.userName = [obj objectForKey:@"user_name"];
            vo.userIconImage = [obj objectForKey:@"user_icon_url"];
            vo.sex = [obj objectForKey:@"sex"];
            vo.productID = [obj objectForKey:@"objectId"];
            vo.productName = [obj objectForKey:@"product_name"];
            vo.productDescription = [obj objectForKey:@"product_description"];
            vo.school = [obj objectForKey:@"school"];
            vo.nowPrice = [[obj objectForKey:@"now_price"] intValue];
            vo.originalPrice = [[obj objectForKey:@"original_price"] intValue];
            vo.pictureArray = [obj objectForKey:@"picture_array"];
            vo.skimTimes = [[obj objectForKey:@"skim_times"] intValue];
            vo.praiseTimes = [[obj objectForKey:@"praise_times"] intValue];
            vo.location = [obj objectForKey:@"location"];
            vo.publishTime = [obj objectForKey:@"createdAt"];
            vo.mainCategory = [obj objectForKey:@"main_category"];
            vo.viceCategory = [obj objectForKey:@"vice_category"];
            vo.buyerID = [obj objectForKey:@"buyer_id"];
            vo.visitorURLArray = [obj objectForKey:@"visitor_url_array"];
            vo.downLoadPicArray = [[NSMutableArray alloc] init];
            
            [listData addObject:vo];
        }
        
        // 查询结果按照发布时间排序
        [listData sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *str1 = ((SecondhandVO *)obj1).publishTime;
            NSString *str2 = ((SecondhandVO *)obj2).publishTime;
            return [str2 compare:str1];
        }];
        
        // 调用delegate方法
        [self.delegate findNewCommingFinished:listData];
        
        // 找出查询出的商品的最晚时间，更新最新二手商品加载时间
        if ([listData count] > 0) {
            NSString *dateStr = ((SecondhandVO *)listData[0]).publishTime;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            self.lastestTime = [[NSDate date] initWithTimeInterval:1 sinceDate:[formatter dateFromString:dateStr]];
        }
        
    }];
}

- (void)oneMoreVisitor:(NSString *)visitorURL
            secondhand:(SecondhandVO *)model
{
    NSString *productID = model.productID;
    
    // 浏览次数加1
    int currentSkimNum = model.skimTimes + 1;
    
    // 新增来访者头像
    NSMutableArray *visitorURLArray = [NSMutableArray arrayWithArray:model.visitorURLArray];
    for (NSString *str in visitorURLArray) {
        if ([visitorURL isEqualToString:str]) {
            return;
        }
    }
    
    if ([visitorURLArray count] == MaxVisitorURLsKeep) {
        [visitorURLArray removeLastObject];
        [visitorURLArray insertObject:visitorURL atIndex:0];
    } else {
        [visitorURLArray insertObject:visitorURL atIndex:0];
    }
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Secondhand"];
    [bquery getObjectInBackgroundWithId:productID block:^(BmobObject *object, NSError *error) {
        // 没有返回错误
        if (!error) {
            // 对象存在
            if (object) {
                BmobObject *obj1 = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                [obj1 setObject:[NSNumber numberWithInt:currentSkimNum] forKey:@"skim_times"];
                [obj1 setObject:visitorURLArray forKey:@"visitor_url_array"];
                [obj1 updateInBackground];
            }
        } else {
            NSLog(@"新增来访者失败!");
        }
    }];
}


@end
