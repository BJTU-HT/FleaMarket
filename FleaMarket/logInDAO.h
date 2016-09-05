//
//  logInDAO.h
//  FleaMarket
//
//  Created by Hou on 4/22/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "logInDAODelegate.h"

@interface logInDAO : NSObject

@property (strong, nonatomic) id<logInDAODelegate> delegate;

+(logInDAO *)sharedManager;

//DAO 层修改个人信息 dic 包括昵称，个性签名等信息，backgroundImage 背景图片 headImage 用户头像
-(void)cacheAndUploadPersonalLogInInfo:(NSMutableDictionary *)dic backgroundImage:(UIImage *)backgroundImage headImage:(UIImage *)headImage;

//向服务器或缓存请求用户信息
-(void)requestDataFromServerOrPlist:(NSString *)plistName;
@end
