//
//  SecondhandDetailVC.m
//  FleaMarket
//
//  Created by tom555cat on 16/9/14.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import "SecondhandDetailVC.h"
#import "Help.h"
#import "MainInfoCell.h"
#import "VisitorsCell.h"
#import "CommentCell.h"
#import "CommentFrameModel.h"
#import "MainInfoFrameModel.h"
#import "SecondhandMessageBL.h"
#import "UserInfoSingleton.h"
#import <BmobSDK/BmobUser.h>
#import "logInViewController.h"
#import "DetailChatVC.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"

@interface SecondhandDetailVC () <UITableViewDelegate, UITableViewDataSource, SecondhandMessageBLDelegate,UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic, strong) NSMutableArray *commentFrameArray;
@property (nonatomic, strong) MainInfoFrameModel *mainInfoFrameModel;
// 下拉刷新
//@property (nonatomic, strong) WJRefresh *refresh;
// 业务逻辑层
@property (nonatomic, strong) SecondhandMessageBL *bl;
// 当前评论信息，用来保存当前要发表的评论
@property (nonatomic, strong) SecondhandMessageVO *commentVO;
// 评论弹出框
@property (nonatomic, strong) UITextField *commentInputField;
// 当前键盘是否是弹出的
@property (nonatomic, assign) BOOL isKeyboardPopup;
//201607181632 add by hou
@property (nonatomic, strong) NSString *userObjectID;
// 自定义navigationController
@property (nonatomic, strong) UIView *navView;
// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;
// 更多功能按钮
@property (nonatomic, strong) UIButton *moreBtn;
// 菊花
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation SecondhandDetailVC

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        
        self.bl = [[SecondhandMessageBL alloc] init];
        self.bl.delegate = self;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
    // observe keyboard hide and show notifications to resize the text field
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    //201607181002 modify by hou from YES to NO
    self.navigationController.navigationBarHidden = NO;
    //self.navigationController.toolbarHidden = YES;
    
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    //[self.tableView removeObserver:self.refresh forKeyPath:@"contentOffset"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    [self initViews];
    [self setNav];
    [self initCommentInputField];
    [self initToolBar];
    
    // 重置偏移
    [self.bl reset];
    // 查询评论
    [self.bl findSecondhandMessage:self.model.productID];
    
    // 旋转菊花
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.hud.label.text = NSLocalizedString(@"加载中...", @"HUD loading title");
}

- (void)setNav
{
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidthPCH, 64)];
    navView.alpha = 0;
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    self.navView = navView;
    //下划线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, screen_width, 0.5)];
    lineView.backgroundColor = lightGrayColorPCH;
    [navView addSubview:lineView];
    
    // 返回UIImageView
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 25, 30, 30);
    backBtn.layer.masksToBounds = YES;
    backBtn.layer.cornerRadius = 15;
    backBtn.backgroundColor = [UIColor darkGrayColor];
    backBtn.alpha = 0.8;
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:backBtn];
    self.backBtn = backBtn;
    
    // 更多
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(screenWidthPCH-30-10, 25, 30, 30);
    moreBtn.layer.masksToBounds = YES;
    moreBtn.layer.cornerRadius = 15;
    moreBtn.backgroundColor = [UIColor darkGrayColor];
    moreBtn.alpha = 0.8;
    [moreBtn setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchDown];
    //[self.view addSubview:moreBtn];
    self.moreBtn = moreBtn;
}

- (void)initViews
{
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, screen_width, screen_height-30) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCommentAction)];
    [self.view addSubview:self.tableView];
}

/*
- (void)initRefresh
{
    // 上拉加载
    __weak SecondhandDetailVC *weakSelf = self;
    self.refresh = [[WJRefresh alloc] init];
    [self.refresh addHeardRefreshTo:self.tableView heardBlock:^{
        [weakSelf loadNewDataAction];
    } footBlok:^{
        [weakSelf loadMoreCommentAction];
    }];
}
 */

