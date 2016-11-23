
//
//  logInDAO.m
//  FleaMarket
//
//  Created by Hou on 4/22/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "logInDAO.h"
#import "userInfoVO.h"
#import <BmobSDK/BmobFile.h>
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobQuery.h>
#import <BmobSDK/BmobObjectsBatch.h>
#import "CreateAndSearchPlist.h"
#import "UIImageView+WebCache.h"
#import "UserInfoSingleton.h" // by 仝磊鸣, 2016-7-22

@implementation logInDAO

NSMutableArray *mutableArray;
NSMutableDictionary *userInfo;
static logInDAO *sharedManager = nil;
UIImageView *imageViewHeadTemp;
UIImageView *imageViewBKTemp;

//用于使用SDWebImage， 无实际意义
UIImageView *headImageViewLogIn;
UIImageView *backgroundImageViewLogIn;

+(logInDAO *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
        userInfo = [[NSMutableDictionary alloc] init];
    });
    return sharedManager;
}

/**************************************************************
 修改个人信息上传服务器
 dic：包含 nickName gender liveCity personalSignature
 backgroundImage：背景图像
 headImage：头像
 *************************************************************/
-(void)cacheAndUploadPersonalLogInInfo:(NSMutableDictionary *)dic backgroundImage:(UIImage *)backgroundImage headImage:(UIImage *)headImage
{
    NSData *headImageData = UIImageJPEGRepresentation(headImage, 0.5);
    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys: @"headImage.png", @"filename", headImageData, @"data",nil];
    NSData *backgroundImageData = UIImageJPEGRepresentation(backgroundImage, 0.5);
    NSDictionary *dic2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"backgroundImage.png", @"filename",backgroundImageData, @"data", nil];
    NSArray *array = @[dic1, dic2];
    //上传文件，dataArray 数组中存放NSDictionary，NSDictionary里面的格式为@{@"filename":@"你的文件名",@"data":文件的data}
    [BmobFile filesUploadBatchWithDataArray:array progressBlock:^(int index, float progress) {
        NSLog(@"index %lu progress %f",(unsigned long)index,progress);
    } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
        if(error)
        {
            NSLog(@"%@", error.localizedDescription);
            [self.delegate modifyPersonalInfoFailedDAO:@"Upload picture failed"];
        }
        else{
            NSLog(@"%@", array);
            for(int i = 0; i < [array count]; i++)
            {
                BmobFile *file = [array objectAtIndex: i];
                NSLog(@"%@, %@", file.url, file.name);
                if(i == 0)
                {
                    [dic setObject:file.url forKey:@"avatar"];
                }else{
                    [dic setObject:file.url forKey:@"backgroundImageURL"];
                }
            }
            //通过用户名获取objectID，用于更新数据
            BmobQuery *query = [BmobUser query];
            BmobUser *curUser = [BmobUser getCurrentUser];
            [query whereKey:@"username" equalTo:curUser];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if(error){
                    NSLog(@"%@", error.localizedDescription);
                    [self.delegate modifyPersonalInfoFailedDAO:@"查询用户名失败"];
                }else{
                    //更新数据
                    BmobUser *user = [BmobUser getCurrentUser];
                    BmobObjectsBatch *bmobBatch = [[BmobObjectsBatch alloc] init];
                    [bmobBatch updateBmobObjectWithClassName:@"_User" objectId:user.objectId parameters:dic];
                    [bmobBatch batchObjectsInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if(isSuccessful)
                        {
                            [self.delegate modifyPersonalInfoFinishedDAO:isSuccessful];
                            NSLog(@"更新数据成功");
                        }else{
                            [self.delegate modifyPersonalInfoFailedDAO:@"更新数据失败"];
                            NSLog(@"%@", error.localizedDescription);
                        }
                    }];
                }
            }];
        }

    }];
}

/**************************************************************
 个人主页向服务器或本地缓存请求数据
 dic：包含 nickName gender liveCity personalSignature
 backgroundImage：背景图像
 headImage：头像
 date：2016-04-28 14：36 created by houym
 *************************************************************/
-(void)requestDataFromServerOrPlist:(NSString *)plistName
{
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    BmobQuery *query = [BmobUser query];
    BmobUser *user = [BmobUser getCurrentUser];
    [query whereKey:@"username" equalTo:user.username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if(error){
            NSLog(@"%@",error);
            [self.delegate headImageDataTransmitBackFailedDAO:@"服务器无响应"];
        }else if(![array count]){
            [self.delegate headImageDataTransmitBackFailedDAO:@"服务器无用户详细数据"];
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
            
            //回传用户信息，除图片外的信息
            if(userInfo != nil){
                // by 仝磊鸣，登陆成功后检查coreData中user是否有当前用户数据，如果没有，则插入。 2016-7-22
                UserInfoSingleton *userInfoSingleton = [UserInfoSingleton sharedManager];
                [userInfoSingleton updateUserMO:userInfo];
                [self.delegate userInfoTransmitBackFinishedDAO:userInfo];
            }else{
                [self.delegate userInfoTransmitBackFailedDAO:@"用户信息无内容"];
            }
            imageViewHeadTemp = [[UIImageView alloc] init];
            NSURL *url = [NSURL URLWithString:[obj objectForKey:@"avatar"]];
            if(!_curUserDefaults){
                _curUserDefaults = [NSUserDefaults standardUserDefaults];
            }
            NSString *strURL = [url absoluteString];
            [_curUserDefaults setObject:strURL forKey:@"curUserHeadImageURL"];
            [imageViewHeadTemp sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(error){
                    NSLog(@"从服务其获取头像图片失败");
                    [self.delegate headImageDataTransmitBackFailedDAO:@"获取头像失败"];
                }else{
                    NSLog(@"获取头像成功");
                    [self.delegate headImageDataTransmitBackFinishedDAO:image userTextInfo:userInfo];
                }
            }];
            imageViewBKTemp = [[UIImageView alloc] init];
            [imageViewBKTemp sd_setImageWithURL:[obj objectForKey:@"backgroundImageURL"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(error){
                    NSLog(@"从服务器获取头像图片失败");
                    [self.delegate backgroundImageDataTransmitBackFailedDAO:@"获取背景图片失败"];
                }else{
                    NSLog(@"获取头像成功");
                    [self.delegate backgroundImageDataTransmitBackFinishedDAO:image];
                }
            }];

        }
    }];
}

@end
