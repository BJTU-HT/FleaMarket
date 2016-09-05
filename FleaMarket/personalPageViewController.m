//
//  personalPageViewController.m
//  TestDemo1
//
//  Created by Hou on 3/4/16.
//  Copyright © 2016 Hou. All rights reserved.
//

#import "personalPageViewController.h"
#import "publicMethod.h"
#import "ModifyPersonalPageVC.h"
#import "myVC.h"
#import "LogInBL.h"
#import "presentLayerPublicMethod.h"

#define NAV_BUTTON_X_OFFSET_PER 0.05
#define NAV_BUTTON_WIDTH_PER 0.14
#define VIEW_X_OFFSET  0
#define VIEW_Y_OFFSET 0
#define VIEW_HEIGHT_PER 0.5
#define VIEW_WIDTH_PER 1.0
#define HEAD_IMAGE_WIDTH_PER 0.12
#define HEAD_NAME_GAP_PER 0.02
#define NAME_HEIGHT_PER 0.04
#define NAME_LEVEL_X_GAP 0.02
#define NAME_CONCERN_Y_GAP 0.01
#define CONCERN_HEIGHT_PER 0.03
#define FANS_HEIGHT_PER CONCERN_HEIGHT_PER
#define VIEWLINE_WIDTH_PER 0.005
#define VIEWLINE_HEIGHT_PER FANS_HEIGHT_PER
#define VIEW_FANS_GAP_PER 0.02
#define FANS_NOTE_GAP_PER 0.02
#define REMARK_WIDTH_PER 0.5
#define FANS_REMARK_GAP 0.02
#define REMARK_HEIGHT_PER 0.03
//修改个人资料
#define BUTTON_HEIGHT 0.10
#define BUTTON_WIDTH_PER 0.4
#define BUTTON_REMARK_GAP_PER 0.05


//四个按钮， 嗡嗡，
#define PER_LABEL_GAP_PER 0.25
#define LABEL_HEIGHT_PER 0.08
#define LABEL_HEIGHT_Y_OFFSET_PER 0.5
#define VIEW_LABEL_OFFSET_PER 0

//viewLine
#define VIEWLINEBTN_Y_OFFSET_PER 0.58
#define VIEWLINEBTN_HEIGHT_PER 0.003
#define VIEWLINEBTN_X_OFFSET VIEW_LABEL_OFFSET_PER
#define VIEWLINEBTN_WIDTH_PER PER_LABEL_GAP_PER

//下边线宏定义
#define UNDERLINE_X_OFFSET 0
#define UNDERLINE_Y_OFFSET 0.582
#define UNDERLINE_HEIGHT_PER 0.001

@interface personalPageViewController ()

@end

@implementation personalPageViewController
CGRect screenFramePersonal; //screen size
CGRect rectStatusPersonal; //status bar size
UIView *viewLineBtn;
UIButton *buttonStatus;
UIButton *buttonTravelNote;
UIButton *buttonAnswer;
UIButton *buttonRemark;

float statusBarHeight;
float screenWidthPersonal;
float screenHeightPersonal;
float naviBarHeightPersonal;
NSUInteger priorButtonTag;
UIImageView *backgroundImageView;
UIImageView *imageViewHead;
BOOL recModifySuccessFlag;

// 界面部分，用户信息
UILabel *labelNameSection0;
UILabel *labelLevel;
UILabel *labelConcern;
UILabel *labelRemark;
UILabel *labelFansSection0;
//头像和背景图片
UIImage *recHeadImageTemp;
UIImage *recBackgroundImageTemp;

