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
            [userDefaults setObject:[registInfo objectForKey:@"userName"] forKey:@"userName"];
            CreateAndSearchPlist *writeToPlistRegistInfo = [[CreateAndSearchPlist alloc] init];
            NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
            [dicInfo addEntriesFromDictionary:registInfo];
            [writeToPlistRegistInfo writeToPlist:@"userInfo.plist" writeContent:dicInfo];
        }
    }];
}

//用户名和密码登录
-(void)searchUserInfo:(NSString *)userName secret:(NSString *)passWord{
    [BmobUser loginInbackgroundWithAccount:userName andPassword:passWord block:^(BmobUser *user, NSError *error) {
        if (user) {
            NSLog(@"%@",user);
            NSDictionary *userDic = (NSDictionary *)user;
            [self.delegate logInPassDicInfoFinishedDAO:userDic];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:userName forKey:@"userName"];
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
            [self.delegate logInVerifyPhoneNumberAndVerifyCodeFinished: 1];
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

////手机快速注册页面获取验证码及确认该手机号是否已经被注册过
//-(void)getVerifyCodeMessageFromPersistDAO:(NSString *)phoneNumber
//{
//    BmobQuery *query = [BmobQuery queryWithClassName:@"user"];
//    [query whereKey:@"phoneNumber" equalTo:phoneNumber];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//        if(![array count])
//        {
//            [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:phoneNumber
//                                                   andTemplate:@"verifySM"
//                                                   resultBlock:^(int number, NSError *error) {
//                                                       NSLog(@"%@", [error description]);
//                                                       if(error)
//                                                       {
//                                                           NSLog(@"%@", [error description]);
//                                                           [self.delegate findAllFailed: @"验证码获取失败"];
//                                                       }
//                                                       else
//                                                       {
//                                                           [self.delegate findAllFinished:1];
//                                                       }
//                                                       
//                                                   }];
//        }
//        else
//        {
//            [self.delegate findAllFailed:@"该手机号已被注册"];
//        }
//    }];
//}
//
////手机快速注册。已确认该手机号未被注册过且已获得手机验证码，进行验证码校验，如成功则上传注册信息
//-(void)registByPhone:(NSDictionary *)registInfo
//{
//    BmobObject *bmobObj = [[BmobObject alloc] initWithClassName:@"user"];
//    [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:[registInfo objectForKey:@"phoneNumber"] andSMSCode:[registInfo objectForKey:@"verifyCode"] resultBlock:^(BOOL isSuccessful, NSError *error) {
//        if(isSuccessful)
//        {
//            [bmobObj saveAllWithDictionary:registInfo];
//            [bmobObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//                if(isSuccessful)
//                {
//                    NSLog(@"注册成功！");
//                    [self.delegate registFinished:1];
//                    //添加此条目用于在本机存储当前用户名
//                    [userDefaults setObject:[registInfo objectForKey:@"userName"] forKey:@"userName"];
//                    CreateAndSearchPlist *writeToPlistRegistInfo = [[CreateAndSearchPlist alloc] init];
//                    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
//                    [dicInfo addEntriesFromDictionary:registInfo];
//                    [writeToPlistRegistInfo writeToPlist:@"userInfo.plist" writeContent:dicInfo];
//                }
//                else
//                {
//                    NSLog(@"Fail");
//                    [self.delegate registFailed:@"注册失败"];
//                }
//            }];
//        }
//        else
//        {
//            NSLog(@"验证码校验失败");
//            [self.delegate registFailed:@"验证码校验失败"];
//        }
//    }];
//
//}
////用户名和密码登录
////通过用户名和密码确认该用户是否存在，如存在返回用户的详细信息，包括头像等
//-(void)searchUserInfo:(NSString *)userName secret:(NSString *)passWord
//{
//    BmobQuery *bmobQuery = [BmobQuery queryWithClassName:@"user"];
//    NSString *bql = @"select * from user where userName = ? and passWord = ?";
//    NSArray *placeholderArray = @[userName, passWord];
//    [bmobQuery queryInBackgroundWithBQL:bql pvalues:placeholderArray block:^(BQLQueryResult *result, NSError *error) {
//        if (error) {
//            NSLog(@"%@",error);
//            [self.delegate logInPassDicInfoFailedDAO:@"请求失败"];
//        } else {
//            if(result)
//            {
//                if([result.resultsAry count] == 0)
//                {
//                    [self.delegate logInPassDicInfoFailedDAO:@"用户名或密码错误"];
//                }
//                else
//                {
//                    BmobObject *obj = [result.resultsAry objectAtIndex:0];
//                    NSDictionary *userDic = (NSDictionary *)obj;
//                    [self.delegate logInPassDicInfoFinishedDAO:userDic];
//                    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//                    [userDefault setObject:userName forKey:@"userName"];
//                }
//            }
//
//        }
//    }];
//}

////通过手机号码验证码形式直接登录，本函数用于获取验证码
//-(void)getPhoneVerifyCode:(NSString *)phoneNumber
//{
//    BmobQuery *query = [BmobQuery queryWithClassName:@"user"];
//    [query whereKey:@"phoneNumber" equalTo:phoneNumber];
//    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:phoneNumber
//                                        andTemplate:@"verifySM"
//                                        resultBlock:^(int number, NSError *error) {
//                                        NSLog(@"%@", [error description]);
//                                        if(error)
//                                        {
//                                            NSLog(@"%@", [error description]);
//                                            [self.delegate logInByPhoneNumForGetVerifyCodeFailed: @"验证码获取失败"];
//                                        }
//                                        else
//                                        {
//                                            [self.delegate logInByPhoneNumForGetVerifyCodeFinished:1];
//                                        }
//                                                       
//    }];
//}

//校验手机号和验证码
//-(void)verifyPhoneNumberAndVerifyCode:(NSString *)phoneNumber veifyCode:(NSString *)code
//{
//        [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:phoneNumber andSMSCode:code resultBlock:^(BOOL isSuccessful, NSError *error) {
//        if(isSuccessful)
//        {
//            [self.delegate logInVerifyPhoneNumberAndVerifyCodeFinished: 1];
//        }
//        else
//        {
//            NSLog(@"验证码校验失败");
//            [self.delegate logInVerifyPhoneNumberAndVerifyCodeFailed:@"验证码校验失败"];
//        }
//    }];
//
//}

@end