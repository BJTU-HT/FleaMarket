//
//  TonglmTest.m
//  FleaMarket
//
//  Created by tom555cat on 16/4/18.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <BmobSDK/Bmob.h>
#import "TonglmTest.h"
#import "SecondhandMessageVO.h"

@implementation TonglmTest

- (void)viewDidLoad
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Comment"];
    //[bquery whereKey:@"product_id" equalTo:productID];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            SecondhandMessageVO *vo = [[SecondhandMessageVO alloc] init];
            vo.messageID = [obj objectForKey:@"message_id"];
            vo.productID = [obj objectForKey:@"product_id"];
            vo.userID = [obj objectForKey:@"user_id"];
            vo.userName = [obj objectForKey:@"user_name"];
            vo.userIconImage = [obj objectForKey:@"user_icon_image"];
            vo.content = [obj objectForKey:@"content"];
            vo.publishTime = [obj objectForKey:@"publish_time"];
            vo.toUserName = [obj objectForKey:@"to_user_name"];
            vo.parentMessageID = [obj objectForKey:@"parent_message_id"];
            
            NSLog(@"%@", [obj objectForKey:@"message_id"]);
            
        }
        
        // 按发布时间重新排序listData
        // ...
        
        //[self.delegate findSecondhandMessageFinished:listData];
    }];
}

@end
