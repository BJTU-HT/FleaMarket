//
//  RegistBL.h
//  FleaMarket
//
//  Created by Hou on 4/18/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistDAODelegate.h"
#import "LogInAndRegistLogicDelegate.h"
#import "RegistDAO.h"

@interface RegistBL : NSObject<RegistDAODelegate>

@property (weak, nonatomic) id<LogInAndRegistLogicDelegate> delegate;

//发送请求获取手机验证码
-(void)phoneNumberRegistGetShortMessage:(NSString *)phoneNumber;

//注册请求逻辑层处理
-(void)registLogicDeal:(NSDictionary *)registBLInfo;

//登录验证函数 逻辑层处理
-(void)searchUserInfoBL:(NSString *)userName secret:(NSString *)passWord;

//手机号码登录 获取验证码
-(void)getPhoneVerifyCodeBL:(NSString *)phoneNumber;

//手机号登录 校验手机号和验证码
-(void)verifyPhoneNumberAndVerifyCodeBL: (NSString *)phoneNumber code: (NSString *)verifyCode;

//注册时检验该手机号码是否被注册过
-(void)checkMobilePhoneNumberRegistedOrNotBL:(NSString *)phoneNumber;
@end
