//
//  myVC.m
//  FleaMarket
//
//  Created by Hou on 4/7/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "myVC.h"
#import "logInViewController.h"
#import "setUpViewController.h"
#import "publicMethod.h"
#import "personalPageViewController.h"
#import <BmobSDK/BmobFile.h>
#import <BmobSDK/BmobProFile.h>
#import <BmobSDK/BmobObject.h>
#import "CreateAndSearchPlist.h"
#import "LogInBL.h"
#import "mySellVC.h"
#import "SDImageCache.h"
#import "AboutUsVC.h"
#import "ModifyPersonalPageVC.h"

#define loginPartOccupyScreenPercent 0.15
//第一个section的header view 头像位置所需宏定义
#define loginHeadImageOffset 0.06   //头像距离左侧边框偏移
@interface myVC ()

@end

@implementation myVC

@synthesize logInStatus;
CGRect screenFrame; //屏幕尺寸
CGRect rectStatus;  //状态栏
CGRect rectNav;     //导航栏
float screenWidthForMy;
float headViewHeight;
NSMutableArray *cellMutableArray;
NSMutableArray *cellMutableArrayImage;
NSString *userNameReceiveDelegate;
NSUserDefaults *userDefaultMy;
NSString *userNameMy;
NSDictionary *recDicFromLogIn;
NSMutableData *receiveData;
NSDictionary *userInfoFromCacheOrServer;
UIImage *recHeadImage;

//部分用户界面信息
UILabel *label;
UILabel *labelGuanZhu;
UILabel *labelFans;
UIImageView *headImage;

-(void)viewDidLoad {
    [super viewDidLoad];
    userDefaultMy  = [NSUserDefaults standardUserDefaults];
    userNameMy = [userDefaultMy objectForKey:@"userName"];
    [self drawMyViewPage];
    
    [self initializeArray];
    //暂时撤销这两个按钮，后续迭代 2016-09－20-17-38
//    [self addButtonToNavigationBar];
}

-(void)cacheAndDownloadPersonalInfo
{
    LogInBL *logIn = [[LogInBL alloc]init];
    logIn.delegate = self;
    [logIn cacheAndDownloadPersonalInfoBL:@"userInfo.plist"];
}

-(void)viewWillAppear:(BOOL)animated
{
    userDefaultMy  = [NSUserDefaults standardUserDefaults];
    userNameMy = [userDefaultMy objectForKey:@"userName"];
    self.navigationController.navigationBarHidden = NO;
    if(userNameMy != nil)
        [self cacheAndDownloadPersonalInfo];
    CGRect frame1 = CGRectMake(0, navStatusBarHeightPCH, screenWidthPCH, screenHeightPCH - navStatusBarHeightPCH);
    myTableView = [[ UITableView alloc ]initWithFrame: frame1 style:UITableViewStylePlain];
    myTableView.dataSource = self ;
    myTableView.delegate = self ;
    //解决图标下方无分割线的问题
    myTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
#pragma 解决cell分割线右错15pt的问题
    if ([myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
#pragma 解决右错15pt end
    self.title = @"我的";
    [self.view addSubview: myTableView];
}

#pragma 解决cell分割线右错15pt的问题
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma 分割线右错15pt end

-(void)addButtonToNavigationBar
{
    UIButton* leftBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 32, 32);
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    [leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:leftBtnItem];
    
    UIButton* rightBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"ic_topbar_message_orange@2x.png"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 32, 32);
    UIBarButtonItem* rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [leftBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:rightBtnItem];
}

-(void)leftBtnClicked:(UIButton *)sender
{
    self.hidesBottomBarWhenPushed = YES;
    setUpViewController *setUpVC = [[setUpViewController alloc] init];
    [self.navigationController pushViewController:setUpVC animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)rightBtnClicked:(UIButton *)sender
{
    
}

-(void)passValue:(int)value
{
    NSString *temp = [NSString stringWithFormat:@"%d", value];
    userNameReceiveDelegate = temp;
    logInStatus = 1;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initializeArray
{
    cellMutableArray = [[NSMutableArray alloc] init];
    cellMutableArrayImage = [[NSMutableArray alloc] init];
    
    NSArray *arrayTemp = [[NSArray alloc] initWithObjects: @"我的出售",@"我的关注", nil];
    NSArray *arrayTemp1 = [[NSArray alloc] initWithObjects: @"清空缓存",@"关于我们", nil];
    NSArray *arrayTemp2 = [[NSArray alloc] initWithObjects: @"退出登录", nil];
    //NSArray *arrayTemp3 = [[NSArray alloc] initWithObjects:@"退出登录", nil];
    
    NSArray *arrayImg = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"ic_mine_wengweng@2x.png"],[UIImage imageNamed:@"ic_mine_want@2x.png"], nil];
    NSArray *arrayImg1 = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"ic_mine_note@2x.png"],[UIImage imageNamed:@"ic_mine_order@2x.png"], nil];
    NSArray *arrayImg2 = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"ic_mine_coupon@2x.png"],[UIImage imageNamed:@"ic_mine_comment@2x.png"], nil];
    //NSArray *arrayImg3 = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"ic_mine_qa@2x.png"],[UIImage imageNamed:@"ic_mine_activity@2x.png"], nil];
    [cellMutableArray addObject:arrayTemp];
    [cellMutableArray addObject:arrayTemp1];
    [cellMutableArray addObject:arrayTemp2];
    //[cellMutableArray addObject:arrayTemp3];
    [cellMutableArrayImage addObject:arrayImg];
    [cellMutableArrayImage addObject:arrayImg1];
    [cellMutableArrayImage addObject:arrayImg2];
    //[cellMutableArrayImage addObject:arrayImg3];
}

