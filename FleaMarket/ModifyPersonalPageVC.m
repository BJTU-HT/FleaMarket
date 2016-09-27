//
//  ModifyPersonalPageVC.m
//  TestDemo1
//
//  Created by Hou on 3/28/16.
//  Copyright © 2016 Hou. All rights reserved.
//

#import "ModifyPersonalPageVC.h"
#import "personalPageViewController.h"
#import "presentLayerPublicMethod.h"
#import "publicMethod.h"
#import "cityListVC.h"
#import "LogInBL.h"
//#import "MyAlertCenter.h"

//HEAD VIEW SIZE
#define VIEWHEAD_HEIGHT_PER 0.5
#define VIEWHEAD_X_OFFSET 0
#define VIEWHEAD_Y_OFFSET 0

//HEADER VIEW IMAGE
#define VIEWIMAGE_X_OFFSET_PER 0.05
#define VIEWIMAGE_Y_OFFSET_PER 0.02
#define VIEWIMAGE_GAP_PER 0.05
#define VIEWIMAGE_WIDTH_PER 0.9
#define VIEWIMAGE_HEIGHT_PER 0.46

//HEADER IMAGE
#define IMAGEHEAD_WIDTH_PER 0.15
#define IMAGEHEAD_Y_OFFSET_PER 0.10
#define LABELHEAD_Y_OFFSET 0.30
#define HEIGHT_ROW_PER 0.10

//昵称， 常住地，性别， 签名
#define NAME_X_OFFSET_PER 0.05
#define NAMELABEL_TEXT_GAP_PER 0.05
#define TEXTFIELD_WIDTH_PER 0.7

@interface ModifyPersonalPageVC ()

@end

@implementation ModifyPersonalPageVC
@synthesize tableVieMP;
@synthesize sheetAlert;
@synthesize labelAddr;

float screenWidthMP;
float screenHeightMP;
NSString *recCityName;
UIImageView *imageViewBackground; //背景图像
UIImageView *imageViewHeadImage; //头像
UIImageView *imageViewHeadImageSquare; //圆形裁剪之前的头像

//UITableViewCell
static UITextField *textFieldUserName;
static UITextField *textFieldPersonalSign;
static UILabel *labelGender;
static UILabel *labelCity;

//用于添加动画
UIView *_superView;

BOOL headImageOrBackgroundImageFlag; // 0代表设置头像 1代表设置背景

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"设置个人资料";
    [self addButtonToNav];
    tableVieMP = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableVieMP.delegate = self;
    tableVieMP.dataSource = self;
    //去除多余的cell空格线
    [tableVieMP setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:tableVieMP];
    screenWidthMP = screenWidthPCH;
    screenHeightMP = screenHeightPCH - statusBarHeightPCH;
    //键盘弹出调整视图
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view.
    [self cacheAndDownloadPersonalInfoModifyPersonalPage];
    [self initBasicTextField];
}


//从服务器或者缓存获取数据 用于界面初始化
-(void)cacheAndDownloadPersonalInfoModifyPersonalPage
{
    LogInBL *logIn = [[LogInBL alloc]init];
    logIn.delegate = self;
    [logIn cacheAndDownloadPersonalInfoBL:@"userInfo.plist"];
}

//代理传值实现方法
-(void)passStrValue:(NSString *)value
{
    dispatch_async(dispatch_get_main_queue(), ^{
        labelCity.text = value;
    });
    //recCityName = value;
}

-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo//计算键盘的高度
{
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    return keyboardEndingFrame.size.height;
}

-(void)keyboardWillDisappear:(NSNotification *)notification
{
    CGRect currentFrame = self.view.frame;
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    currentFrame.size.height += change;
    tableVieMP.frame = currentFrame;
}

