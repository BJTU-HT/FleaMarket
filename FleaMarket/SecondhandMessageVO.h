//
//  SecondhandMessage.h
//  FleaMarket
//
//  Created by tom555cat on 16/4/12.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecondhandMessageVO : NSObject

@property (nonatomic, strong) NSString *messageID;
@property (nonatomic, strong) NSString *productID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userIconImage;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *publishTime;
@property (nonatomic, strong) NSString *toUserName;
@property (nonatomic, strong) NSString *toUserID;
@property (nonatomic, strong) NSString *parentMessageID;

// 从plist读取数据
+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