#pragma 获取缓存大小，清理缓存-------------
-(NSString *)getImageCacheAndDisk{
    float tmpSize = [[SDImageCache sharedImageCache] getSize];
    NSString *tmpSizeStr = [NSString stringWithFormat:@"%.2fMB", tmpSize/1024.0/1024.0];
    return tmpSizeStr;
}

-(void)cleanCacheAndDisk{
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
}
#pragma 获取缓存大小，清理缓存-end---------

#pragma 弹出清理内存提示框并执行操作---------
-(void)popAlertViewForClearCache{
    UIAlertController *alertConLogOut = [UIAlertController alertControllerWithTitle:@"清理缓存" message:@"缓存可以让浏览更流畅哦，确定要清理吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertConfirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cleanCacheAndDisk];
        [myTableView reloadData];
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertConLogOut addAction:alertConfirm];
    [alertConLogOut addAction:alertCancel];
    [self.view.window.rootViewController presentViewController:alertConLogOut animated:NO completion:nil];
}
#pragma 弹出清理内存提示框并执行操作-end------

#pragma 退出登录模块 begin
//退出登录，
-(void)logOutCellClicked
{
    UIAlertController *alertConLogOut = [UIAlertController alertControllerWithTitle:nil message:@"确认退出登录吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertConfirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *defaultLogOut = [NSUserDefaults standardUserDefaults];
        [defaultLogOut setObject:nil forKey:@"userName"];
        [defaultLogOut synchronize];
        [BmobUser logout];
        myVC *myView = [[myVC alloc] init];
        [self.navigationController pushViewController:myView animated:NO];
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertConLogOut addAction:alertConfirm];
    [alertConLogOut addAction:alertCancel];
    [self.view.window.rootViewController presentViewController:alertConLogOut animated:NO completion:nil];
}

#pragma 退出登录模块 end

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 0;
    }else if(section == 3){
        return 1;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 0)
    {
        headViewHeight = screenHeightPCH * loginPartOccupyScreenPercent;
        return headViewHeight;
    }
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view;
    if(section == 0)
    {
        return [self drawSection0];
    }
    return view;
}

//在此设置FooterView目的是，消除多余的cell格
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidthPCH, screenHeightPCH * 0.04)];
    v.backgroundColor = grayColorPCH;
    return v;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return grayLineHeightPCH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey1";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        if(indexPath.section == 3){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }else{
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        //NSLog(@"创建cell中......");
    }
    
    if([cellMutableArray count] > (indexPath.section - 1))
    {
        NSArray *array = [cellMutableArray objectAtIndex:indexPath.section - 1];
        NSArray *arrayImg = [cellMutableArrayImage objectAtIndex:indexPath.section - 1];
        if([array count] > indexPath.row)
        {
            cell.textLabel.text = [array objectAtIndex:indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.imageView.image = [arrayImg objectAtIndex:indexPath.row];
            if(indexPath.section == 2 && indexPath.row == 0){
                cell.detailTextLabel.text = [self getImageCacheAndDisk];
            }
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(userNameMy == nil)
    {
        self.hidesBottomBarWhenPushed = YES;
        logInViewController *logIn = [[logInViewController alloc] init];
        [self.navigationController pushViewController:logIn animated:NO];
        self.hidesBottomBarWhenPushed = NO;
    }
    else
    {
        switch(indexPath.section){
                //我的帖子，我的收藏
            case 1:
                if(indexPath.row == 0)
                {
                    mySellVC *mySell = [[mySellVC alloc] init];
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:mySell animated:NO];
                    self.hidesBottomBarWhenPushed = NO;
                }
                else
                {
                    myConcernedVC *myConcern = [[myConcernedVC alloc] init];
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:myConcern animated: NO];
                    self.hidesBottomBarWhenPushed = NO;
                }
                break;
                //我的记事本，我的订单
            case 2:
                if(indexPath.row == 0){
                    [self popAlertViewForClearCache];
                }else if(indexPath.row == 1){
                    AboutUsVC *aboutVC = [[AboutUsVC alloc] init];
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:aboutVC animated:NO];
                    self.hidesBottomBarWhenPushed = NO;
                }
                break;
                //我的轨迹
            case 3:
                if(indexPath.row == 0){
                    [self logOutCellClicked];
                }
                break;
        }
    }
}



