//
//  LogInAndRegistLogiDelegate.h
//  FleaMarket
//
//  Created by Hou on 4/18/16.
//  Copyright © 2016 H-T. All rights reserved.
//
#import <UIKit/UIKit.h>
#ifndef LogInAndRegistLogiDelegate_h
#define LogInAndRegistLogiDelegate_h

//@class registViewController;

@protocol LogInAndRegistLogicDelegate

@optional

- (void)getVerifyCodeFromPersistDAO:(NSString *)phoneNumber;

-(void)passValueFromPersistLayer:(NSInteger) value;

- (void)findAllRegistInfoFinished:(NSInteger)value;
- (void)findAllRegistInfoFailed:(NSString *)error;

//注册Logic层代理函数
-(void)regist_BL_Finished:(NSInteger)value;
-(void)regist_BL_Failed:(NSString *)error;

//用户名登录逻辑层代理函数
-(void)logInPassDicInfoFinishedBL:(NSDictionary *)userInfo;
-(void)logInPassDicInfoFailedBL:(NSString *)error;

//手机号码登录，从服务器获取验证码
-(void)logInByPhoneNumForGetVerifyCodeBLFinished:(NSInteger)value;
-(void)logInByPhoneNumForGetVerifyCodeBLFailed:(NSString *)error;


//手机号登录 校验手机号和验证码 逻辑层
-(void)logInVerifyPhoneNumberAndVerifyCodeBLFinished:(NSInteger)value;
-(void)logInVerifyPhoneNumberAndVerifyCodeBLFailed:(NSString *)error;


#pragma ----------LogIn modify personal Infomation-------------------
-(void)modifyPersonalInfoFinishedBL:(NSInteger)value;
-(void)modifyPersonalInfoFailedBL:(NSString *)error;
#pragma ----------LogIn modify personal Infomation end-------------------


//个人信息页面从服务器获或缓存获取图像信息 数据回传
//头像
-(void)headImageDataTransmitBackFinishedBL:(UIImage *)image userTextInfo:(NSDictionary *)userInfo;
-(void)headImageDataTransmitBackFailedBL:(NSString *)error;
//背景图片
-(void)backgroundImageDataTransmitBackFinishedBL:(UIImage *)image;
-(void)backgroundImageDataTransmitBackFailedBL:(NSString *)error;

//从服务器或缓存返回除图片外的用户信息
-(void)userInfoTransmitBackFinishedBL:(NSDictionary *)userInfo;
-(void)userInfoTransmitBackFailedBL:(NSString *)error;

//检测该手机号是否注册过
-(void)checkPhoneNumberRegisteredOrNotFinishedBL:(BOOL)value;
-(void)checkPhoneNumberRegisteredOrNotFailedBL:(NSString *)error;
@end


#endif /* LogInAndRegistLogiDelegate_h */
