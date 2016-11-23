//
//  RegistDAO.m
//  FleaMarket
//
//  Created by Hou on 4/18/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "RegistDAO.h"
#import <BmobSDK/BmobSMS.h>
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobQuery.h>
#import <BmobSDK/BmobUser.h>         //用户管理
#import "RegistBL.h"
#import "CreateAndSearchPlist.h"
#import "UserInfoSingleton.h"

@implementation RegistDAO
@synthesize delegate;

static RegistDAO *sharedManager = nil;
NSUserDefaults *userDefaults;

+(RegistDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
        userDefaults = [NSUserDefaults standardUserDefaults];
    });
    return sharedManager;
}
#pragma 使用BmobUser进行用户管理，包括注册和登录，为了方便聊天界面的开发决定替换---------------
//获取手机验证码
-(void)getVerifyCodeMessageFromPersistDAO:(NSString *)phoneNumber{
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:phoneNumber
                                           andTemplate:@"verifySM"
                                           resultBlock:^(int number, NSError *error) {
                                               NSLog(@"%@", [error description]);
                                               if(error)
                                               {
                                                   NSLog(@"%@", [error description]);
                                                   [self.delegate findAllFailed: @"验证码获取失败"];
                                               }
                                               else
                                               {
                                                   [self.delegate findAllFinished:1];
                                               }
                                               
                                           }];
}

//通过手机注册时检测该手机号是否已被注册（一个手机号对应一个用户名）
-(void)checkMobilePhoneNumberRegistedOrNotDAO:(NSString *)phoneNumber{
    BmobQuery *query = [BmobUser query];
    [query whereKey:@"mobilePhoneNumber" equalTo:phoneNumber];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if(![array count]){
            [self.delegate checkPhoneNumberRegisteredOrNotFinishedDAO:1];
        }else{
            [self.delegate checkPhoneNumberRegisteredOrNotFailedDAO:THIS_MOBILENUMBER_HAS_BEEN_REGISTED];
        }
    }];
}
//注册，上传注册信息
-(void)registByPhone:(NSDictionary *)registInfo{
    
    BmobUser *buser = [[BmobUser alloc] init];
    buser.mobilePhoneNumber = [registInfo objectForKey:@"phoneNumber"];
    NSString *str = [registInfo objectForKey:@"passWord"];
    [buser setPassword:str];
    buser.username = [registInfo objectForKey:@"userName"];
    [buser signUpOrLoginInbackgroundWithSMSCode:[registInfo objectForKey:@"verifyCode"] block:^(BOOL isSuccessful, NSError *error) {
        if (error) {
            NSLog(@"注册失败");
            [self.delegate registFailed:@"注册失败"];
        } else {
            NSLog(@"注册成功！");
            [self.delegate registFinished:1];
            //添加此条目用于在本机存储当前用户名
//            [userDefaults setObject:[registInfo objectForKey:@"userName"] forKey:@"userName"];
//            CreateAndSearchPlist *writeToPlistRegistInfo = [[CreateAndSearchPlist alloc] init];
//            NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
//            [dicInfo addEntriesFromDictionary:registInfo];
//            [writeToPlistRegistInfo writeToPlist:@"userInfo.plist" writeContent:dicInfo];
        }
    }];
}

