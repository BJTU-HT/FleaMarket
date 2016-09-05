//
//  LogInBL.h
//  FleaMarket
//
//  Created by Hou on 4/26/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "logInDAODelegate.h"
#import "LogInAndRegistLogicDelegate.h"
#import "logInDAO.h"

@interface LogInBL : NSObject<logInDAODelegate>

@property (weak, nonatomic) id<LogInAndRegistLogicDelegate> delegate;
-(void)cacheAndUploadPersonalLogInInfoBL:(NSMutableDictionary *)dic backgroundImage:(UIImage *)backgroundImage headImage:(UIImage *)headImage;

//向服务器或者缓存请求用户信息
-(void)cacheAndDownloadPersonalInfoBL:(NSString *)plistName;
@end