- (void)initToolBar
{
    // 页脚工具条
    CGFloat toolBarH = 50;
    CGFloat toolBarW = screenWidthPCH;
    CGFloat toolBarX = 0;
    CGFloat toolBarY = screenHeightPCH - toolBarH;
    UIView *toolBarView = [[UIView alloc] init];
    toolBarView.frame = CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);
    toolBarView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:toolBarView];
    
    // toolbar， 评论按钮
    CGFloat commentX = 0;
    CGFloat commentY = 0;
    CGFloat commentBtnW = screenWidthPCH / 2.0f;
    CGFloat commentBtnH = toolBarH;
    UIButton *commentBtn = [[UIButton alloc] init];
    commentBtn.frame = CGRectMake(commentX, commentY, commentBtnW, commentBtnH);
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentProduct:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarView addSubview:commentBtn];
    
    // toolbar,  分享按钮
    CGFloat shareX = commentBtnW;
    CGFloat shareY = 0;
    //CGFloat shareBtnW = screenWidthPCH / 4.0f;
    CGFloat shareBtnH = toolBarH;
    UIButton *shareBtn = [[UIButton alloc] init];
    shareBtn.frame = CGRectMake(shareX, shareY, shareBtnH, shareBtnH);
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    //[toolBarView addSubview:shareBtn];
    
    // toolbar， 我想要
    CGFloat wantX = screenWidthPCH/2.0f;
    CGFloat wantY = 0;
    CGFloat wantBtnW = screenWidthPCH / 2.0f;
    CGFloat wantBtnH = toolBarH;
    UIButton *wantBtn = [[UIButton alloc] init];
    wantBtn.frame = CGRectMake(wantX, wantY, wantBtnW, wantBtnH);
    [wantBtn setTitle:@"我想要" forState:UIControlStateNormal];
    //添加回话跳转页面，跳转到用户之间聊天 20160613-1353
    [wantBtn addTarget:self action:@selector(wantBtnClicked:) forControlEvents:UIControlEventTouchDown];
    wantBtn.backgroundColor = [UIColor redColor];
    [toolBarView addSubview:wantBtn];
}

- (void)initCommentInputField
{
    // 创建评论输入文本框
    UITextField *commentInputField = [[UITextField alloc] init];
    commentInputField.delegate = self;
    self.commentInputField = commentInputField;
    
    // 设置评论输入框
    CGFloat commentWidth = screenWidthPCH;
    CGFloat commentHeight = 50;       // 评论条的高度和工具条的高度一致，并被工具条挡住
    CGFloat commentInputX = 0;
    CGFloat commentInputY = screenHeightPCH - 50;
    self.commentInputField.frame = CGRectMake(commentInputX, commentInputY, commentWidth, commentHeight);
    self.commentInputField.backgroundColor = [UIColor orangeColor];
    self.commentInputField.placeholder = @"输入评论";
    [self.view addSubview:self.commentInputField];
    
    // 创建触摸收回评论触摸事件
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGR.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGR];
}

// 点击屏幕其他地方收回键盘
- (void)keyboardHide:(UITapGestureRecognizer *)tap
{
    [self.commentInputField resignFirstResponder];
}

#pragma mark --- action ---

- (void)shareBtnClicked:(UIButton *)sender
{
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"search1.png"]];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        
        
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
}

-(void)backBtnClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//响应wantBtn点击事件,用于跳转到聊天界面，首先检测是否登录 add by hou
-(void)wantBtnClicked:(UIButton *)sender{
    BmobUser *currentUser = [BmobUser getCurrentUser];
    if(currentUser == nil){
        self.hidesBottomBarWhenPushed = YES;
        logInViewController *logIn = [[logInViewController alloc] init];
        [self.navigationController pushViewController:logIn animated:NO];
        //self.hidesBottomBarWhenPushed = NO;
    }else{
        DetailChatVC *privacyChat = [[DetailChatVC alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        privacyChat.conversation = [self findConversation];
        [self.navigationController pushViewController: privacyChat animated:NO];
    }
}

-(BmobIMConversation *)findConversation{
    NSArray *array = [[BmobIM sharedBmobIM] queryRecentConversation];
    if(array && array.count > 0){
        for(int i = 0; i < array.count; i++){
            BmobIMConversation *conversation = array[i];
            if(conversation.conversationId == self.userObjectID){
                return conversation;
            }
        }
    }
    BmobIMConversation *conversation = [BmobIMConversation conversationWithId:self.userObjectID conversationType:BmobIMConversationTypeSingle];
    conversation.conversationTitle = self.model.userName;
    return conversation;
}


/*
- (void)loadNewDataAction
{
    __weak SecondhandDetailVC *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.refresh endRefresh];
    });
}
*/

- (void)loadMoreCommentAction
{
    __weak SecondhandDetailVC *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.bl findSecondhandMessage:weakSelf.model.productID];
    });
}