-(void)viewDidLoad {
    [super viewDidLoad];
    screenFramePersonal = [UIScreen mainScreen].bounds;
    rectStatusPersonal = [[UIApplication sharedApplication] statusBarFrame];
    statusBarHeight = rectStatusPersonal.size.height;
    screenWidthPersonal = screenFramePersonal.size.width;
    screenHeightPersonal = screenFramePersonal.size.height;
    naviBarHeightPersonal = self.navigationController.navigationBar.frame.size.height;
    //self.navigationController.navigationBarHidden = YES;
    [self drawView];
    //添加修改个人信息成功提示动画
    if(recModifySuccessFlag == 1){
        presentLayerPublicMethod *pubMethod = [[presentLayerPublicMethod alloc] init];
        CGRect frame = CGRectMake(screenWidthPCH/2 - 100, screenHeightPCH/2 - 40, 200, 80);
        [pubMethod popView:frame superView:self.view content:@"修改个人信息成功"];
    }
    recModifySuccessFlag = 0;
    [self cacheAndDownloadPersonalInfoPersonalPage];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

-(void)cacheAndDownloadPersonalInfoPersonalPage
{
    LogInBL *logIn = [[LogInBL alloc]init];
    logIn.delegate = self;
    [logIn cacheAndDownloadPersonalInfoBL:@"userInfo.plist"];
}

-(void)drawView
{
    publicMethod *public = [[publicMethod alloc] init];
    if(backgroundImageView == nil)
        backgroundImageView = [[UIImageView alloc] init];
    UIImage *image2;
    if(backgroundImageView.image != nil)
        image2 = backgroundImageView.image;
    else
        image2 = [UIImage imageNamed:@"pic3.jpg"];
    backgroundImageView.image = image2;
    backgroundImageView.frame = CGRectMake(VIEW_X_OFFSET, VIEW_Y_OFFSET, (screenWidthPersonal * VIEW_WIDTH_PER), (screenHeightPersonal * VIEW_HEIGHT_PER));
    [self.view addSubview:backgroundImageView];
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(screenWidthPersonal * NAV_BUTTON_X_OFFSET_PER, statusBarHeight, screenWidthPersonal * NAV_BUTTON_WIDTH_PER, naviBarHeightPersonal);
    [button setImage:[UIImage imageNamed:@"ic_nav_back@2x.png"] forState:UIControlStateNormal];
    [self.view insertSubview:button atIndex:1];
    [button addTarget:self action:@selector(buttonReturnClicked:) forControlEvents:UIControlEventTouchDown];
    
    //头像图片
    if(imageViewHead == nil)
        imageViewHead = [[UIImageView alloc] init];
    float head_x_offset = (screenWidthPersonal - (screenHeightPersonal * HEAD_IMAGE_WIDTH_PER))/2;
    imageViewHead.frame = CGRectMake(head_x_offset, statusBarHeight + naviBarHeightPersonal, screenHeightPersonal * HEAD_IMAGE_WIDTH_PER, screenHeightPersonal * HEAD_IMAGE_WIDTH_PER);
    UIImage *image1;
    if(imageViewHead.image != nil)
        image1 = imageViewHead.image;
    else
        image1 = [UIImage imageNamed:@"icon_default_face@2x.png"];
    UIImage *imageHead = [public circleImage:image1 withParam:1];
    imageViewHead.image = imageHead;
    [self.view insertSubview:imageViewHead atIndex:1];
    
    //昵称Label
    labelNameSection0 = [[UILabel alloc] init];
    labelNameSection0.text = @"用户名";
    labelNameSection0.font = [UIFont systemFontOfSize:24 * 3/4]; //24 为24px 24 * 3/4 = 18pt
    float nameXOffset = (screenWidthPersonal - 18 * 4)/2;
    float nameYOffset = statusBarHeight + naviBarHeightPersonal + screenHeightPersonal * HEAD_IMAGE_WIDTH_PER + screenHeightPersonal * HEAD_NAME_GAP_PER;
    float nameWidth = 18 * 4;
    //18 * 4 代表可以容纳4个字 18pt
    labelNameSection0.frame = CGRectMake(nameXOffset, nameYOffset, nameWidth, screenHeightPersonal * NAME_HEIGHT_PER);
    labelNameSection0.textColor = [UIColor whiteColor];
    labelNameSection0.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:labelNameSection0 atIndex:1];
    
    //level
    labelLevel = [[UILabel alloc] init];
    labelLevel.text = @"Lv0";
    labelLevel.font = [UIFont systemFontOfSize:24 * 3/4];
    float levelXOffset = nameXOffset + nameWidth + screenWidthPersonal * NAME_LEVEL_X_GAP;
    float levelYOffset = nameYOffset;
    float levelWidth = 15 * 2;
    labelLevel.frame = CGRectMake(levelXOffset, levelYOffset, levelWidth, screenHeightPersonal * NAME_HEIGHT_PER);
    labelLevel.textColor = [UIColor whiteColor];
    labelLevel.font = [UIFont systemFontOfSize:20 * 3/4];
    labelLevel.textAlignment =  NSTextAlignmentCenter;
    [self.view insertSubview:labelLevel atIndex:1];
    
    //关注
    labelConcern = [[UILabel alloc]init];
    labelConcern.text = @"关注 0";
    labelConcern.font = [UIFont systemFontOfSize:20 * 3/4];// 20 px
    float concernWidth = 20 * 3/4 * 5;
    float concernXOffset = screenWidthPersonal/2 - concernWidth;
    float concernYOffset = levelYOffset + screenHeightPersonal * NAME_CONCERN_Y_GAP + screenHeightPersonal * NAME_HEIGHT_PER;
    labelConcern.frame = CGRectMake(concernXOffset, concernYOffset, concernWidth, screenHeightPersonal * CONCERN_HEIGHT_PER);
    labelConcern.textColor = [UIColor whiteColor];
    labelConcern.textAlignment =  NSTextAlignmentCenter;
    [self.view insertSubview:labelConcern atIndex:1];
    
    //uiview
    UIView *viewLine = [[UIView alloc] init];
    viewLine.backgroundColor = [UIColor whiteColor];
    viewLine.frame = CGRectMake(screenWidthPersonal/2, concernYOffset, screenWidthPersonal * VIEWLINE_WIDTH_PER, screenHeightPersonal * VIEWLINE_HEIGHT_PER);
    [self.view insertSubview:viewLine atIndex:1];
    
    //fans
    labelFansSection0 = [[UILabel alloc] init];
    labelFansSection0.text = @"粉丝:0";
    labelFansSection0.font = [UIFont systemFontOfSize:20 * 3/4];
    float fansWidth = 20 * 3/4 * 5;
    float fansXOffset = screenWidthPersonal *1/2 + VIEW_FANS_GAP_PER * screenWidthPersonal;
    float fansYOffset = levelYOffset + screenHeightPersonal * NAME_CONCERN_Y_GAP + screenHeightPersonal * NAME_HEIGHT_PER;
    labelFansSection0.frame = CGRectMake(fansXOffset, fansYOffset, fansWidth, screenHeightPersonal * FANS_HEIGHT_PER);
    labelFansSection0.textColor = [UIColor whiteColor];
    labelFansSection0.textAlignment =  NSTextAlignmentCenter;
    [self.view insertSubview:labelFansSection0 atIndex:1];
    
    //备注
    labelRemark = [[UILabel alloc] init];
    labelRemark.text = @"个性签名";
    labelRemark.font = [UIFont systemFontOfSize:20 * 3/4];
    float remarkXOffset = screenWidthPersonal/2 - (screenWidthPersonal * REMARK_WIDTH_PER)/2;
    float remarkYOffset = fansYOffset + screenHeightPersonal * FANS_HEIGHT_PER + screenHeightPersonal * FANS_REMARK_GAP;
    float remarkWidth = screenWidthPersonal * REMARK_WIDTH_PER;
    float remarkHeight = screenHeightPersonal * REMARK_HEIGHT_PER;
    labelRemark.frame = CGRectMake(remarkXOffset, remarkYOffset, remarkWidth, remarkHeight);
    labelRemark.textAlignment = NSTextAlignmentCenter;
    labelRemark.textColor = [UIColor whiteColor];
    [self.view insertSubview:labelRemark atIndex:1];
    
    //修改个人资料
    UIButton *buttonModify = [[UIButton alloc] init];
    [buttonModify setTitle:@"修改个人资料" forState:UIControlStateNormal];
    [buttonModify setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonModify.titleLabel.font = FontSize16;
    buttonModify.layer.borderWidth = 2.0;
    buttonModify.layer.cornerRadius = 10.0;
    buttonModify.layer.borderColor = [UIColor whiteColor].CGColor;
    float buttonWidth = screenWidthPersonal * BUTTON_WIDTH_PER;
    float buttonHegiht = screenWidthPersonal * BUTTON_HEIGHT;
    float buttonXOffset = screenWidthPersonal/2 - (screenWidthPersonal * BUTTON_WIDTH_PER)/2;
    float buttonYOffset = remarkYOffset + remarkHeight + screenHeightPersonal * BUTTON_REMARK_GAP_PER;
    buttonModify.frame = CGRectMake(buttonXOffset, buttonYOffset, buttonWidth, buttonHegiht);
    [buttonModify addTarget:self action:@selector(buttonModifyClicked:) forControlEvents:UIControlEventTouchDown];
    [self.view insertSubview:buttonModify atIndex:1];
    
    viewLineBtn = [[UIView alloc] init];
    viewLineBtn.frame = CGRectMake(VIEWLINEBTN_X_OFFSET, screenHeightPersonal * VIEWLINEBTN_Y_OFFSET_PER, screenWidthPersonal * VIEWLINEBTN_WIDTH_PER, screenHeightPersonal * VIEWLINEBTN_HEIGHT_PER);
    viewLineBtn.backgroundColor = [UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0];
    //添加底部四个按钮，嗡嗡 游记 回答 点评，
    buttonStatus = [[UIButton alloc] init];
    buttonStatus.frame = CGRectMake(0 * screenWidthPersonal * PER_LABEL_GAP_PER, screenHeightPersonal * LABEL_HEIGHT_Y_OFFSET_PER, screenWidthPersonal * PER_LABEL_GAP_PER, screenHeightPersonal * LABEL_HEIGHT_PER);
    [buttonStatus setTitle:@"状态" forState:UIControlStateNormal];
    [buttonStatus setTitleColor:[UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0] forState:UIControlStateNormal];
    [buttonStatus addTarget:self action:@selector(buttonStatusClicked:) forControlEvents:UIControlEventTouchDown];
    
    buttonTravelNote = [[UIButton alloc] init];
    buttonTravelNote.frame = CGRectMake(1 * screenWidthPersonal * PER_LABEL_GAP_PER, screenHeightPersonal * LABEL_HEIGHT_Y_OFFSET_PER, screenWidthPersonal * PER_LABEL_GAP_PER, screenHeightPersonal * LABEL_HEIGHT_PER);
    [buttonTravelNote setTitle:@"游记" forState:UIControlStateNormal];
    [buttonTravelNote setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonTravelNote addTarget:self action:@selector(buttonTravelNoteClicked:) forControlEvents:UIControlEventTouchDown];
    
    buttonAnswer = [[UIButton alloc] init];
    buttonAnswer.frame = CGRectMake(2 * screenWidthPersonal * PER_LABEL_GAP_PER, screenHeightPersonal * LABEL_HEIGHT_Y_OFFSET_PER, screenWidthPersonal * PER_LABEL_GAP_PER, screenHeightPersonal * LABEL_HEIGHT_PER);
    [buttonAnswer setTitle:@"回答" forState:UIControlStateNormal];
    [buttonAnswer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonAnswer addTarget:self action:@selector(buttonAnswerClicked:) forControlEvents:UIControlEventTouchDown];
    
    buttonRemark = [[UIButton alloc] init];
    buttonRemark.frame = CGRectMake(3 * screenWidthPersonal * PER_LABEL_GAP_PER, screenHeightPersonal * LABEL_HEIGHT_Y_OFFSET_PER, screenWidthPersonal * PER_LABEL_GAP_PER, screenHeightPersonal * LABEL_HEIGHT_PER);
    [buttonRemark setTitle:@"点评" forState:UIControlStateNormal];
    [buttonRemark setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonRemark addTarget:self action:@selector(buttonRemarkClicked:) forControlEvents:UIControlEventTouchDown];
    
    float view_y_offset = screenHeightPersonal * LABEL_HEIGHT_Y_OFFSET_PER + screenHeightPersonal * LABEL_HEIGHT_PER;
    UIView *viewBasic = [[UIView alloc] init];
    viewBasic.frame = CGRectMake(0, view_y_offset, screenWidthPersonal, screenHeightPersonal - view_y_offset);
    UIImageView *imageViewNothing = [[UIImageView alloc] initWithFrame: CGRectMake((screenWidthPCH - screenHeightPCH * 0.25)/2.0 , 0, screenHeightPCH * 0.25, screenHeightPCH * 0.25)];
    imageViewNothing.image = [UIImage imageNamed:@"ic_empty_nocontent@2x.png"];
    [viewBasic addSubview:imageViewNothing];
    
    //发布按钮 与底部距离30， 尺寸65*65
    UIButton *btnCamera = [[UIButton alloc] initWithFrame:CGRectMake((screenWidthPCH -65)/2.0, screenHeightPCH - 65-30, 65, 65)];
    [btnCamera setBackgroundImage:[UIImage imageNamed:@"ic_profile_camera@2x.png"] forState:UIControlStateNormal];
    [self.view insertSubview:btnCamera atIndex:1];
    priorButtonTag = 0;
    [self.view insertSubview:viewLineBtn atIndex:1];
    [self.view addSubview:buttonRemark];
    [self.view addSubview:buttonAnswer];
    [self.view addSubview:buttonTravelNote];
    [self.view addSubview:buttonStatus];
    [self.view addSubview:viewBasic];
    //在四个按钮下面添加边线
    UIView *underLine = [[UIView alloc] init];
    underLine.frame = CGRectMake(UNDERLINE_X_OFFSET, UNDERLINE_Y_OFFSET * screenHeightPersonal, screenWidthPersonal, screenHeightPersonal * UNDERLINE_HEIGHT_PER);
    underLine.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [self.view insertSubview:underLine atIndex:0];
}

//2
-(void)buttonAnswerClicked:(UIButton *)sender
{
    [self changeLineLocationAndTextColor];
    priorButtonTag = 2;
    [viewLineBtn removeFromSuperview];
    viewLineBtn.frame = CGRectMake(priorButtonTag * screenWidthPersonal * PER_LABEL_GAP_PER, screenHeightPersonal * VIEWLINEBTN_Y_OFFSET_PER, screenWidthPersonal * VIEWLINEBTN_WIDTH_PER, screenHeightPersonal * VIEWLINEBTN_HEIGHT_PER);
    [buttonAnswer setTitleColor:[UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0] forState:UIControlStateNormal];
    [self.view addSubview:viewLineBtn];
}
//3
-(void)buttonRemarkClicked:(UIButton *)sender
{
    [self changeLineLocationAndTextColor];
    priorButtonTag = 3;
    [viewLineBtn removeFromSuperview];
    viewLineBtn.frame = CGRectMake(priorButtonTag * screenWidthPersonal * PER_LABEL_GAP_PER, screenHeightPersonal * VIEWLINEBTN_Y_OFFSET_PER, screenWidthPersonal * VIEWLINEBTN_WIDTH_PER, screenHeightPersonal * VIEWLINEBTN_HEIGHT_PER);
    [buttonRemark setTitleColor:[UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0] forState:UIControlStateNormal];
    [self.view addSubview:viewLineBtn];
    
}
//1
-(void)buttonTravelNoteClicked:(UIButton *)sender
{
    [self changeLineLocationAndTextColor];
    [buttonTravelNote setTitleColor:[UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0] forState:UIControlStateNormal];
    priorButtonTag = 1;
    [viewLineBtn removeFromSuperview];
    viewLineBtn.frame = CGRectMake(priorButtonTag * screenWidthPersonal * PER_LABEL_GAP_PER, screenHeightPersonal * VIEWLINEBTN_Y_OFFSET_PER, screenWidthPersonal * VIEWLINEBTN_WIDTH_PER, screenHeightPersonal * VIEWLINEBTN_HEIGHT_PER);
    [self.view addSubview:viewLineBtn];
}
//0
-(void)buttonStatusClicked:(UIButton *)sender
{
    [self changeLineLocationAndTextColor];
    [buttonStatus setTitleColor:[UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0] forState:UIControlStateNormal];
    priorButtonTag = 0;
    [viewLineBtn removeFromSuperview];
    viewLineBtn.frame = CGRectMake(priorButtonTag * screenWidthPersonal * PER_LABEL_GAP_PER, screenHeightPersonal * VIEWLINEBTN_Y_OFFSET_PER, screenWidthPersonal * VIEWLINEBTN_WIDTH_PER, screenHeightPersonal * VIEWLINEBTN_HEIGHT_PER);
    [self.view addSubview:viewLineBtn];
}

-(void)changeLineLocationAndTextColor
{
    switch (priorButtonTag) {
        case 0:
            [buttonStatus setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        case 1:
            [buttonTravelNote setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        case 2:
            [buttonAnswer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        case 3:
            [buttonRemark setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
   
}
-(void)buttonModifyClicked:(UIButton *)sender
{
    self.hidesBottomBarWhenPushed = YES;
    ModifyPersonalPageVC *mpVC = [[ModifyPersonalPageVC alloc] init];
    [self.navigationController pushViewController:mpVC animated:NO];
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
   // self.hidesBottomBarWhenPushed = NO;
}
-(void)buttonReturnClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 从修改个人信息界面传值 1代表修改成功，0代表修改失败
-(void)passValue:(int)value
{
    recModifySuccessFlag = value;
}

#pragma 从修改个人信息界面传值 1代表修改成功，0代表修改失败 end

#pragma 实现获取头像的代理方法
-(void)headImageDataTransmitBackFinishedBL:(UIImage *)image userTextInfo:(NSDictionary *)userInfo{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(image != nil){
            //recHeadImageTemp = image;
            publicMethod *imageCircle = [[publicMethod alloc] init];
            imageViewHead.image = [imageCircle circleImage:image withParam:1.0];
        }
    });
}
-(void)headImageDataTransmitBackFailedBL:(NSString *)error{
}

-(void)backgroundImageDataTransmitBackFinishedBL:(UIImage *)image{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(image != nil){
            backgroundImageView.image = image;
            //recBackgroundImageTemp = image;
        }
    });
}
-(void)backgroundImageDataTransmitBackFailedBL:(NSString *)error{
    
}

 -(void)userInfoTransmitBackFinishedBL:(NSDictionary *)userInfo{
    if([userInfo objectForKey:@"userName"]){
        labelNameSection0.text = [userInfo objectForKey:@"userName"];
    }
    if([userInfo objectForKey:@"userLevel"]){
        labelLevel.text = [userInfo objectForKey:@"userLevel"];
    }
    if([userInfo objectForKey:@"concerned"]){
        labelConcern.text = [NSString stringWithFormat:@"关注 %@", [userInfo objectForKey:@"concerned"]];;
    }
    if([userInfo objectForKey:@"personalSignature"]){
        labelRemark.text = [userInfo objectForKey:@"personalSignature"];
    }
    if([userInfo objectForKey:@"fans"]){
        labelFansSection0.text = [NSString stringWithFormat:@"粉丝 %@", [userInfo objectForKey:@"fans"]];
    }
}

-(void)userInfoTransmitBackFailedBL:(NSString *)error{
    //如服务器或缓存返回信息出错，则代码部分不做处理，VC端直接显示默认值0
}
#pragma 实现获取头像的代理方法 end
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