-(void)keyboardWillAppear:(NSNotification *)notification
{
    CGRect currentFrame = self.view.frame;
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    currentFrame.size.height = currentFrame.size.height - change;
    tableVieMP.frame = currentFrame;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier= [NSString stringWithFormat:@"cellForRowIdentifier%ld%ld", (long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        //NSLog(@"创建cell中......");
    }else{
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    if(indexPath.row == 0)
    {
        [cell addSubview:[self ViewForFirstRow]];;
    }
    else
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor lightGrayColor];
        float label_x_offset = NAME_X_OFFSET_PER * screenWidthMP;
        //标签字号设为30px 3个字的宽度
        float labelWidth = 30 * 3/4 * 3;
        float labelHeight = 30 * 3/4 * 1.5;
        float label_y_offset = ((screenHeightMP * HEIGHT_ROW_PER) - labelHeight)/2;
        label.frame = CGRectMake(label_x_offset, label_y_offset, labelWidth, labelHeight);
        switch (indexPath.row) {
            case 1:
                if(!label.text)
                    label.text = @"昵称";
                label.font =FontSize14;
                self.labelTagName = label;
                [cell addSubview:self.labelTagName];
                break;
            case 2:
                if(!label.text)
                    label.text = @"性别";
                label.font =FontSize14;
                self.labelTagGender = label;
                [cell addSubview:self.labelTagGender];
                break;
            case 3:
                if(!label.text)
                    label.text = @"常住地";
                label.font =FontSize14;
                self.labelTagCity = label;
                [cell addSubview: self.labelTagCity];
                break;
            case 4:
                if(!label.text)
                    label.text = @"签名";
                label.font =FontSize14;
                self.labelTagPersonalName = label;
                [cell addSubview:self.labelTagPersonalName];
                break;
            default:
                break;
        }
        
        //textField 字号设置为36px
        float textField_x_offset = label_x_offset + labelWidth + screenWidthMP * NAMELABEL_TEXT_GAP_PER;
        float textField_Width = screenWidthMP * TEXTFIELD_WIDTH_PER;
        float textField_Height = 36 * 3/4 * 1.5;
        float textField_y_offset = (screenHeightMP * HEIGHT_ROW_PER - textField_Height)/2;
        if(indexPath.row == 1)
        {
            textFieldUserName.delegate = self;
            textFieldUserName.frame = CGRectMake(textField_x_offset, textField_y_offset, textField_Width, textField_Height);
            textFieldUserName.textColor = orangColorPCH;
            textFieldUserName.font = FontSize14;
            [cell addSubview:textFieldUserName];
        }
        else if(indexPath.row == 4){
            textFieldPersonalSign.delegate = self;
            textFieldPersonalSign.frame = CGRectMake(textField_x_offset, textField_y_offset, textField_Width, textField_Height);
            textFieldPersonalSign.textColor = orangColorPCH;
            textFieldPersonalSign.font = FontSize14;
            [cell addSubview:textFieldPersonalSign];
        }
        else if (indexPath.row == 2)
        {
            //frame 和 UITextfield相同
            labelGender.frame = CGRectMake(textField_x_offset, textField_y_offset, textField_Width, textField_Height);
            labelGender.userInteractionEnabled = YES;
            UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelGenderAddrCilcked:)];
            labelGender.tag = indexPath.row;
            labelGender.textColor = orangColorPCH;
            labelGender.font = FontSize14;
            [labelGender addGestureRecognizer:labelTap];
            [cell addSubview:labelGender];
        }
        else if(indexPath.row == 3){
            
            //frame 和 UITextfield相同
            labelCity.frame = CGRectMake(textField_x_offset, textField_y_offset, textField_Width, textField_Height);
            labelCity.userInteractionEnabled = YES;
            UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelGenderAddrCilcked:)];
            labelCity.tag = indexPath.row;
            labelCity.textColor = orangColorPCH;
            labelCity.font = FontSize14;
            [labelCity addGestureRecognizer:labelTap];
            [cell addSubview:labelCity];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)initBasicTextField{
    if(!textFieldUserName){
        textFieldUserName = [[UITextField alloc] init];
        textFieldUserName.text = @"FleaMarket用户";
    }
    if(!textFieldPersonalSign){
        textFieldPersonalSign = [[UITextField alloc] init];
        textFieldPersonalSign.text = @"未设置1";
    }
    if(!labelCity){
        labelCity = [[UILabel alloc] init];
        labelCity.text = @"未设置1";
    }
    if(!labelGender){
        labelGender = [[UILabel alloc] init];
        labelGender.text = @"保密";
    }
}