- (void)commentProduct:(id)selector
{
    SecondhandMessageVO *commentVO = [[SecondhandMessageVO alloc] init];
    
    UserMO *userMO = [UserInfoSingleton sharedManager].userMO;
    if (userMO == nil) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"评论必须登陆" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [ac addAction:okAction];
        [self presentViewController:ac animated:YES completion:nil];
    }
    
    commentVO.userID = userMO.user_id;
    commentVO.userName = userMO.user_name;
    NSLog(@"%@", commentVO.userName);
    commentVO.userIconImage = userMO.head_image_url;
    commentVO.productID = self.model.productID;
    commentVO.toUserID = self.model.userID;
    commentVO.toUserName = self.model.userName;
    
    self.commentVO = commentVO;
    
    [self.commentInputField becomeFirstResponder];
}

#pragma mark --------------------UITextFieldDelegate----------------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.commentInputField.text = @"";
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //self.commentVO.content = textField.text;
    [textField resignFirstResponder];
    if ([textField.text length] > 0) {
        self.commentVO.content = textField.text;
        [self.bl createComment:self.commentVO];
        // 旋转菊花
        self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    }
    return YES;
}

#pragma mark --- ScrollViewDelegate ---
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"%f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < 350) {
        self.navView.alpha = scrollView.contentOffset.y / 350.0;
    } else {
        self.navView.alpha = 1;
    }
    
    if (scrollView.contentOffset.y < 175) {
        [self.backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [self.moreBtn setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
        self.backBtn.backgroundColor = [UIColor darkGrayColor];
        self.moreBtn.backgroundColor = [UIColor darkGrayColor];
        self.backBtn.alpha = 0.8 * cos(M_PI*scrollView.contentOffset.y/350);
        self.moreBtn.alpha = 0.8 * cos(M_PI*scrollView.contentOffset.y/350);
    } else if (scrollView.contentOffset.y > 175 && scrollView.contentOffset.y < 350){
        [self.backBtn setImage:[UIImage imageNamed:@"back_gray.png"] forState:UIControlStateNormal];
        [self.moreBtn setImage:[UIImage imageNamed:@"more_gray.png"] forState:UIControlStateNormal];
        self.backBtn.backgroundColor = [UIColor whiteColor];
        self.moreBtn.backgroundColor = [UIColor whiteColor];
        self.backBtn.alpha = 0.8 * sin(M_PI*(scrollView.contentOffset.y - 175)/350);
        self.moreBtn.alpha = 0.8 * sin(M_PI*(scrollView.contentOffset.y - 175)/350);
    }
}

#pragma mark --- UITableViewDelegate ---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else {
        return self.commentArray.count;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0000001;
    } else {
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // 评论section的footer是加载更多评论按钮
    if (section == 2) {
        return 5;
    } else {
        return 5;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerView  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen_width, 0)];
    headerView.font = FontSize14;
    
    if (section == 0) {
        headerView.backgroundColor = [UIColor blackColor];
    } else if (section == 1) {
        NSString *content = [NSString stringWithFormat:@"  最近%ld人来访", _model.visitorURLArray.count];
        headerView.backgroundColor = [UIColor whiteColor];
        headerView.frame = CGRectMake(0, 0, screen_width, 30);
        headerView.text = content;
    } else if (section == 2) {
        NSString *content = @"  留言";
        headerView.backgroundColor = [UIColor whiteColor];
        headerView.frame = CGRectMake(0, 0, screen_width, 30);
        headerView.text = content;
    }
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 0)];
    //footerView.backgroundColor = RGB(239, 239, 244);
    //footerView.backgroundColor = [UIColor yellowColor];
    
    return footerView;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 照片和发布人信息
        self.mainInfoFrameModel = [MainInfoFrameModel frameModelWithModel:self.model];
        return self.mainInfoFrameModel.cellHeight;
    } else if (indexPath.section == 1) {
        // 来访人信息
        return 40;
    } else {
        // 评论
        CommentFrameModel *frameModel = [self.commentFrameArray objectAtIndex:indexPath.row];
        return frameModel.cellHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"secondhandinfo";
        MainInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[MainInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.model = self.model;
        cell.frameModel = self.mainInfoFrameModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1) {
        // 保存来访人的头像
        NSMutableArray *visitorArray = _model.visitorURLArray;
        static NSString *cellIdentifier = @"visitorcell";
        VisitorsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[VisitorsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier visitorArray:visitorArray];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        // 留言
        static NSString *cellIdentifier = @"commentcell";
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.model = [self.commentArray objectAtIndex:indexPath.row];
        cell.frameModel = [self.commentFrameArray objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        // 获取留言的对象
        SecondhandMessageVO *commentTo = self.commentArray[indexPath.row];
        SecondhandMessageVO *commentVO = [[SecondhandMessageVO alloc] init];
        
        UserMO *userMO = [UserInfoSingleton sharedManager].userMO;
        if (userMO == nil) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"必须先登陆" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
            [ac addAction:okAction];
            [self presentViewController:ac animated:YES completion:nil];
        }
        
        commentVO.userID = userMO.user_id;
        commentVO.userName = userMO.user_name;
        commentVO.userIconImage = userMO.head_image_url;
        commentVO.productID = self.model.productID;
        commentVO.toUserName = commentTo.userName;
        commentVO.toUserID = commentTo.userID;
        self.commentVO = commentVO;
        
        [self.commentInputField becomeFirstResponder];
    }
}