-(void)drawMyViewPage
{
    CGRect frame = CGRectMake(100, 100, 50, 30);
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button.layer setCornerRadius:8];
    button.frame = frame;
    [button addTarget:self action:@selector(buttonLogInClicked:) forControlEvents: UIControlEventTouchDown];
    [self.view  addSubview:button];
}

-(void)buttonLogInClicked:(UIButton *)sender
{
    self.hidesBottomBarWhenPushed = YES;
    logInViewController *logIn = [[logInViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem: backItem];
    [self.navigationController pushViewController: logIn animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}

-(UIView *)drawSection0
{
    UIView *view1 = [[UIView alloc] init];
    if(!userNameMy)
    {
        UIButton *buttonView = [[UIButton alloc] init];
        CGRect buttonViewFrame = CGRectMake(0, 0, screenWidthPCH, headViewHeight);
        buttonView.frame = buttonViewFrame;
        
        UIImageView *headImage = [[UIImageView alloc] init];
        publicMethod *imageCircle = [[publicMethod alloc] init];
        headImage.image = [imageCircle circleImage:[UIImage imageNamed:@"icon_default_face@2x.png"] withParam:1];
        CGRect headImageFrame = CGRectMake(screenWidthPCH * loginHeadImageOffset, headViewHeight * 0.25, headViewHeight * 0.5, headViewHeight * 0.5);
        view1.backgroundColor = [UIColor clearColor];
        headImage.frame = headImageFrame;
        UILabel *label = [[UILabel alloc] init];
        label.text = @"点击登录";
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:24 * 3/4];
        CGRect labelFrame = CGRectMake(screenWidthPCH * 0.28, headViewHeight * 0.40, screenWidthPCH * 0.35, headViewHeight * 0.10);
        label.frame = labelFrame;
        [buttonView addTarget:self action:@selector(buttonViewClicked:) forControlEvents:UIControlEventTouchDown];
        [buttonView addSubview:label];
        [buttonView addSubview:headImage];
        [view1 addSubview:buttonView];
    }
    else
    {
        if(headImage == nil){
            headImage = [[UIImageView alloc] init];
        }
        UIImage *imageHead;
        publicMethod *imageCircle = [[publicMethod alloc] init];
        if(recHeadImage != nil){
            imageHead = recHeadImage;
        }else{
            imageHead = [UIImage imageNamed:@"icon_default_face@2x.png"];
        }
        headImage.image = [imageCircle circleImage:imageHead withParam:1];
        CGRect headImageFrame = CGRectMake(screenWidthPCH * loginHeadImageOffset, headViewHeight * 0.25, headViewHeight * 0.5, headViewHeight * 0.5);
        view1.backgroundColor = [UIColor clearColor];
        headImage.frame = headImageFrame;
        if(label == nil){
            label = [[UILabel alloc] init];
        }
        if(!label.text)
            label.text = @"FleaMarket";
        label.textColor = [UIColor blackColor];
        label.font = FontSize14;
        CGRect labelFrame = CGRectMake(screenWidthPCH * 0.24, headViewHeight * 0.30, screenWidthPCH * 0.35, headViewHeight * 0.14);
        label.frame = labelFrame;
        [view1 addSubview:label];
        [view1 addSubview:headImage];
        
        if(labelGuanZhu == nil){
            labelGuanZhu = [[UILabel alloc] init];
        }
        CGRect labelGuanZhuFrame = CGRectMake(screenWidthPCH * 0.24, headViewHeight * 0.60, screenWidthPCH * 0.20, headViewHeight * 0.05);
        labelGuanZhu.frame = labelGuanZhuFrame;
        if(!labelGuanZhu.text)
            labelGuanZhu.text = @"关注:0";
        labelGuanZhu.textColor = [UIColor lightGrayColor];
        labelGuanZhu.font = [UIFont systemFontOfSize:14];
        [view1 addSubview:labelGuanZhu];
        
        if(labelFans == nil)
            labelFans = [[UILabel alloc] init];
        CGRect labelFansFrame = CGRectMake(screenWidthPCH * (0.24 + 0.15 + 0.05), headViewHeight * 0.60, screenWidthPCH * 0.20, headViewHeight * 0.05);
        labelFans.frame = labelFansFrame;
        if(!labelFans.text)
            labelFans.text = @"出售:0";
        labelFans.textColor = [UIColor lightGrayColor];
        labelFans.font = [UIFont systemFontOfSize:14];
        [view1 addSubview:labelFans];
        
        UIButton *buttonPerson = [[UIButton alloc] init];
        CGRect buttonPersonFrame = CGRectMake(screenWidthPCH *(0.28 + 0.35 + 0.05) , headViewHeight * 0.40, screenWidthPCH * 0.30, 20);
        buttonPerson.frame = buttonPersonFrame;
        UILabel *labelPerson = [[UILabel alloc] init];
        CGRect labelPersonFrame = CGRectMake(0, 0, screenWidthPCH * 0.25, 14);
        labelPerson.frame = labelPersonFrame;
        labelPerson.textAlignment = NSTextAlignmentRight;
        labelPerson.text = @"修改个人资料";
        labelPerson.font = [UIFont systemFontOfSize:12];
        labelPerson.textColor = [UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0];
        [buttonPerson addSubview: labelPerson];
        
        UIImage *imageArrow = [UIImage imageNamed:@"ic_wweng_arrow_orange@2x.png"];
        CGRect imageArrowFrame = CGRectMake(screenWidthPCH * 0.25, 0, 12, 12);
        
        UIImageView *imageArrowView = [[UIImageView alloc] init];
        imageArrowView.image = imageArrow;
        imageArrowView.frame = imageArrowFrame;
        [buttonPerson addSubview:imageArrowView];
        [buttonPerson addTarget:self action:@selector(personalPageClicked:) forControlEvents:UIControlEventTouchDown];
        [view1 addSubview: buttonPerson];
    }
    UITapGestureRecognizer *tapGestureView1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(view1Clicked:)];
    [view1 addGestureRecognizer:tapGestureView1];
    return view1;
}