-(UILabel *)labelTagCity{
    if(!_labelTagCity){
        _labelTagCity = [[UILabel alloc] init];
    }
    return _labelTagCity;
}

-(UILabel *)labelTagName{
    if(!_labelTagName){
        _labelTagName = [[UILabel alloc] init];
    }
    return _labelTagName;
}

-(UILabel *)labelTagGender{
    if(!_labelTagGender){
        _labelTagGender = [[UILabel alloc] init];
    }
    return _labelTagGender;
}

-(UILabel *)labelTagPersonalName{
    if(!_labelTagPersonalName){
        _labelTagPersonalName = [[UILabel alloc] init];
    }
    return _labelTagPersonalName;
}

//点击性别，常住地响应方法
-(void)labelGenderAddrCilcked:(UITapGestureRecognizer *)recognizer
{
    UILabel *label = (UILabel *)[recognizer view];
    if(label.tag == 2)
    {
        UIAlertController *alertController = [[UIAlertController alloc]init];
        UIAlertAction *actionM = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            label.text = @"男";
            label.textColor = [UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0];
        }];
        UIAlertAction *actionF = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            label.text = @"女";
            label.textColor = [UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0];
        }];
        UIAlertAction *actionSecrect = [UIAlertAction actionWithTitle:@"保密" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            label.text = @"保密";
            label.textColor = [UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0];
        }];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler: nil];
        [alertController addAction:actionF];
        [alertController addAction:actionM];
        [alertController addAction:actionSecrect];
        [alertController addAction:actionCancel];
        [self.view.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
    else if(label.tag == 3)
    {
        self.hidesBottomBarWhenPushed = YES;
        cityListVC *city = [[cityListVC alloc] init];
        [self.navigationController pushViewController:city animated:NO];
        //self.hidesBottomBarWhenPushed = NO;
    }
}

//关闭键盘 UITextField代理方法 关闭键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0)
    {
        return screenHeightMP * VIEWHEAD_HEIGHT_PER;
    }
    else
    {
        return screenHeightMP * HEIGHT_ROW_PER;
    }
}

