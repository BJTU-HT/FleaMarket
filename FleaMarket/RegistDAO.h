//
//  RegistDAO.h
//  FleaMarket
//
//  Created by Hou on 4/18/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistDAODelegate.h"

@interface RegistDAO : NSObject

@property (strong, nonatomic)id <RegistDAODelegate> delegate;

-(void)getVerifyCodeMessageFromPersistDAO:(NSString *)phoneNumber;
+(RegistDAO *)sharedManager;

//注册请求，已获取验证码
-(void)registByPhone:(NSDictionary *)registInfo;

//普通登录验证函数
-(void)searchUserInfo:(NSString *)userName secret:(NSString *)passWord;

//手机号码登录获取验证码函数
-(void)getPhoneVerifyCode:(NSString *)phoneNumber;

//手机号码登录校验手机号和验证码
-(void)verifyPhoneNumberAndVerifyCode:(NSString *)phoneNumber veifyCode:(NSString *)code;

//检验该手机号是否被注册过
-(void)checkMobilePhoneNumberRegistedOrNotDAO:(NSString *)phoneNumber;
@end
