//
//  registViewController.m
//  TestDemo1
//
//  Created by Hou on 2/23/16.
//  Copyright © 2016 Hou. All rights reserved.
//

#import "registViewController.h"
#import "logInViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobSMS.h>
#import "RegistBL.h"
#import "presentLayerPublicMethod.h"

@interface registViewController ()

@end

@implementation registViewController
float screenWidthRegist;
float screenHeightRegist;
CGRect screenFrameRegist;
UILabel *labelName;
UILabel *labelPassword1;
UITextField *textFieldPN;
UITextField *textFieldPassword;
UITextField *textFieldName;
UITextField *textFieldSM;
UIButton *buttonSM;   //获取验证码按钮
UIButton *buttonFinishRegist; //注册按钮
NSUserDefaults *registDefault;

- (void)viewDidLoad {
    [super viewDidLoad];
    //screenFrameRegist = [UIScreen mainScreen].applicationFrame;
    screenFrameRegist =self.view.bounds;
    screenWidthRegist = screenFrameRegist.size.width;
    screenHeightRegist = screenFrameRegist.size.height;
    self.title = @"手机快速注册";
    [self drawRegist];
    // Do any additional setup after loading the view.
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma 验证码发送后弹出动画
-(void)popUPAnimination
{
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(screenWidthPCH/4.0, screenHeightPCH/2.0, screenWidthPCH/2.0, 50)];
    label1.text = @"验证码已发送";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.layer.cornerRadius = 18.0;
    label1.backgroundColor = orangColorPCH;
    [self.view insertSubview: label1 atIndex:1];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationDelegate:self];
    label1.alpha =0.0;
    [UIView commitAnimations];
}
#pragma 验证码发送后弹出动画end
//绘制注册页面
-(void)drawRegist
{
    //手机号
    UILabel *labelPhoneNumber = [[UILabel alloc] init];
    labelPhoneNumber.text = @"手机号";
    labelPhoneNumber.font = FontSize16;
    labelPhoneNumber.textColor = [UIColor blackColor];
    CGRect labelPN = CGRectMake(screenWidthRegist * 0.02, 64, screenWidthRegist * 0.15, screenHeightRegist * 0.10);
    labelPhoneNumber.frame = labelPN;
    [self.view addSubview:labelPhoneNumber];
    
    //pn = phone number
    textFieldPN = [[UITextField alloc] init];
    CGRect textfieldPNFrame = CGRectMake(screenWidthRegist * 0.17, 64, screenWidthRegist * (0.96 - 0.17), screenHeightRegist * 0.10);
    textFieldPN.frame = textfieldPNFrame;
    textFieldPN.delegate = self;
    textFieldPN.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview: textFieldPN];
    
    UIView *viewPN = [[UIView alloc] init];
    CGRect viewPNFrame = CGRectMake(screenWidthRegist * 0.02, 64 + screenHeightRegist * 0.11, screenWidthRegist * 0.96, screenHeightRegist * 0.003);
    viewPN.frame = viewPNFrame;
    viewPN.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self.view addSubview:viewPN];
    
    //短信验证码
    UILabel *shortMessage = [[UILabel alloc] init];
    shortMessage.text = @"短信验证码";
    shortMessage.font = FontSize16;
    shortMessage.textColor = [UIColor blackColor];
    CGRect shortMessageFrame = CGRectMake(screenWidthRegist * 0.02, 64 + screenHeightRegist * 0.12, screenWidthRegist * 0.3, screenHeightRegist * 0.10);
    shortMessage.frame = shortMessageFrame;
    [self.view addSubview:shortMessage];
    
    //短信验证码
    textFieldSM = [[UITextField alloc] init];
    CGRect textfieldSMFrame = CGRectMake(screenWidthRegist * 0.32, 64 + screenHeightRegist * 0.12 , screenWidthRegist * (0.96 - 0.64), screenHeightRegist * 0.10);
    textFieldSM.frame = textfieldSMFrame;
    textFieldSM.delegate = self;
    textFieldSM.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview: textFieldSM];
    
    buttonSM = [[UIButton alloc] init];
    [buttonSM setBackgroundColor:[UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0]];
    [buttonSM setTitle:@"获取验证码" forState: UIControlStateNormal];
    buttonSM.titleLabel.font = FontSize16;
    CGRect buttonGetSMFrame = CGRectMake(screenWidthRegist * 0.67, 64 + screenHeightRegist * 0.13, screenWidthRegist * 0.3, screenHeightRegist * 0.09);
    [buttonSM addTarget:self action:@selector(getVerifyCode:) forControlEvents:UIControlEventTouchDown];
    buttonSM.frame = buttonGetSMFrame;
    [buttonSM.layer setCornerRadius:8];
    buttonSM.titleLabel.font = FontSize18;
    [self.view addSubview:buttonSM];
    
    UIView *viewSM = [[UIView alloc] init];
    CGRect viewSMFrame = CGRectMake(screenWidthRegist * 0.02, 64 + screenHeightRegist * (0.12 + 0.11), screenWidthRegist * 0.96, screenHeightRegist * 0.003);
    viewSM.frame = viewSMFrame;
    viewSM.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self.view addSubview:viewSM];
    
    //昵称
    labelName = [[UILabel alloc] init];
    labelName.text = @"用户名";
    labelName.font = FontSize16;
    labelName.textColor = [UIColor blackColor];
    CGRect labelNameFrame = CGRectMake(screenWidthRegist * 0.02, 64 + screenHeightRegist * 0.24, screenWidthRegist * 0.15, screenHeightRegist * 0.10);
    labelName.frame = labelNameFrame;
    [self.view addSubview:labelName];
    
    textFieldName = [[UITextField alloc] init];
    CGRect textFieldNameFrame = CGRectMake(screenWidthRegist * 0.17, 64 + screenHeightRegist * 0.24, screenWidthRegist * (0.96 - 0.17), screenHeightRegist * 0.10);
    textFieldName.frame = textFieldNameFrame;
    textFieldName.text = @"15个字符以内";
    textFieldName.font = FontSize14;
    textFieldName.clearsOnBeginEditing = YES;
    textFieldName.textColor = [UIColor grayColor];
    textFieldName.delegate = self;
    [self.view addSubview: textFieldName];
    
    UIView *viewName = [[UIView alloc] init];
    CGRect viewNameFrame = CGRectMake(screenWidthRegist * 0.02, 64 + screenHeightRegist * 0.35, screenWidthRegist * 0.96, screenHeightRegist * 0.003);
    viewName.frame = viewNameFrame;
    viewName.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self.view addSubview:viewName];
    
    //密码
    labelPassword1 = [[UILabel alloc] init];
    labelPassword1.text = @"密码";
    labelPassword1.font = FontSize16;
    labelPassword1.textColor = [UIColor blackColor];
    CGRect labelPasswordFrame = CGRectMake(screenWidthRegist * 0.02, 64 + screenHeightRegist * 0.36, screenWidthRegist * 0.15, screenHeightRegist * 0.10);
    labelPassword1.frame = labelPasswordFrame;
    [self.view addSubview:labelPassword1];
    
    //pn = phone number
    textFieldPassword = [[UITextField alloc] init];
    CGRect textFieldPassWordFrame = CGRectMake(screenWidthRegist * 0.17, 64 + screenHeightRegist * 0.36, screenWidthRegist * (0.96 - 0.17), screenHeightRegist * 0.10);
    textFieldPassword.frame = textFieldPassWordFrame;
    textFieldPassword.text = @"5-20位数字与字母";
    textFieldPassword.font = FontSize14;
    textFieldPassword.clearsOnBeginEditing = YES;
    textFieldPassword.textColor = [UIColor grayColor];
    textFieldPassword.delegate = self;
    [self.view addSubview: textFieldPassword];
    
    UIView *viewPassword = [[UIView alloc] init];
    CGRect viewPasswordFrame = CGRectMake(screenWidthRegist * 0.02, 64 + screenHeightRegist * 0.47, screenWidthRegist * 0.96, screenHeightRegist * 0.003);
    viewPassword.frame = viewPasswordFrame;
    viewPassword.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self.view addSubview:viewPassword];
    
    UILabel *labelClick = [[UILabel alloc] init];
    labelClick.text = @"点击完成即同意";
    labelClick.font = FontSize12;
    labelClick.textColor = [UIColor blackColor];
    labelClick.font = [UIFont systemFontOfSize:12];
    CGRect labelclickFrame = CGRectMake(screenWidthRegist * 0.02, 64 + screenHeightRegist * 0.48, screenWidthRegist * 0.24, screenHeightRegist * 0.10);
    labelClick.frame = labelclickFrame;
    [self.view addSubview:labelClick];
    
    UIButton *buttonLabel = [[UIButton alloc] init];
    buttonLabel.titleLabel.font = FontSize12;
    CGRect buttonLabelFrame = CGRectMake(screenWidthRegist * 0.26, 64 + screenHeightRegist * 0.48, screenWidthRegist * 0.44, screenHeightRegist * 0.10);
    [buttonLabel setTitle:@"《书香人家用户注册协议》" forState:UIControlStateNormal];
    [buttonLabel setTitleColor:[UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0] forState:UIControlStateNormal];
    buttonLabel.frame = buttonLabelFrame;
    buttonLabel.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:buttonLabel];
    
    buttonFinishRegist = [[UIButton alloc] init];
    CGRect buttonFRFrame = CGRectMake(screenWidthRegist * 0.02, 64 + screenHeightRegist * 0.60, screenWidthRegist * 0.96, screenHeightRegist * 0.10);
    buttonFinishRegist.frame = buttonFRFrame;
    buttonFinishRegist.titleLabel.font = FontSize16;
    [buttonFinishRegist setTitle:@"完成注册，进入书香人家界面" forState:UIControlStateNormal];
    buttonFinishRegist.backgroundColor = grayColorPCH;
    [buttonFinishRegist addTarget:self action:@selector(buttonRegistClicked:) forControlEvents:UIControlEventTouchDown];
    buttonFinishRegist.userInteractionEnabled = NO;
    [self.view addSubview:buttonFinishRegist];
    
    UILabel *label = [[UILabel alloc] init];
    CGRect labelFrame = CGRectMake(screenWidthRegist * 0.04, 64 + screenHeightRegist * 0.80, screenWidthRegist * 0.96, screenHeightRegist * 0.10);
    label.frame = labelFrame;
    label.text = @"注：暂不支持海外手机号注册，建议第三方登录";
    label.font = FontSize16;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:12];
    [self.view addSubview: label];
}

