//
//  LogInBL.m
//  FleaMarket
//
//  Created by Hou on 4/26/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "LogInBL.h"

@implementation LogInBL

-(void)cacheAndUploadPersonalLogInInfoBL:(NSMutableDictionary *)dic backgroundImage:(UIImage *)backgroundImage headImage:(UIImage *)headImage
{
    logInDAO *modifyPerInfo = [[logInDAO alloc] init];
    modifyPerInfo.delegate = self;
    [modifyPerInfo cacheAndUploadPersonalLogInInfo:dic backgroundImage:backgroundImage headImage:headImage];
}

//向服务器或者缓存请求用户信息，
-(void)cacheAndDownloadPersonalInfoBL:(NSString *)plistName
{
    // By 仝磊鸣，使用shareManager去获取logInDAO, 2016-7-22
    //logInDAO *downloadUserInfo = [[logInDAO alloc]init];
    logInDAO *downloadUserInfo = [logInDAO sharedManager];
    
    downloadUserInfo.delegate = self;
    [downloadUserInfo requestDataFromServerOrPlist:plistName];
}
#pragma -------Implement LogInDAO delegate method-------------------
-(void)modifyPersonalInfoFinishedDAO:(NSInteger)value{
    [self.delegate modifyPersonalInfoFinishedBL:value];
}
-(void)modifyPersonalInfoFailedDAO:(NSString *)error{
    [self.delegate modifyPersonalInfoFailedBL:error];
}
#pragma -------Implement LogInDAO delegate method end--------------

#pragma ---------实现个人信息页面获取用户图像信息代理------------------------
-(void)headImageDataTransmitBackFinishedDAO:(UIImage *)image userTextInfo:(NSDictionary *)userInfo{
    [self.delegate headImageDataTransmitBackFinishedBL:image userTextInfo:userInfo];
}
-(void)headImageDataTransmitBackFailedDAO:(NSString *)error{
    [self.delegate headImageDataTransmitBackFailedBL:error];
}

-(void)backgroundImageDataTransmitBackFinishedDAO:(UIImage *)image{
    [self.delegate backgroundImageDataTransmitBackFinishedBL:image];
}
-(void)backgroundImageDataTransmitBackFailedDAO:(NSString *)error{
    [self.delegate backgroundImageDataTransmitBackFailedBL:error];
}

-(void)userInfoTransmitBackFinishedDAO:(NSDictionary *)userInfo{
    [self.delegate userInfoTransmitBackFinishedBL:userInfo];
}

-(void)userInfoTransmitBackFailedDAO:(NSString *)error{
    [self.delegate userInfoTransmitBackFailedBL:error];
}
#pragma ---------实现个人信息页面获取用户图像信息代理 end------------------------

@end
