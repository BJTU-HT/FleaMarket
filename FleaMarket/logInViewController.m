//
//  logInViewController.m
//  TestDemo1
//
//  Created by Hou on 2/17/16.
//  Copyright © 2016 Hou. All rights reserved.
//

#import "logInViewController.h"
#import "registViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobQuery.h>
#import "myVC.h"
#import "RegistBL.h"
#import "presentLayerPublicMethod.h"

#define ButtonViewHeightPercent 0.1

@interface logInViewController ()

@end

@implementation logInViewController
@synthesize underlineView;
@synthesize backgroundView;
@synthesize accountLoginView;
@synthesize phoneNumberLoginView;
@synthesize accountButton;
@synthesize phoneNumberButton;
@synthesize currentUserName;

//login interface global variable
CGRect screenFrameLogin;
float screenWidth;
float screenHeight;
float buttonViewHeight;
float viewHeight;
BOOL flagDelegate; //验证用户名密码时线程等待标记NSRunLoop
BOOL flagLogInMethod; //登录方式区分 0 用户名登录 1 手机号码登录

UIButton *buttonLogin;
UITextField *field1;
UITextField *field2;
UILabel *labelAccount;
UILabel *labelPassword;
NSDictionary *recDicFromBmob;
NSUserDefaults *userDefaultLogIn;
UIButton *buttonGetShortMessage; //手机号登录获取验证码按钮
-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"FleaMarket欢迎您";
    screenFrameLogin = [UIScreen mainScreen].bounds;
    screenHeight = screenFrameLogin.size.height - 20;
    screenWidth = screenFrameLogin.size.width;
    accountLoginView = [[UIView alloc] init];
    phoneNumberLoginView = [[UIView alloc] init];
    viewHeight = screenHeight * 0.9;
    //flag用于标记代理传值，flag = 0 代表未传值
    flagDelegate = 0;
    flagLogInMethod = 0;
    userDefaultLogIn  = [NSUserDefaults standardUserDefaults];
    [self drawClickButton];
    [self drawLeftButtonView];
    [self leftBtnNav];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//2016-07-15 add
-(void)leftBtnNav{
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemClicked:)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