-(UIView *)ViewForFirstRow
{
    UIView *viewHeader = [[UIView alloc] init];
    viewHeader.frame = CGRectMake(VIEWHEAD_X_OFFSET, VIEWHEAD_Y_OFFSET, screenWidthMP, screenHeightMP * VIEWHEAD_HEIGHT_PER);
    imageViewBackground = [[UIImageView alloc] init];
    imageViewBackground.frame = CGRectMake(VIEWIMAGE_X_OFFSET_PER * screenWidthMP, VIEWIMAGE_Y_OFFSET_PER * screenHeightMP, VIEWIMAGE_WIDTH_PER * screenWidthMP, VIEWIMAGE_HEIGHT_PER * screenHeightMP);
    imageViewBackground.image = [UIImage imageNamed:@"pic1.jpg"];
    
    imageViewHeadImage = [[UIImageView alloc] init];
    publicMethod *publicMP = [[publicMethod alloc] init];
    imageViewHeadImage.image = [publicMP circleImage:[UIImage imageNamed:@"icon_default_face@2x"] withParam:1];

    float imageViewHeadXOffset = screenWidthMP/2 - (screenWidthMP * IMAGEHEAD_WIDTH_PER)/2;
    float imageViewHeadWidth = (screenWidthMP * IMAGEHEAD_WIDTH_PER);
    float imageViewHeadYOffset = screenHeightMP * IMAGEHEAD_Y_OFFSET_PER;
    float imageViewHeadHeight = imageViewHeadWidth;
    imageViewHeadImage.frame = CGRectMake(imageViewHeadXOffset, imageViewHeadYOffset, imageViewHeadWidth, imageViewHeadHeight);
    
    UIButton *buttonHeadImage = [[UIButton alloc] init];
    UIButton *buttonBackgroundImage = [[UIButton alloc] init];
    [buttonHeadImage setTitle:@"设置头像" forState:UIControlStateNormal];
    [buttonHeadImage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonHeadImage addTarget:self action:@selector(buttonSetHeadImageClicked:) forControlEvents:UIControlEventTouchDown];
    buttonHeadImage.tag = 0; // 0代表设置头像
    [buttonBackgroundImage addTarget:self action:@selector(buttonSetBackgroundImageClicked:) forControlEvents:UIControlEventTouchDown];
    [buttonBackgroundImage setTitle:@"设置背景" forState:UIControlStateNormal];
    [buttonBackgroundImage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonBackgroundImage.layer.borderWidth = 2.0;
    buttonBackgroundImage.layer.cornerRadius = 15.0;
    buttonBackgroundImage.layer.borderColor = [UIColor whiteColor].CGColor;
    buttonBackgroundImage.tag = 1; //1代表设置背景图片
    buttonHeadImage.layer.borderWidth = 2.0;
    buttonHeadImage.layer.cornerRadius = 15.0;
    buttonHeadImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //字号设置为30px  5 代表按照五个字设置宽度
    float setHeadWidth = (36 * 3/4 * 4);
    float setHeadXOffset = (screenWidthMP/2 - setHeadWidth)/2;
    float setHeadHeight = (36 * 3/4) * 1.5;
    float setHeadYOffset = screenHeightMP * LABELHEAD_Y_OFFSET;
    buttonBackgroundImage.frame = CGRectMake(setHeadXOffset, setHeadYOffset, setHeadWidth, setHeadHeight);
    
    float setBackgroundWidth = setHeadWidth;
    float setBackgroundXOffset = screenWidthMP/2 + setHeadXOffset;
    float setBackgroundHeight = setHeadHeight;
    float setBackgroundYOffset = setHeadYOffset;
    buttonHeadImage.frame = CGRectMake(setBackgroundXOffset, setBackgroundYOffset, setBackgroundWidth, setBackgroundHeight);

    [viewHeader insertSubview:imageViewBackground atIndex:0];
    [viewHeader insertSubview:buttonHeadImage atIndex:1];
    [viewHeader insertSubview:buttonBackgroundImage atIndex:1];
    [viewHeader insertSubview:imageViewHeadImage atIndex:1];
    return viewHeader;
}

//设置头像按钮响应事件
-(void)buttonSetHeadImageClicked:(UIButton *)sender
{
    [self UesrImageClicked:sender];
}

//设置背景图片按钮响应事件
-(void)buttonSetBackgroundImageClicked:(UIButton *)sender
{
    [self UesrImageClicked:sender];
}

//导航栏左右两个按钮修改为 取消和保存
-(void)addButtonToNav
{
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked:)];
    leftBarItem.tintColor = [UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClicked:)];
    rightBarItem.tintColor = [UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

-(void)cancelButtonClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveButtonClicked:(UIButton *)sender
{
    LogInBL *modify = [[LogInBL alloc] init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *curUser = [userDefaults objectForKey:@"userName"];
    modify.delegate = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:textFieldUserName.text,@"nickName", labelGender.text,@"gender", labelCity.text, @"liveCity", textFieldPersonalSign.text,@"personalSignature", curUser, @"userName", nil];
    [modify cacheAndUploadPersonalLogInInfoBL:dic backgroundImage:imageViewBackground.image headImage:imageViewHeadImage.image];
    [self loadingAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//上传图片时添加等待动画
- (void)loadingAnimation {
    _superView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 20, self.view.frame.size.height/2 - 20, 60, 60)];
    _superView.backgroundColor = ghostWhitePCH;
    _superView.alpha = 1.0;
    _superView.layer.cornerRadius = 10;
    _superView.layer.masksToBounds = YES;
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
    backgroundImage.image = [UIImage imageNamed:@"fit_ptr_icon_fg@2x.png"];
    [_superView addSubview:backgroundImage];
    [self.view addSubview:_superView];

    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
    view.backgroundColor=[UIColor clearColor];
    [_superView addSubview:view];
    
    UIBezierPath *beizPath=[UIBezierPath bezierPathWithArcCenter:CGPointMake(15, 15) radius:20 startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:YES];
    CAShapeLayer *layer=[CAShapeLayer layer];
    layer.path = beizPath.CGPath;
    layer.fillColor=[UIColor clearColor].CGColor;
    layer.strokeColor= orangColorPCH.CGColor;
    layer.lineWidth = 3.0f;
    layer.lineCap = kCALineCapRound;
    [view.layer addSublayer:layer];
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(M_PI*2);
    animation.duration = 0.7;
    animation.repeatCount = HUGE;
    animation.fillMode=kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [view.layer addAnimation:animation forKey:@"animation"];
}

#pragma 从相册选择照片或者用相机拍摄
//load user image
- (void)UesrImageClicked: (UIButton *)sender
{
    UIAlertAction *takePhotoAction;
    UIAlertAction *choosePhotoAction;
    UIAlertAction *cancelAction;
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"选择图像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if(sender.tag == 0){
        headImageOrBackgroundImageFlag = 0;
    }else if(sender.tag == 1){
        headImageOrBackgroundImageFlag = 1;
    }
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self jumpToCameraOrPhotoAlbum:UIImagePickerControllerSourceTypeCamera];
        }];
        choosePhotoAction = [UIAlertAction actionWithTitle:@"选择图像" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self jumpToCameraOrPhotoAlbum: UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler: nil];
        [alertCon addAction:takePhotoAction];
    }
    else {
        choosePhotoAction = [UIAlertAction actionWithTitle:@"选择图像" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self jumpToCameraOrPhotoAlbum: UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler: nil];
    }
    [alertCon addAction:choosePhotoAction];
    [alertCon addAction:cancelAction];
    [self.view.window.rootViewController presentViewController:alertCon animated:NO completion:nil];
}