//用户名和密码登录
-(void)searchUserInfo:(NSString *)userName secret:(NSString *)passWord{
    [BmobUser loginInbackgroundWithAccount:userName andPassword:passWord block:^(BmobUser *user, NSError *error) {
        if (user) {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            BmobQuery *query = [BmobUser query];
            BmobUser *user = [BmobUser getCurrentUser];
            [query whereKey:@"username" equalTo:user.username];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if(error){
                    [self.delegate logInPassDicInfoFailedDAO:@"用户名或密码错误"];
                }else if(![array count]){
                    [self.delegate logInPassDicInfoFailedDAO:@"用户名或密码错误"];
                }else{
                    BmobObject *obj = [array objectAtIndex:0];
                    if([obj objectForKey:@"backgroundImageURL"] != nil)
                        [userInfo setObject:[obj objectForKey:@"backgroundImageURL"] forKey:@"backgroundImageURL"];
                    if([obj objectForKey:@"concerned"] != nil)
                        [userInfo setObject:[obj objectForKey:@"concerned"] forKey:@"concerned"];
                    if([obj objectForKey:@"fans"] != nil)
                        [userInfo setObject:[obj objectForKey:@"fans"] forKey:@"fans"];
                    if(nil != [obj objectForKey:@"gender"])
                        [userInfo setObject:[obj objectForKey:@"gender"] forKey:@"gender"];
                    if(nil != [obj objectForKey:@"avatar"])
                        [userInfo setObject:[obj objectForKey:@"avatar"] forKey:@"avatar"];
                    if(nil != [obj objectForKey:@"liveCity"])
                        [userInfo setObject:[obj objectForKey:@"liveCity"] forKey:@"liveCity"];
                    if(nil != [obj objectForKey:@"nickName"])
                        [userInfo setObject:[obj objectForKey:@"nickName"] forKey:@"nickName"];
                    if(nil != [obj objectForKey:@"personalSignature"])
                        [userInfo setObject:[obj objectForKey:@"personalSignature"] forKey:@"personalSignature"];
                    if(nil != [obj objectForKey:@"passWord"])
                        [userInfo setObject:[obj objectForKey:@"passWord"] forKey:@"passWord"];
                    if(nil != [obj objectForKey:@"phoneNumber"])
                        [userInfo setObject:[obj objectForKey:@"phoneNumber"] forKey:@"phoneNumber"];
                    if(nil != [obj objectForKey:@"userName"])
                        [userInfo setObject:[obj objectForKey:@"username"] forKey:@"userName"];
                    if(nil != [obj objectForKey:@"username"])
                        [userInfo setObject:[obj objectForKey:@"username"] forKey:@"username"];
                    // by 仝磊鸣，设置userInfo的userId, 2016-7-22
                    if(nil != [obj objectForKey:@"objectId"])
                        [userInfo setObject:[obj objectForKey:@"objectId"] forKey:@"userID"];
                    [self.delegate logInPassDicInfoFinishedDAO:userInfo];
                    //回传用户信息，除图片外的信息
                    if(userInfo != nil){
                        // by 仝磊鸣，登陆成功后检查coreData中user是否有当前用户数据，如果没有，则插入。 2016-7-22
                        UserInfoSingleton *userInfoSingleton = [UserInfoSingleton sharedManager];
                        [userInfoSingleton updateUserMO:userInfo];
                    }else{
                        NSLog(@"更新coreData失败");
                    }
                }
            }];
        } else {
            NSLog(@"%@",error);
            [self.delegate logInPassDicInfoFailedDAO:@"用户名或密码错误"];
        }
    }];
}

//手机号和验证码登录
-(void)verifyPhoneNumberAndVerifyCode:(NSString *)phoneNumber veifyCode:(NSString *)code{
    [BmobUser loginInbackgroundWithMobilePhoneNumber:phoneNumber andSMSCode:code block:^(BmobUser *user, NSError *error) {
        if (user) {
            NSLog(@"%@",user);
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            BmobQuery *query = [BmobUser query];
            BmobUser *user = [BmobUser getCurrentUser];
            [query whereKey:@"username" equalTo:user.username];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if(error){
                    [self.delegate logInVerifyPhoneNumberAndVerifyCodeFailed:@"用户名或密码错误"];
                }else if(![array count]){
                    [self.delegate logInVerifyPhoneNumberAndVerifyCodeFailed:@"用户名或密码错误"];
                }else{
                    BmobObject *obj = [array objectAtIndex:0];
                    if([obj objectForKey:@"backgroundImageURL"] != nil)
                        [userInfo setObject:[obj objectForKey:@"backgroundImageURL"] forKey:@"backgroundImageURL"];
                    if([obj objectForKey:@"concerned"] != nil)
                        [userInfo setObject:[obj objectForKey:@"concerned"] forKey:@"concerned"];
                    if([obj objectForKey:@"fans"] != nil)
                        [userInfo setObject:[obj objectForKey:@"fans"] forKey:@"fans"];
                    if(nil != [obj objectForKey:@"gender"])
                        [userInfo setObject:[obj objectForKey:@"gender"] forKey:@"gender"];
                    if(nil != [obj objectForKey:@"avatar"])
                        [userInfo setObject:[obj objectForKey:@"avatar"] forKey:@"avatar"];
                    if(nil != [obj objectForKey:@"liveCity"])
                        [userInfo setObject:[obj objectForKey:@"liveCity"] forKey:@"liveCity"];
                    if(nil != [obj objectForKey:@"nickName"])
                        [userInfo setObject:[obj objectForKey:@"nickName"] forKey:@"nickName"];
                    if(nil != [obj objectForKey:@"personalSignature"])
                        [userInfo setObject:[obj objectForKey:@"personalSignature"] forKey:@"personalSignature"];
                    if(nil != [obj objectForKey:@"passWord"])
                        [userInfo setObject:[obj objectForKey:@"passWord"] forKey:@"passWord"];
                    if(nil != [obj objectForKey:@"phoneNumber"])
                        [userInfo setObject:[obj objectForKey:@"phoneNumber"] forKey:@"phoneNumber"];
                    if(nil != [obj objectForKey:@"userName"])
                        [userInfo setObject:[obj objectForKey:@"username"] forKey:@"userName"];
                    if(nil != [obj objectForKey:@"username"])
                        [userInfo setObject:[obj objectForKey:@"username"] forKey:@"username"];
                    if(nil != [obj objectForKey:@"mobilePhoneNumber"])
                        [userInfo setObject:[obj objectForKey:@"mobilePhoneNumber"] forKey:@"mobilePhoneNumber"];
                    if(nil != [obj objectForKey:@"mobilePhoneNumberVerified"])
                        [userInfo setObject:[obj objectForKey:@"mobilePhoneNumberVerified"] forKey:@"mobilePhoneNumberVerified"];
                    // by 仝磊鸣，设置userInfo的userId, 2016-7-22
                    if(nil != [obj objectForKey:@"objectId"])
                        [userInfo setObject:[obj objectForKey:@"objectId"] forKey:@"userID"];
                    [self.delegate logInVerifyPhoneNumberAndVerifyCodeFinished: userInfo];
                    //回传用户信息，除图片外的信息
                    if(userInfo != nil){
                        // by 仝磊鸣，登陆成功后检查coreData中user是否有当前用户数据，如果没有，则插入。 2016-7-22
                        UserInfoSingleton *userInfoSingleton = [UserInfoSingleton sharedManager];
                        [userInfoSingleton updateUserMO:userInfo];
                    }else{
                        NSLog(@"更新coreData失败");
                    }
                }
            }];

        } else {
            NSLog(@"%@",error);
            NSLog(@"验证码校验失败");
            [self.delegate logInVerifyPhoneNumberAndVerifyCodeFailed:@"验证码校验失败"];
        }
    }];
}

