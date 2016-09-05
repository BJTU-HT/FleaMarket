//
//  presentLayerPublicMethod.h
//  FleaMarket
//
//  Created by Hou on 4/21/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface presentLayerPublicMethod : NSObject
-(void)startTime:(UIButton *)buttonSM;
//屏幕顶部弹出自定义动画 私有方法
-(void)notifyView:(UINavigationController *)navCon notifyContent:(NSString *)content;

//屏幕顶端弹出自定义动画 公有方法， 同上， 只是为了调用方便而修改，内容无变化
+(void)new_notifyView:(UINavigationController *)navCon notifyContent:(NSString *)content;

-(void)popView:(CGRect)frame superView:(UIView *)view content:(NSString *)content;

//弹出Alert提示框
-(void)popAlertView:(NSString *)title detailedMessage:(NSString *)message actionConfirm:(NSString *)confirm  actionCancel:(NSString *)cancel view:(UIView *)view;
@end
