//
//  RegistBL.m
//  FleaMarket
//
//  Created by Hou on 4/18/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "RegistBL.h"
#import "RegistDAO.h"

@implementation RegistBL

//注册请求验证码
-(void)phoneNumberRegistGetShortMessage:(NSString *)phoneNumber
{
    RegistDAO *regDAO = [RegistDAO sharedManager];
    regDAO.delegate = self;
    [regDAO getVerifyCodeMessageFromPersistDAO:phoneNumber];
}

//注册请求
-(void)registLogicDeal:(NSDictionary *)registBLInfo
{
    RegistDAO *regDAO = [RegistDAO sharedManager];
    regDAO.delegate = self;
    [regDAO registByPhone:registBLInfo];
}

//登录逻辑层
-(void)searchUserInfoBL:(NSString *)userName secret:(NSString *)passWord
{
    RegistDAO *regDAO = [RegistDAO sharedManager];
    regDAO.delegate = self;
    [regDAO searchUserInfo:userName secret:passWord];
}

//手机号码登录获取验证码逻辑层处理
-(void)getPhoneVerifyCodeBL:(NSString *)phoneNumber
{
    RegistDAO *regDAOGetPhoneVerifyCode = [RegistDAO sharedManager];
    regDAOGetPhoneVerifyCode.delegate = self;
    [regDAOGetPhoneVerifyCode getPhoneVerifyCode:phoneNumber];
}

//手机号登录 校验手机号和验证码
-(void)verifyPhoneNumberAndVerifyCodeBL: (NSString *)phoneNumber code: (NSString *)verifyCode
{
    RegistDAO *regDAOVerifyPhoneVerifyCode = [RegistDAO sharedManager];
    regDAOVerifyPhoneVerifyCode.delegate = self;
    [regDAOVerifyPhoneVerifyCode verifyPhoneNumberAndVerifyCode:phoneNumber veifyCode:verifyCode];
}

//注册时检测该手机号是否被注册过
-(void)checkMobilePhoneNumberRegistedOrNotBL:(NSString *)phoneNumber{
    RegistDAO *checkPN = [RegistDAO sharedManager];
    checkPN.delegate = self;
    [checkPN checkMobilePhoneNumberRegistedOrNotDAO:phoneNumber];
}

#pragma 注册时检验该手机号是否注册过，代理方法
-(void)checkPhoneNumberRegisteredOrNotFinishedDAO:(BOOL)value{
    [self.delegate checkPhoneNumberRegisteredOrNotFinishedBL:value];
}
-(void)checkPhoneNumberRegisteredOrNotFailedDAO:(NSString *)error{
    [self.delegate checkPhoneNumberRegisteredOrNotFailedBL:error];
}
#pragma 注册时检验该手机号是否注册过，代理方法 end
#pragma ----------RegistDAO代理方法 手机号登录校验手机号和验证码--------------
-(void)logInVerifyPhoneNumberAndVerifyCodeFinished:(NSInteger)value
{
    [self.delegate logInVerifyPhoneNumberAndVerifyCodeBLFinished:value];
}
-(void)logInVerifyPhoneNumberAndVerifyCodeFailed:(NSString *)error
{
    [self.delegate logInVerifyPhoneNumberAndVerifyCodeBLFailed:error];
}
#pragma ----------RegistDAO代理方法 手机号登录校验手机号和验证码 end--------------

#pragma ----------RegistDAO代理方法 手机号登录获取验证码--------
-(void)logInByPhoneNumForGetVerifyCodeFinished:(NSInteger)value
{
    [self.delegate logInByPhoneNumForGetVerifyCodeBLFinished:value];
}

-(void)logInByPhoneNumForGetVerifyCodeFailed:(NSString *)error
{
    [self.delegate logInByPhoneNumForGetVerifyCodeBLFailed:error];
}
#pragma ----------RegistDAO代理方法 手机号登录获取验证码 end--------

#pragma  ---------RegistDAO 代理方法 用户名登录获取校验码 ---------------
-(void)findAllFinished:(NSInteger)value
{
    [self.delegate findAllRegistInfoFinished:value];
}

-(void)findAllFailed:(NSString *)error
{
    [self.delegate findAllRegistInfoFailed:error];
}
#pragma ----------RegistDAO 代理方法 用户名登录获取校验码 end----------

#pragma ----------RegistDAO 注册代理方法--------------------
-(void)registFinished:(NSInteger)value
{
    [self.delegate regist_BL_Finished:value];
}

-(void)registFailed:(NSString *)error
{
    [self.delegate regist_BL_Failed:error];
}
#pragma ----------RegistDAO 注册代理方法 end--------------------

#pragma ----------RegistDAO 登录代理方法------------------------
-(void)logInPassDicInfoFinishedDAO:(NSDictionary *)userInfo
{
    [self.delegate logInPassDicInfoFinishedBL:userInfo];
}

-(void)logInPassDicInfoFailedDAO:(NSString *)error
{
    [self.delegate logInPassDicInfoFailedBL:error];
}
#pragma ----------RegistDAO 登录代理方法 end------------------------

@end
