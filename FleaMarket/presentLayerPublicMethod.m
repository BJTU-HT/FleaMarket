//
//  presentLayerPublicMethod.m
//  FleaMarket
//
//  Created by Hou on 4/21/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "presentLayerPublicMethod.h"

@implementation presentLayerPublicMethod

-(void)startTime:(UIButton *)buttonSM{
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [buttonSM setTitle:@"获取验证码" forState:UIControlStateNormal];
                buttonSM.userInteractionEnabled = YES;
                buttonSM.backgroundColor = orangColorPCH;
                buttonSM.titleLabel.font = FontSize18;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [buttonSM setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                buttonSM.backgroundColor = grayColorPCH;
                buttonSM.titleLabel.font = FontSize12;
                buttonSM.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma 验证码发送后弹出动画 从屏幕上方弹出
-(void)notifyView:(UINavigationController *)navCon notifyContent:(NSString *)content
{
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, -64, screenWidthPCH, 64)];
    label.text = content;
    label.textColor = orangColorPCH;
    label.backgroundColor = navajoWhitePCH;
    label.textAlignment = NSTextAlignmentCenter;
    [navCon.view insertSubview:label aboveSubview:navCon.navigationBar];
    [UIView animateWithDuration:0.5 animations:^{
        label.frame = CGRectMake(0, 0, screenWidthPCH, 64);
    } completion:^(BOOL finished) {
        //弹出后停留两秒
        [UIView setAnimationDuration:2.0];
        [UIView animateWithDuration:3.0 animations:^{
            label.frame = CGRectMake(0, -64, screenWidthPCH, 64);
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

//变成公有方法，方便调用，以前已经调用私有方法的不做修改
+(void)new_notifyView:(UINavigationController *)navCon notifyContent:(NSString *)content
{
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, -64, screenWidthPCH, 64)];
    label.text = content;
    label.textColor = orangColorPCH;
    label.backgroundColor = navajoWhitePCH;
    label.textAlignment = NSTextAlignmentCenter;
    [navCon.view insertSubview:label aboveSubview:navCon.navigationBar];
    [UIView animateWithDuration:0.5  animations:^{
        label.frame = CGRectMake(0, 0, screenWidthPCH, 64);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:1.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            label.frame = CGRectMake(0, -64, screenWidthPCH, 64);
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];

    }];
}
#pragma 验证码发送后弹出动画end

#pragma 在屏幕中央弹出视图
-(void)popView:(CGRect)frame superView:(UIView *)view content:(NSString *)content
{
    UILabel *label = [[UILabel alloc] initWithFrame: frame];
    label.text = content;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 10;
    [view addSubview:label];
    [UIView animateWithDuration:3.0 animations:^{
    } completion:^(BOOL finished) {
        //弹出后停留两秒
        sleep(1);
        [label removeFromSuperview];
    }];
}
#pragma 在屏幕中央弹出视图 end

#pragma 屏幕中央弹出Alert提示框----------------
-(void)popAlertView:(NSString *)title detailedMessage:(NSString *)message actionConfirm:(NSString *)confirm  actionCancel:(NSString *)cancel view:(UIView *)view{
    UIAlertController *alertConLogOut = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertConfirm = [UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:nil];
    [alertConLogOut addAction:alertConfirm];
    [alertConLogOut addAction:alertCancel];
    [view.window.rootViewController presentViewController:alertConLogOut animated:NO completion:nil];
}

#pragma 屏幕中央弹出Alert提示框 end-------------

@end