#pragma mark - action sheet delegte
-(void)jumpToCameraOrPhotoAlbum:(NSUInteger) sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}
#pragma mark - action sheet delegte end

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey: UIImagePickerControllerEditedImage];
    publicMethod *pub = [[publicMethod alloc] init];
    if(headImageOrBackgroundImageFlag == 0){
        imageViewHeadImage.image = [pub circleImage:image withParam:1.0];
    }else if(headImageOrBackgroundImageFlag == 1){
        imageViewBackground.image = image;
    }
}
#pragma 从相册选择照片或者用相机拍摄 end

#pragma ----------Implement  logInBL modify personal Info delegate method-------------
-(void)modifyPersonalInfoFinishedBL:(NSInteger)value{
    if(value)
    {
        [_superView removeFromSuperview];
        personalPageViewController *perPage = [[personalPageViewController alloc] init];
        self.delegateVC = perPage;
        [self.delegateVC passValue:1];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)modifyPersonalInfoFailedBL:(NSString *)error
{
    if(error){
        NSLog(@"报错");
    }
}

#pragma ----------Implement  logInBL modify personal Info delegate method-------------

#pragma 实现获取头像的代理方法
-(void)headImageDataTransmitBackFinishedBL:(UIImage *)image userTextInfo:(NSDictionary *)userInfo{
    dispatch_async(dispatch_get_main_queue(), ^{
        publicMethod *imageCircle = [[publicMethod alloc] init];
        if(image)
            imageViewHeadImage.image = [imageCircle circleImage:image withParam:1.0];
    });
    
}
-(void)headImageDataTransmitBackFailedBL:(NSString *)error{
    //如果图像加载失败则显示默认图像，此函数不做处理
}

-(void)backgroundImageDataTransmitBackFinishedBL:(UIImage *)image{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(image != nil){
            imageViewBackground.image = image;
        }
    });
}
-(void)backgroundImageDataTransmitBackFailedBL:(NSString *)error{
    
}

-(void)userInfoTransmitBackFinishedBL:(NSDictionary *)userInfo{
    if([userInfo objectForKey:@"userName"])
        textFieldUserName.text = [userInfo objectForKey:@"userName"];
    if([userInfo objectForKey:@"personalSignature"])
        textFieldPersonalSign.text = [userInfo objectForKey:@"personalSignature"];
    if([userInfo objectForKey:@"gender"])
        labelGender.text = [userInfo objectForKey:@"gender"];
    if([userInfo objectForKey:@"liveCity"])
        labelCity.text = [userInfo objectForKey:@"liveCity"];

}
-(void)userInfoTransmitBackFailedBL:(NSString *)error{
    //如果返回信息报错，则不作处理，VC界面显示默认值
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
