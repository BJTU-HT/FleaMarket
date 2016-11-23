//
//  PersistLayerDelegate.h
//  FleaMarket
//
//  Created by Hou on 4/18/16.
//  Copyright © 2016 H-T. All rights reserved.
//

@class RegistDAO;

@protocol RegistDAODelegate <NSObject>

//手机注册获取短信验证码
-(void)findAllFinished:(NSInteger)value;
-(void)findAllFailed:(NSString *)error;

//用于处理注册信息
-(void)registFinished:(NSInteger)value;
-(void)registFailed:(NSString *)error;

//登录成功后返回字典信息
-(void)logInPassDicInfoFinishedDAO:(NSDictionary *)userInfo;
-(void)logInPassDicInfoFailedDAO:(NSString *)error;

//手机号码登录，从服务器获取验证码
-(void)logInByPhoneNumForGetVerifyCodeFinished:(NSInteger)value;
-(void)logInByPhoneNumForGetVerifyCodeFailed:(NSString *)error;

// 手机号登录，校验手机号和验证码
-(void)logInVerifyPhoneNumberAndVerifyCodeFinished:(NSMutableDictionary *)userInfo;
-(void)logInVerifyPhoneNumberAndVerifyCodeFailed:(NSString *)error;

//检测该手机号是否注册过
-(void)checkPhoneNumberRegisteredOrNotFinishedDAO:(BOOL)value;
-(void)checkPhoneNumberRegisteredOrNotFailedDAO:(NSString *)error;

@end
