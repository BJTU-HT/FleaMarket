//
//  SecondhandMessageDAO.m
//  FleaMarket
//
//  Created by tom555cat on 16/4/12.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <BmobSDK/Bmob.h>
#import "SecondhandMessageDAO.h"
#import "SecondhandMessageVOGroup.h"
#import "SecondhandMessageVO.h"
#import "Help.h"


@implementation SecondhandMessageDAO

static SecondhandMessageDAO *sharedManager = nil;
//static NSInteger readSkip = 0;

+ (SecondhandMessageDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
        sharedManager.readSkip = 0;
    });
    return sharedManager;
}

/*
 - (instancetype)init
 {
 self = [super init];
 
 if (self) {
 _readSkip = 0;
 }
 
 return self;
 }
 */

- (void)findSecondhandMessage:(NSString *)productID
{
    
    /*
     // 查询二手商品评论
     NSMutableArray *listData = [SecondhandMessageVOGroup groupWithNameOfContent:@"SecondhandMessage.plist"];
     
     // 根据商品ID过滤评论
     NSMutableArray *listDataForProductID = [[NSMutableArray alloc] init];
     for (SecondhandMessageVO *messageVO in listData) {
     NSString *pID = messageVO.productID;
     if ([pID isEqualToString:productID]) {
     [listDataForProductID addObject:messageVO];
     }
     }
     */
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Comment"];
    bquery.limit = CommentLimit;        // 每次读取多少条数据
    bquery.skip = _readSkip;            // 每次读取的偏移位置
    [bquery whereKey:@"product_id" equalTo:productID];
    [bquery orderByDescending:@"createdAt"];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            SecondhandMessageVO *vo = [[SecondhandMessageVO alloc] init];
            vo.messageID = [obj objectForKey:@"message_id"];
            vo.productID = [obj objectForKey:@"product_id"];
            vo.userID = [obj objectForKey:@"user_id"];
            vo.userName = [obj objectForKey:@"user_name"];
            vo.userIconImage = [obj objectForKey:@"user_icon_image"];
            vo.content = [obj objectForKey:@"content"];
            vo.publishTime = [obj objectForKey:@"createdAt"];
            vo.toUserName = [obj objectForKey:@"to_user_name"];
            vo.parentMessageID = [obj objectForKey:@"parent_message_id"];
            
            NSLog(@"%@", [obj objectForKey:@"message_id"]);
            
            [listData addObject:vo];
        }
        
        // 按发布时间重新排序listData
        [listData sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *str1 = ((SecondhandMessageVO *)obj1).publishTime;
            NSString *str2 = ((SecondhandMessageVO *)obj2).publishTime;
            return [str2 compare:str1];
        }];
        
        [self.delegate findSecondhandMessageFinished:listData];
        
        // 偏移量后移
        _readSkip += CommentLimit;
    }];
}

- (void)createMessage:(SecondhandMessageVO *)model
{
    BmobObject *comment = [BmobObject objectWithClassName:@"Comment"];
    [comment setObject:model.messageID forKey:@"message_id"];
    [comment setObject:model.productID forKey:@"product_id"];
    [comment setObject:model.userID forKey:@"user_id"];
    [comment setObject:model.userName forKey:@"user_name"];
    [comment setObject:model.userIconImage forKey:@"user_icon_image"];
    [comment setObject:model.content forKey:@"content"];
    [comment setObject:model.publishTime forKey:@"publish_time"];
    [comment setObject:model.toUserName forKey:@"to_user_name"];
    [comment setObject:model.parentMessageID forKey:@"parent_message_id"];
    
    [comment saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"");
            [self.delegate createMessageFinished:model];
        } else if (error) {
            //
        } else {
            //
        }
    }];
}



@end