#pragma --mark --------------------Responding to keyboard events-----------------------

- (void)adjustTextViewByKeyboardState:(BOOL)showKeyboard keyboardInfo:(NSDictionary *)info
{
    UIViewAnimationCurve animationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    UIViewAnimationOptions animationOptions = UIViewAnimationOptionBeginFromCurrentState;
    if (animationCurve == UIViewAnimationCurveEaseIn) {
        animationOptions |= UIViewAnimationOptionCurveEaseIn;
    }
    else if (animationCurve == UIViewAnimationCurveEaseInOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseInOut;
    }
    else if (animationCurve == UIViewAnimationCurveEaseOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseOut;
    }
    else if (animationCurve == UIViewAnimationCurveLinear) {
        animationOptions |= UIViewAnimationOptionCurveLinear;
    }
    
    CGFloat height = 0;
    
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (showKeyboard) {
        NSValue *keyboardFrameVal = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = [keyboardFrameVal CGRectValue];
        height = keyboardFrame.size.height;
        
        // 设置评论框的弹出
        [UIView animateWithDuration:animationDuration delay:0 options:animationOptions animations:^{
            self.commentInputField.frame = CGRectMake(0, screenHeightPCH - screenHeightPCH * 0.08f - height, screenWidthPCH, screenHeightPCH * 0.08f);
        } completion:^(BOOL finished){
            
        }];
    } else {
        // 隐藏评论框
        [UIView animateWithDuration:animationDuration delay:0 options:animationOptions animations:^{
            self.commentInputField.frame = CGRectMake(0, screenHeightPCH, screenWidthPCH - 50, screenHeightPCH * 0.08f);
        } completion:^(BOOL finished){
            
        }];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    self.isKeyboardPopup = YES;
    [self adjustTextViewByKeyboardState:YES keyboardInfo:userInfo];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    self.isKeyboardPopup = NO;
    [self adjustTextViewByKeyboardState:NO keyboardInfo:userInfo];
}


#pragma mark --- SecondhandMessageBLDelegate ---

- (void)findSecondhandMessageFinished:(NSMutableArray *)list
{
    for (SecondhandMessageVO *obj in list) {
        [self.commentArray addObject:obj];
    }
    self.commentFrameArray = [CommentFrameModel frameModelWithArray:self.commentArray];
    
    [self.tableView reloadData];
    //[self.refresh endRefresh];
    if (list.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud hideAnimated:YES];
    });
}

- (void)insertCommentFinished:(SecondhandMessageVO *)model
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    model.publishTime = dateStr;
    
    [self.commentArray insertObject:model atIndex:0];
    [self.commentFrameArray insertObject:[CommentFrameModel frameModelWithModel:model] atIndex:0];
    [self.tableView reloadData];
    
    // 停止菊花
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud hideAnimated:YES];
    });
}


#pragma mark --- getter & setter ---

- (void)setModel:(SecondhandVO *)model
{
    _model = model;
    
    self.userObjectID = model.userID;
}

- (NSMutableArray *)commentArray
{
    if (!_commentArray) {
        _commentArray = [[NSMutableArray alloc] init];
    }
    
    return _commentArray;
}

- (NSMutableArray *)commentFrameArray
{
    if (!_commentFrameArray) {
        _commentFrameArray = [[NSMutableArray alloc] init];
    }
    
    return _commentFrameArray;
}

@end