//获取验证码
-(void)getVerifyCode:(UIButton *)sender
{
    if([textFieldPN.text length] != 11)
    {
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"请您输入11位中国大陆手机号码！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertCon addAction:alertAction];
        [self.view.window.rootViewController presentViewController:alertCon animated:NO completion:nil];
    }
    RegistBL *registGetVerifyCode = [[RegistBL alloc] init];
    registGetVerifyCode.delegate = self;
    [registGetVerifyCode checkMobilePhoneNumberRegistedOrNotBL: textFieldPN.text];
//    [registGetVerifyCode phoneNumberRegistGetShortMessage: textFieldPN.text];
}

//获取验证码倒计时函数
-(void)startTime{
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

-(void)buttonRegistClicked:(UIButton *)sender
{
    NSDictionary *dicToBmob = @{@"phoneNumber":textFieldPN.text, @"verifyCode": textFieldSM.text, @"userName":textFieldName.text, @"passWord": textFieldPassword.text, @"nickName":@"暂未设置", @"userLevel":@"0", @"fans": @"0", @"concerned": @"0", @"avatar": @"0", @"backgroundImageURL": @"0"};
    RegistBL *registReq = [[RegistBL alloc] init];
    registReq.delegate = self;
    [registReq registLogicDeal:dicToBmob];
}
// 注册成功跳转到登录页面
-(void)registSuccess:(UIButton *)sender
{
    self.hidesBottomBarWhenPushed = YES;
    logInViewController *logIn = [[logInViewController alloc] init];
    [self.navigationController pushViewController:logIn animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma  检测该手机号是否被注册过
-(void)checkPhoneNumberRegisteredOrNotFinishedBL:(BOOL)value{
    if(value){
        RegistBL *registGetVerifyCode = [[RegistBL alloc] init];
        registGetVerifyCode.delegate = self;
        [registGetVerifyCode phoneNumberRegistGetShortMessage: textFieldPN.text];
    }
}
-(void)checkPhoneNumberRegisteredOrNotFailedBL:(NSString *)error{
    if([error isEqualToString:THIS_MOBILENUMBER_HAS_BEEN_REGISTED])
    {
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"该手机号已被注册，请直接登录！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertCon addAction:alertAction];
        [self.view.window.rootViewController presentViewController:alertCon animated:NO completion:nil];
    }

}
#pragma  检测该手机号是否被注册过 end
#pragma ---------实现UITextfield代理方法----------------
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textFieldName.text length] > 0 && [textFieldPN.text length] > 0 && [textFieldSM.text length] > 0  && [textFieldPassword.text length] > 0)
    {
        buttonFinishRegist.backgroundColor = orangColorPCH;
        buttonFinishRegist.userInteractionEnabled = YES;
    }
    else
    {
        buttonFinishRegist.backgroundColor = grayColorPCH;
        buttonFinishRegist.userInteractionEnabled = NO;
    }
}
#pragma ---------实现UITextfield代理方法 end----------------


