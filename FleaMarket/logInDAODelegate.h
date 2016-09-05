
//
//  logInDAODelegate.h
//  FleaMarket
//
//  Created by Hou on 4/22/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef logInDAODelegate_h
#define logInDAODelegate_h

@class logInDAO;

@protocol logInDAODelegate <NSObject>

//登录后修改个人信息页面数据更新结果回传给ViewController
-(void)modifyPersonalInfoFinishedDAO:(NSInteger)value;
-(void)modifyPersonalInfoFailedDAO:(NSString *)error;

//个人信息页面从服务器获或缓存获取图像信息 数据回传
-(void)headImageDataTransmitBackFinishedDAO:(UIImage *)image userTextInfo:(NSDictionary *)userInfo;
-(void)headImageDataTransmitBackFailedDAO:(NSString *)error;

-(void)backgroundImageDataTransmitBackFinishedDAO:(UIImage *)image;
-(void)backgroundImageDataTransmitBackFailedDAO:(NSString *)error;

//从服务器或者缓存获取用户信息，除图片以外的文本信息
-(void)userInfoTransmitBackFinishedDAO:(NSDictionary *)userInfo;
-(void)userInfoTransmitBackFailedDAO:(NSString *)error;

@end
#endif /* logInDAODelegate_h */