//通过手机号码验证码形式直接登录，本函数用于获取验证码
-(void)getPhoneVerifyCode:(NSString *)phoneNumber
{
    BmobQuery *query = [BmobQuery queryWithClassName:@"user"];
    [query whereKey:@"phoneNumber" equalTo:phoneNumber];
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:phoneNumber
                                           andTemplate:@"verifySM"
                                           resultBlock:^(int number, NSError *error) {
                                               NSLog(@"%@", [error description]);
                                               if(error)
                                               {
                                                   NSLog(@"%@", [error description]);
                                                   [self.delegate logInByPhoneNumForGetVerifyCodeFailed: @"验证码获取失败"];
                                               }
                                               else
                                               {
                                                   [self.delegate logInByPhoneNumForGetVerifyCodeFinished:1];
                                               }
                                               
                                           }];
}
#pragma 使用BmobUser进行用户管理，包括注册和登录，为了方便聊天界面的开发决定替换 end-----------

-(void)getDetailedUserInfoDAO{
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    BmobQuery *query = [BmobUser query];
    BmobUser *user = [BmobUser getCurrentUser];
    [query whereKey:@"username" equalTo:user.username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if(error){
            
        }else if(![array count]){
            
        }else{
            BmobObject *obj = [array objectAtIndex:0];
            if([obj objectForKey:@"backgroundImageURL"] != nil)
                [userInfo setObject:[obj objectForKey:@"backgroundImageURL"] forKey:@"backgroundImageURL"];
            if([obj objectForKey:@"concerned"] != nil)
                [userInfo setObject:[obj objectForKey:@"concerned"] forKey:@"concerned"];
            if([obj objectForKey:@"fans"] != nil)
                [userInfo setObject:[obj objectForKey:@"fans"] forKey:@"fans"];
            if(nil != [obj objectForKey:@"gender"])
                [userInfo setObject:[obj objectForKey:@"gender"] forKey:@"gender"];
            if(nil != [obj objectForKey:@"avatar"])
                [userInfo setObject:[obj objectForKey:@"avatar"] forKey:@"avatar"];
            if(nil != [obj objectForKey:@"liveCity"])
                [userInfo setObject:[obj objectForKey:@"liveCity"] forKey:@"liveCity"];
            if(nil != [obj objectForKey:@"nickName"])
                [userInfo setObject:[obj objectForKey:@"nickName"] forKey:@"nickName"];
            if(nil != [obj objectForKey:@"personalSignature"])
                [userInfo setObject:[obj objectForKey:@"personalSignature"] forKey:@"personalSignature"];
            if(nil != [obj objectForKey:@"passWord"])
                [userInfo setObject:[obj objectForKey:@"passWord"] forKey:@"passWord"];
            if(nil != [obj objectForKey:@"phoneNumber"])
                [userInfo setObject:[obj objectForKey:@"phoneNumber"] forKey:@"phoneNumber"];
            if(nil != [obj objectForKey:@"userName"])
                [userInfo setObject:[obj objectForKey:@"username"] forKey:@"userName"];
            
            // by 仝磊鸣，设置userInfo的userId, 2016-7-22
            if(nil != [obj objectForKey:@"objectId"])
                [userInfo setObject:[obj objectForKey:@"objectId"] forKey:@"userID"];
            
            //回传用户信息，除图片外的信息
            if(userInfo != nil){
                // by 仝磊鸣，登陆成功后检查coreData中user是否有当前用户数据，如果没有，则插入。 2016-7-22
                UserInfoSingleton *userInfoSingleton = [UserInfoSingleton sharedManager];
                [userInfoSingleton updateUserMO:userInfo];
            }else{
                
            }
        }
    }];

}
@end