-(void)view1Clicked:(UITapGestureRecognizer *)recognizer
{
    self.hidesBottomBarWhenPushed = YES;
    ModifyPersonalPageVC *modifyPersonalPage = [[ModifyPersonalPageVC alloc] init];
    [self.navigationController pushViewController:modifyPersonalPage animated:NO];
//    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
//    barItem.title = @"";
//    self.navigationItem.backBarButtonItem = barItem;
//    //    [self.navigationController.navigationBar setTintColor:[UIColor yellowColor]];
//    self.navigationController.navigationBar.alpha = 0.0;
    self.hidesBottomBarWhenPushed = NO;
}
-(void)personalPageClicked:(UIButton *)sender
{
//    self.hidesBottomBarWhenPushed = YES;
//    personalPageViewController *personalPage = [[personalPageViewController alloc] init];
//    [self.navigationController pushViewController:personalPage animated:NO];
//    self.hidesBottomBarWhenPushed = NO;
    //2016-09-20-17-52 modify
    self.hidesBottomBarWhenPushed = YES;
    ModifyPersonalPageVC *modifyPersonalPage = [[ModifyPersonalPageVC alloc] init];
    [self.navigationController pushViewController:modifyPersonalPage animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)buttonViewClicked:(UIButton *)sender
{
    self.hidesBottomBarWhenPushed = YES;
    logInViewController *logIn = [[logInViewController alloc] init];
    [self.navigationController pushViewController:logIn animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma ------------实现passValueForVC 代理方法 接受从登录页面登录成功后传值-------------
-(void)passValueForVC:(NSDictionary *)dic
{
    //用户信息字典
    recDicFromLogIn = dic;
}
#pragma ------------实现passValueForVC 代理方法 接受从登录页面登录成功后传值 end-------------

#pragma 实现获取头像的代理方法
-(void)headImageDataTransmitBackFinishedBL:(UIImage *)image userTextInfo:(NSDictionary *)userInfo{
    dispatch_async(dispatch_get_main_queue(), ^{
        recHeadImage = image;
        if(image != nil){
            publicMethod *imageCircle = [[publicMethod alloc] init];
            headImage.image = [imageCircle circleImage:image withParam:1];
        }
    });
    
}
-(void)headImageDataTransmitBackFailedBL:(NSString *)error{
    
}

-(void)backgroundImageDataTransmitBackFinishedBL:(UIImage *)image{
}
-(void)backgroundImageDataTransmitBackFailedBL:(NSString *)error{
}

-(void)userInfoTransmitBackFinishedBL:(NSDictionary *)userInfo{
    label.text = [userInfo objectForKey:@"userName"];
    if([userInfo objectForKey:@"fans"])
        labelFans.text = [NSString stringWithFormat:@"粉丝: %@", [userInfo objectForKey:@"fans"]];
    if([userInfo objectForKey:@"concerned"])
        labelGuanZhu.text = [NSString stringWithFormat:@"关注: %@", [userInfo objectForKey:@"concerned"]];
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