#pragma  ------RegistBL 实现获取验证码委托代理方法 向服务器请求手机验证码-----------
-(void)findAllRegistInfoFinished:(NSInteger)value
{
    if(value)
    {
        [self startTime];
        [self popUPAnimination];
    }
}
//用于向服务器请求验证码失败，弹出提示信息
- (void)findAllRegistInfoFailed:(NSString *)error
{
    if([error isEqualToString:@"验证码获取失败"])
    {
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"验证码请求失败，请检查网络连接或重新发送！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertCon addAction:alertAction];
        [self.view.window.rootViewController presentViewController:alertCon animated:NO completion:nil];
    }
    else if([error isEqualToString:@"该手机号已被注册"])
    {
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"该手机号已被注册，请直接登录！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertCon addAction:alertAction];
        [self.view.window.rootViewController presentViewController:alertCon animated:NO completion:nil];
    }
}
#pragma  ------RegistBL 实现获取验证码委托代理方法 end-----------

#pragma --------RegistBL  注册代理传值-------------------------
-(void)regist_BL_Finished:(NSInteger)value
{
    if(value)
    {
        registDefault = [NSUserDefaults standardUserDefaults];
        [registDefault setObject:@"1" forKey:@"username"];
        [registDefault synchronize];
        self.hidesBottomBarWhenPushed = YES;
        logInViewController *logIn = [[logInViewController alloc] init];
        [self.navigationController pushViewController:logIn animated:NO];
        self.hidesBottomBarWhenPushed = NO;
    }
}

-(void)regist_BL_Failed:(NSString *)error
{
    if([error isEqualToString:@"注册失败"])
    {
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"注册失败！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertCon addAction:alertAction];
        [self.view.window.rootViewController presentViewController:alertCon animated:NO completion:nil];
    }
    else if([error isEqualToString:@"验证码校验失败"])
    {
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"验证校验码失败！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertCon addAction:alertAction];
        [self.view.window.rootViewController presentViewController:alertCon animated:NO completion:nil];
    }
}
#pragma --------RegistBL  注册代理传值 end---------------------

//关闭键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
