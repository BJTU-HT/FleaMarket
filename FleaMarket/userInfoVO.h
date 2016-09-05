//
//  userInfoVO.h
//  FleaMarket
//
//  Created by Hou on 4/22/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userInfoVO : NSObject

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *verifyCode;
@property (strong, nonatomic) NSString *passWord;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *backgroundImageURL;
@property (strong, nonatomic) NSString *userLevel;
@property (strong, nonatomic) NSString *concerned;
@property (strong, nonatomic) NSString *fans;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *liveCity;
@property (strong, nonatomic) NSString *personalSignature;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *nickName;

//+(instancetype)userInfoModelWithDict:(NSDictionary *)dict;
@end