-(void)leftBarItemClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//代理传值
-(void)passDicValue:(NSDictionary *)dictionary
{
    recDicFromBmob = dictionary;
    flagDelegate = 1;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// 顶层切换栏UI，账号登录， 手机号登录
-(void)drawClickButton
{
    backgroundView = [[UIView alloc] init];
    CGRect backgroundViewFrame = CGRectMake(0, 64, screenWidth, screenHeight * ButtonViewHeightPercent);
    backgroundView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    backgroundView.frame = backgroundViewFrame;
    accountButton = [[UIButton alloc] init];
    phoneNumberButton = [[UIButton alloc] init];
    [accountButton setTitle:@"账号登录" forState:UIControlStateNormal];
    [accountButton setTitleColor:[UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0] forState:UIControlStateNormal];
    [phoneNumberButton setTitle:@"手机号码登录" forState:UIControlStateNormal];
    [phoneNumberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CGRect accountFrame = CGRectMake(screenWidth * 0.1, 0, screenWidth * 0.4, screenHeight * 0.09);
    CGRect phoneNumberFrame = CGRectMake(screenWidth * 0.5, 0, screenWidth * 0.4, screenHeight * 0.09);
    [accountButton addTarget:self action:@selector(accountButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [phoneNumberButton addTarget:self action:@selector(phoneNumberButtonClicked:) forControlEvents:UIControlEventTouchDown];
    accountButton.frame = accountFrame;
    phoneNumberButton.frame = phoneNumberFrame;
    
    underlineView = [[UIView alloc] init];
    CGRect underLineFrame = CGRectMake(screenWidth *0.15, screenHeight * 0.095, screenWidth * 0.3, screenHeight * 0.005);
    underlineView.frame = underLineFrame;
    underlineView.backgroundColor = [UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0];
    
    accountLoginView = [[UIView alloc] init];
    CGRect accountViewFrame = CGRectMake(0, 64 + screenHeight * 0.1, screenWidth, screenHeight * 0.9);
    accountLoginView.frame = accountViewFrame;
    
    [self.view addSubview:accountLoginView];
    [backgroundView addSubview:underlineView];
    [backgroundView addSubview:accountButton];
    [backgroundView addSubview:phoneNumberButton];
    [self.view addSubview:backgroundView];
}

//顶层切换栏UI，点击账号登录，按钮边缘滚动条切换
-(void)accountButtonClicked:(UIButton *)sender
{
    flagLogInMethod = 0;
    CGRect underLineFrameLeft = CGRectMake(screenWidth *0.15, screenHeight * 0.095, screenWidth * 0.3, screenHeight * 0.005);
    underlineView.frame = underLineFrameLeft;
    [phoneNumberLoginView removeFromSuperview];
    [underlineView removeFromSuperview];
    CGRect accountViewFrame = CGRectMake(0, 64 + screenHeight * 0.1, screenWidth, screenHeight * 0.9);
    accountLoginView.frame = accountViewFrame;
    [accountButton setTitleColor:[UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0] forState:UIControlStateNormal];
    [phoneNumberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backgroundView addSubview:underlineView];
    [self.view addSubview:accountLoginView];
}
//顶层切换栏UI，点击手机号登录，按钮边缘滚动条切换
-(void)phoneNumberButtonClicked:(UIButton *)sender
{
    flagLogInMethod = 1;
    CGRect underLineFrameRight = CGRectMake(screenWidth *0.55, screenHeight * 0.095, screenWidth * 0.3, screenHeight * 0.005);
    underlineView.frame = underLineFrameRight;
    [accountLoginView removeFromSuperview];
    [underlineView removeFromSuperview];
    CGRect phoneNumberViewFrame = CGRectMake(0, 64 + screenHeight * 0.1, screenWidth, screenHeight * 0.9);
    phoneNumberLoginView.frame = phoneNumberViewFrame;
    [phoneNumberButton setTitleColor:[UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0] forState:UIControlStateNormal];
    [accountButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backgroundView addSubview:underlineView];
    [self drawRightButtonView];
    [self.view addSubview:phoneNumberLoginView];
}

//按钮登录界面UI
-(void)drawLeftButtonView
{
    UIView *viewTextField1 = [[UIView alloc] init];
    CGRect view1Frame = CGRectMake(screenWidth * 0.02, viewHeight * 0.11, screenWidth * 0.96, viewHeight * 0.005);
    viewTextField1.frame = view1Frame;
    viewTextField1.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    //账号标签
    labelAccount = [[UILabel alloc] init];
    labelAccount.text = @"账号";
    labelAccount.font =FontSize16;
    labelAccount.textColor = [UIColor blackColor];
    labelAccount.shadowColor = [UIColor whiteColor];
    CGRect labelAccountFrame = CGRectMake(screenWidth * 0.05, 0, screenWidth * 0.15, viewHeight * 0.12);
    labelAccount.frame = labelAccountFrame;
    [accountLoginView addSubview:labelAccount];
    
    field1 = [[UITextField alloc] init];
    CGRect field1Frame = CGRectMake(screenWidth * 0.17, 0, screenWidth * 0.96, viewHeight * 0.12);
    field1.frame = field1Frame;
    field1.text = @"手机号/邮箱";
    field1.font = FontSize14;
    field1.textColor = [UIColor grayColor];
    field1.delegate = self;
    field1.clearsOnBeginEditing = YES;
    [field1 addTarget:self action:@selector(logInBtnColorChanged:) forControlEvents:UIControlEventEditingChanged];
    [accountLoginView addSubview:field1];
    [accountLoginView addSubview:viewTextField1];
    
    
    UIView *viewTextField2 = [[UIView alloc] init];
    CGRect view2Frame = CGRectMake(screenWidth * 0.02, viewHeight * 0.23, screenWidth * 0.96, viewHeight * 0.005);
    viewTextField2.frame = view2Frame;
    viewTextField2.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    //账号标签
    labelPassword = [[UILabel alloc] init];
    labelPassword.text = @"密码";
    labelPassword.font = FontSize16;
    labelPassword.textColor = [UIColor blackColor];
    labelPassword.shadowColor = [UIColor whiteColor];
    CGRect labelPasswordFrame = CGRectMake(screenWidth * 0.05, viewHeight * 0.12, screenWidth * 0.15, viewHeight * 0.12);
    labelPassword.frame = labelPasswordFrame;
    [accountLoginView addSubview:labelPassword];
    
    field2 = [[UITextField alloc] init];
    CGRect field2Frame = CGRectMake(screenWidth * 0.17, viewHeight * 0.12, screenWidth * 0.96, viewHeight * 0.12);
    field2.frame = field2Frame;
    field2.textColor = [UIColor grayColor];
    field2.delegate = self;
    [field2 addTarget:self action:@selector(logInBtnColorChanged:) forControlEvents:UIControlEventEditingChanged];
    [accountLoginView addSubview:field2];
    [accountLoginView addSubview:viewTextField2];
    
    UIButton *buttonForget = [[UIButton alloc] init];
    [buttonForget setTitle:@"忘记密码" forState:UIControlStateNormal];
    CGRect buttonForgetFrame = CGRectMake(screenWidth * 0.7, viewHeight * 0.24, screenWidth * 0.28, viewHeight * 0.12);
    buttonForget.frame = buttonForgetFrame;
    [buttonForget setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [accountLoginView addSubview:buttonForget];
    
    buttonLogin = [[UIButton alloc] init];
    [buttonLogin setTitle:@"登录" forState:UIControlStateNormal];
    CGRect buttonLoginFrame = CGRectMake(screenWidth * 0.02, viewHeight * 0.36, screenWidth * 0.96, viewHeight * 0.12);
    buttonLogin.frame = buttonLoginFrame;
    buttonLogin.backgroundColor = grayColorPCH;
    buttonLogin.titleLabel.font = FontSize16;
    [buttonLogin setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [buttonLogin addTarget:self action:@selector(buttonLoginClicked:) forControlEvents:UIControlEventTouchDown];
    [accountLoginView addSubview:buttonLogin];
    
//    UIView *middleLine1 = [[UIView alloc] init];
//    CGRect middleLine1Frame = CGRectMake(screenWidth * 0.02, viewHeight * 0.54, screenWidth * 0.32, viewHeight * 0.003);
//    middleLine1.frame = middleLine1Frame;
//    middleLine1.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
//    [accountLoginView addSubview:middleLine1];
//    
//    UIView *middleLine2 = [[UIView alloc] init];
//    CGRect middleLine2Frame = CGRectMake(screenWidth * 0.66, viewHeight * 0.54, screenWidth * 0.32, viewHeight * 0.003);
//    middleLine2.frame = middleLine2Frame;
//    middleLine2.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
//    [accountLoginView addSubview:middleLine2];
//    
//    UILabel *labelMiddle = [[UILabel alloc] init];
//    labelMiddle.text = @"第三方账号登录";
//    labelMiddle.font = FontSize12;
//    labelMiddle.textColor = [UIColor grayColor];
//    CGRect labelMiddleFrame = CGRectMake(screenWidth * 0.34, viewHeight * 0.48, screenWidth * 0.32, viewHeight * 0.12);
//    labelMiddle.frame = labelMiddleFrame;
//    [accountLoginView addSubview:labelMiddle];
//    
//    UIButton *buttonWechat = [[UIButton alloc] init];
//    CGRect buttonWeChatFrame = CGRectMake(screenWidth * 0.08, viewHeight * 0.6, screenWidth * 0.15, viewHeight * 0.12);
//    buttonWechat.frame = buttonWeChatFrame;
//    [buttonWechat setImage:[self circleImage:[UIImage imageNamed:@"wechat.PNG"] withParam:1] forState:UIControlStateNormal];
//    [accountLoginView addSubview:buttonWechat];
//    
//    UIButton *buttonWeibo = [[UIButton alloc] init];
//    CGRect buttonWeiboFrame = CGRectMake(screenWidth * (0.08 * 2 + 0.15), viewHeight * 0.6, screenWidth * 0.15, viewHeight * 0.12);
//    buttonWeibo.frame = buttonWeiboFrame;
//    [buttonWeibo setImage:[self circleImage:[UIImage imageNamed:@"weibo.JPG"] withParam:1] forState:UIControlStateNormal];
//    [accountLoginView addSubview:buttonWeibo];
//    
//    UIButton *buttonQQ = [[UIButton alloc] init];
//    CGRect buttonQQFrame = CGRectMake(screenWidth * (0.08 * 3 + 0.15 * 2), viewHeight * 0.6, screenWidth * 0.15, viewHeight * 0.12);
//    buttonQQ.frame = buttonQQFrame;
//    [buttonQQ setImage:[self circleImage:[UIImage imageNamed:@"QQ.JPG"] withParam:1] forState:UIControlStateNormal];
//    [accountLoginView addSubview:buttonQQ];
//    
//    UIButton *buttonRenren = [[UIButton alloc] init];
//    CGRect buttonRenrenFrame = CGRectMake(screenWidth * (0.08 * 4 + 0.15 * 3), viewHeight * 0.6, screenWidth * 0.15, viewHeight * 0.12);
//    buttonRenren.frame = buttonRenrenFrame;
//    [buttonRenren setImage:[self circleImage:[UIImage imageNamed:@"renren.JPG"] withParam:1] forState:UIControlStateNormal];
//    [accountLoginView addSubview:buttonRenren];
    
    UIButton *buttonRegist = [[UIButton alloc] init];
    CGRect buttonRegistFrame = CGRectMake(screenWidth * 0.02, viewHeight * 0.76, screenWidth * 0.96, viewHeight * 0.12);
    buttonRegist.frame = buttonRegistFrame;
    [buttonRegist setTitle:@"手机快速注册" forState:UIControlStateNormal];
    [buttonRegist setTitleColor:[UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0] forState:UIControlStateNormal];
    buttonRegist.layer.borderWidth = 1;
    buttonRegist.layer.borderColor = [UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0].CGColor;
    [buttonRegist addTarget:self action:@selector(buttonRegistClicked:) forControlEvents:UIControlEventTouchDown];
    [accountLoginView addSubview:buttonRegist];
}

-(void)buttonLoginClicked:(UIButton *)sender
{
    NSString *info;
    if([field1.text length] > 0 && [field2.text length] > 0)
    {
        //向服务器请求数据，验证用户名和密码
        RegistBL *registLogIn = [[RegistBL alloc] init];
        registLogIn.delegate = self;
        if(flagLogInMethod == 0){
            [registLogIn searchUserInfoBL:field1.text secret:field2.text];
        }
        else if(flagLogInMethod == 1){
            [registLogIn verifyPhoneNumberAndVerifyCodeBL:field1.text code:field2.text];
        }
    }
    else
    {
        if(flagLogInMethod == 0)
            info = @"请您填写用户名和密码";
        else if(flagLogInMethod == 1)
            info = @"请您完整填写手机号和验证码";
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示信息" message:info preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertCon addAction:alertAction];
        [self.view.window.rootViewController presentViewController:alertCon animated:YES completion:nil];
    }
}

-(void)afterLogInBackToMyVC
{
    myVC *my = [[myVC alloc] init];
    [self.navigationController pushViewController:my animated:NO];
}

-(void)myNoteGetUserName
{

}
-(void)drawRightButtonView
{
    UIView *viewTextField1 = [[UIView alloc] init];
    CGRect view1Frame = CGRectMake(screenWidth * 0.02, viewHeight * 0.11, screenWidth * 0.96, viewHeight * 0.005);
    viewTextField1.frame = view1Frame;
    viewTextField1.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    //账号标签
    UILabel *labelAccount = [[UILabel alloc] init];
    labelAccount.text = @"手机号";
    labelAccount.font = FontSize16;
    labelAccount.textColor = [UIColor blackColor];
    labelAccount.shadowColor = [UIColor whiteColor];
    labelAccount.font = FontSize16;
    CGRect labelAccountFrame = CGRectMake(screenWidth * 0.05, 0, screenWidth * 0.15, viewHeight * 0.12);
    labelAccount.frame = labelAccountFrame;
    [phoneNumberLoginView addSubview:labelAccount];
    
    field1 = [[UITextField alloc] init];
    CGRect field1Frame = CGRectMake(screenWidth * 0.22, 0, screenWidth * 0.96, viewHeight * 0.12);
    field1.frame = field1Frame;
    field1.delegate = self;
    [field1 addTarget:self action:@selector(logInBtnColorChanged:) forControlEvents:UIControlEventEditingChanged];
    [phoneNumberLoginView addSubview:field1];
    [phoneNumberLoginView addSubview:viewTextField1];
    
    UIView *viewTextField2 = [[UIView alloc] init];
    CGRect view2Frame = CGRectMake(screenWidth * 0.02, viewHeight * 0.23, screenWidth * 0.96, viewHeight * 0.005);
    viewTextField2.frame = view2Frame;
    viewTextField2.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    //账号标签
    UILabel *labelPassword = [[UILabel alloc] init];
    labelPassword.text = @"短信验证码";
    labelPassword.font = FontSize16;
    labelPassword.textColor = [UIColor blackColor];
    labelPassword.shadowColor = [UIColor whiteColor];
    CGRect labelPasswordFrame = CGRectMake(screenWidth * 0.05, viewHeight * 0.12, screenWidth * 0.3, viewHeight * 0.12);
    labelPassword.frame = labelPasswordFrame;
    [phoneNumberLoginView addSubview:labelPassword];
    
    field2 = [[UITextField alloc] init];
    CGRect field2Frame = CGRectMake(screenWidth * 0.37, viewHeight * 0.12, screenWidth * 0.3, viewHeight * 0.12);
    field2.frame = field2Frame;
    field2.textColor = [UIColor grayColor];
    field2.delegate = self;
    [field2 addTarget:self action:@selector(logInBtnColorChanged:) forControlEvents:UIControlEventEditingChanged];
    
    buttonGetShortMessage = [[UIButton alloc] init];
    [buttonGetShortMessage setBackgroundColor:[UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0]];
    [buttonGetShortMessage setTitle:@"获取验证码" forState: UIControlStateNormal];
    CGRect buttonGetShortMessageFrame = CGRectMake(screenWidth * 0.67, viewHeight * 0.13, screenWidth * 0.3, viewHeight * 0.09);
    buttonGetShortMessage.frame = buttonGetShortMessageFrame;
    buttonGetShortMessage.titleLabel.font = FontSize16;
    [buttonGetShortMessage.layer setCornerRadius:8];
    [buttonGetShortMessage addTarget:self action: @selector(getVerifyCodeLogIn:) forControlEvents:UIControlEventTouchDown];

    [phoneNumberLoginView addSubview:buttonGetShortMessage];
    [phoneNumberLoginView addSubview:field2];
    [phoneNumberLoginView addSubview:viewTextField2];
    
    buttonLogin = [[UIButton alloc] init];
    [buttonLogin setTitle:@"登录" forState:UIControlStateNormal];
    CGRect buttonLoginFrame = CGRectMake(screenWidth * 0.02, viewHeight * 0.26, screenWidth * 0.96, viewHeight * 0.12);
    buttonLogin.frame = buttonLoginFrame;
    [buttonLogin addTarget:self action:@selector(buttonPhoneNumberLoginClicked:) forControlEvents:UIControlEventTouchDown];
    buttonLogin.backgroundColor = grayColorPCH;
    buttonLogin.titleLabel.font = FontSize16;
    [buttonLogin setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [phoneNumberLoginView addSubview:buttonLogin];
    
    UIButton *buttonRegist = [[UIButton alloc] init];
    CGRect buttonRegistFrame = CGRectMake(screenWidth * 0.02, viewHeight * 0.76, screenWidth * 0.96, viewHeight * 0.12);
    buttonRegist.frame = buttonRegistFrame;
    [buttonRegist setTitle:@"手机快速注册" forState:UIControlStateNormal];
    [buttonRegist setTitleColor:[UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0] forState:UIControlStateNormal];
    buttonRegist.layer.borderWidth = 1;
    buttonRegist.layer.borderColor = [UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0].CGColor;
    [buttonRegist addTarget:self action:@selector(buttonRegistClicked:) forControlEvents:UIControlEventTouchDown];
    [phoneNumberLoginView addSubview:buttonRegist];
}

//手机号码登录获取验证码
-(void)getVerifyCodeLogIn:(UIButton *)sender
{
    if([field1.text length] != 11)
    {
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"请您输入11位中国大陆手机号码！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertCon addAction:alertAction];
        [self presentViewController:alertCon animated:NO completion:nil];
    }
    RegistBL *registGetVerifyCode = [[RegistBL alloc] init];
    registGetVerifyCode.delegate = self;
    [registGetVerifyCode getPhoneVerifyCodeBL: field1.text];
}

-(void)buttonRegistClicked:(UIButton *)sender{
    self.hidesBottomBarWhenPushed = YES;
    registViewController *regist = [[registViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem: backItem];
    [self.navigationController pushViewController: regist animated:NO];
    //self.hidesBottomBarWhenPushed = NO;
}

-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context,0); //边框线
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//UITextField代理方法，用于改变登录按钮颜色，当输入所有内容后按钮变为橙色
-(void)logInBtnColorChanged:(UITextField *)sender
{
    if([field1.text length] > 0 && [field2.text length] > 0)
    {
        buttonLogin.backgroundColor = orangColorPCH;
    }
    else
    {
        buttonLogin.backgroundColor = lightGrayColorPCH;
    }
}

#pragma 手机号码登录点击按钮事件------------------
-(void)buttonPhoneNumberLoginClicked:(UIButton *)sender{
    
}
#pragma 手机号码登录点击按钮事件end----------------
#pragma ----------RegistBL 手机号登录校验手机号验证码代理方法实现----------------
-(void)logInVerifyPhoneNumberAndVerifyCodeBLFinished:(NSInteger)value
{
    if(value)
    {
        self.hidesBottomBarWhenPushed = YES;
        myVC *myViewController = [[myVC alloc] init];
        [userDefaultLogIn setObject:@"1" forKey:@"username"];
        [userDefaultLogIn synchronize];
        [self.navigationController pushViewController:myViewController animated:NO];
        self.hidesBottomBarWhenPushed = NO;
        //添加通知，用于连接服务器 2016-09-21-16-04
        BmobUser *curUser = [BmobUser getCurrentUser];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:curUser.objectId];
    }
}

-(void)logInVerifyPhoneNumberAndVerifyCodeBLFailed:(NSString *)error
{
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"验证码已失效，请重新获取！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alerAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertCon addAction:alerAction];
    [self presentViewController:alertCon animated:NO completion:nil];
}
#pragma ----------RegistBL 手机号登录校验手机号验证码代理方法实现 end------------

#pragma ----------RegistBL 用户名登录代理方法实现------------------------------
-(void)logInPassDicInfoFinishedBL:(NSDictionary *)userInfo
{
    self.hidesBottomBarWhenPushed = YES;
    myVC *myViewController = [[myVC alloc] init];
    self.delegateForVC = myViewController;
    [self.delegateForVC passValueForVC:userInfo];
    [userDefaultLogIn setObject:field1.text forKey:@"userName"];
    [userDefaultLogIn synchronize];
    //201607181108 modify by hou
    [self.navigationController popViewControllerAnimated:NO];
    //添加通知，用于连接服务器 2016-09-21-16-04
    BmobUser *curUser = [BmobUser getCurrentUser];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:curUser.objectId];
}
-(void)logInPassDicInfoFailedBL:(NSString *)error
{
    if(error)
    {
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"用户名或密码错误！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alerAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertCon addAction:alerAction];
        [self.view.window.rootViewController presentViewController:alertCon animated:NO completion:nil];
    }
}
#pragma ----------RegistBL 用户名登录代理方法实现 end------------------------------

#pragma  ------RegistBL 实现获取验证码委托代理方法-----------
-(void)findAllRegistInfoFinished:(NSInteger)value
{
    if(value)
    {
        presentLayerPublicMethod *publicMethod = [[presentLayerPublicMethod alloc] init];
        [publicMethod startTime:buttonGetShortMessage ];
        [publicMethod notifyView:self.navigationController notifyContent:@"验证码已发送"];
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
}
#pragma  ------RegistBL 实现获取验证码委托代理方法 end-----------

#pragma -------RegistBL 实现手机号获取验证码代理方法--------------
-(void)logInByPhoneNumForGetVerifyCodeBLFinished:(NSInteger)value
{
    if(value)
    {
        presentLayerPublicMethod *publicMethod = [[presentLayerPublicMethod alloc] init];
        [publicMethod startTime:buttonGetShortMessage ];
        [publicMethod notifyView:self.navigationController notifyContent:@"验证码已发送"];
//        [self popUPAnimination];
    }
}

-(void)logInByPhoneNumForGetVerifyCodeBLFailed:(NSString *)error
{
    if([error isEqualToString:@"验证码获取失败"])
    {
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"验证码请求失败，请检查网络连接或重新发送！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertCon addAction:alertAction];
        [self.view.window.rootViewController presentViewController:alertCon animated:NO completion:nil];
    }
}
#pragma -------RegistBL 实现手机号获取验证码代理方法 end-----------

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
