//
//  UserInfoSingleton.h
//  FleaMarket
//
//  Created by tom555cat on 16/7/22.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserMO.h"

@interface UserInfoSingleton : NSObject

@property (nonatomic, strong) UserMO *userMO;

- (void)updateUserMO:(NSDictionary *)userInfo;

+ (UserInfoSingleton *)sharedManager;

@end
