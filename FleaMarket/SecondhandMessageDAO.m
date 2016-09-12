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
#import "AFNetworking.h"


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
            
            // 留言成功后进行推送
            
            // audience象字典
            NSMutableDictionary *audienceDic = [[NSMutableDictionary alloc] init];
            [audienceDic setObject:@[model.toUserID] forKey:@"alias"];
            // notification字典
            NSMutableDictionary *notificationDic = [[NSMutableDictionary alloc] init];
            [notificationDic setObject:model.content forKey:@"alert"];
            // ios设置字典
            NSMutableDictionary *iosDic = [[NSMutableDictionary alloc] init];
            [iosDic setObject:@"sound.caf" forKey:@"sound"];
            [iosDic setObject:@"+1" forKey:@"badge"];
            [iosDic setObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"ios-key1", @"ios-value1", nil] forKey:@"extras"];
            [notificationDic setObject:iosDic forKey:@"ios"];
            // options字典
            NSMutableDictionary *optionsDic = [[NSMutableDictionary alloc] init];
            [optionsDic setObject:@"60" forKey:@"time_to_live"];
            [optionsDic setObject:@"false" forKey:@"apns_production"];
            
            // 汇总
            NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];
            [jsonDic setObject:@"ios" forKey:@"platform"];
            [jsonDic setObject:audienceDic forKey:@"audience"];
            [jsonDic setObject:notificationDic forKey:@"notification"];
            [jsonDic setObject:optionsDic forKey:@"options"];
            
            // 推送
            NSError *parseError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:&parseError];
            //NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.jpush.cn/v3/push"]];
            [request setValue:@"Basic NjU1MWQyNzFhNTY3YTM5NjRmYzJiYjQzOmNhNTBmZjFhODRhMDU0Njk3NDY1ZDM2NA==" forHTTPHeaderField:@"Authorization"];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:jsonData];
            
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                NSLog(@"%@",dict);
            }];
            
            [task resume];
            
        } else if (error) {
            //
        } else {
            //
        }
    }];
}



@end
