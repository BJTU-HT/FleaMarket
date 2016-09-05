//
//  DetailChatVC.m
//  FleaMarket
//
//  Created by Hou on 5/17/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "DetailChatVC.h"
#import "ChatBottomView.h"
#import "SendAndReceiveMessageBL.h"
#import "presentLayerPublicMethod.h"
#import <BmobSDK/BmobUser.h>
#import "ChatBottomControlVIew.h"
#import "TextWeChatTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface DetailChatVC ()

@property (strong, nonatomic) UIRefreshControl   *freshControl;
@property (assign, nonatomic) NSUInteger         page;
@property (assign, nonatomic) BOOL               finished;
@property (strong, nonatomic) NSMutableArray *messageArr;
@property (strong, nonatomic) BmobUser           *loginUser;
@property (strong, nonatomic) BmobIMUserInfo *userInfo;
@property (strong, nonatomic) ChatBottomView *bottomView;
@property (strong, nonatomic) ChatBottomControlVIew *chatConView;
@property (weak, nonatomic) NSLayoutConstraint *bottomConstraint;

@end

@implementation DetailChatVC

static NSString *kTextCellID     = @"ChatCellID";
static NSString *kImageCellID    = @"imageChatCellID";
static NSString *kAudioCellID    = @"audioCellID";
static NSString *kLocationCellID = @"locationCellID";
@synthesize tableViewChat;
@synthesize conversation;
@synthesize messageArr;
@synthesize bottomView;
@synthesize chatConView;

float bottomViewHeight = 49;
CGRect bottomInitialFrame;
CGRect tableViewframe;
BmobUser *user1;
//static CGFloat  kBottomContentViewHeight = 105.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBottomView];
    tableViewframe = CGRectMake(0, 64, screenWidthPCH, screenHeightPCH - navgationBarHeightPCH - statusBarHeightPCH - bottomViewHeight);
    tableViewChat = [[UITableView alloc] initWithFrame:tableViewframe style:UITableViewStylePlain];
    tableViewChat.delegate = self;
    tableViewChat.dataSource = self;
    //[tableViewChat registerClass:[TextChatTableViewCell class] forCellReuseIdentifier:kTextCellID];
    [self.view addSubview:tableViewChat];
    _loginUser = [BmobUser getCurrentUser];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:kNewMessagesNotifacation object:nil];

    messageArr = [[NSMutableArray alloc] init];
    self.page = 0;
    
    [self loadMessageRecords];
    _freshControl = [[UIRefreshControl alloc] init];
    [tableViewChat addSubview:self.freshControl];
    //隐藏分割线
    tableViewChat.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewChat.backgroundColor = defaultViewBackgroundColorPCH;
    self.view.backgroundColor = defaultViewBackgroundColorPCH;
    [self.freshControl addTarget:self action:@selector(loadMoreRecords) forControlEvents:UIControlEventValueChanged];

    self.title = self.conversation.conversationTitle;
    self.sharedIM = [BmobIM sharedBmobIM];
    self.userInfo = [self.sharedIM userInfoWithUserId:conversation.conversationId];
    [self.conversation updateLocalCache];
}

-(void)addBottomView{
    bottomInitialFrame = CGRectMake(0, screenHeightPCH - bottomViewHeight, screenWidthPCH, bottomViewHeight);
    bottomView = [[ChatBottomView alloc ]initWithFrame: bottomInitialFrame];
    bottomView.textField.delegate = self;
    //[bottomView.addBtn addTarget:self action:@selector(showBottomContentView) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:bottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)connectToServer{
    [self.sharedIM setupBelongId:self.userId];
    [self.sharedIM setupDeviceToken:self.token];
    [self.sharedIM connect];
}
//注册键盘弹出关闭监听通知
-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHiden:) name:UIKeyboardWillHideNotification object:nil];
    user1 = [BmobUser getCurrentUser];
    self.token = @"";
    self.userId = user1.objectId;
    if(user1){
        if([self.sharedIM isConnected]) {
        [self.sharedIM disconnect];
        }
        [self connectToServer];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.conversation updateLocalCache];
    if ([self.sharedIM isConnected]) {
        [self.sharedIM disconnect];
    }
}

#pragma @slelctor
//-(void)addBtnClicked:(UIButton *)sender{
//    float chatConViewHeight = 200.0;
//    CGRect chatConViewFrame = CGRectMake(0, self.view.frame.size.height - chatConViewHeight, screenWidthPCH, chatConViewHeight);
//    chatConView = [[ChatBottomControlVIew alloc] initWithFrame:chatConViewFrame];
//    CGRect bottomViewFrame = bottomInitialFrame;
//    bottomViewFrame.origin.y -= chatConViewHeight;
//    bottomView.frame = bottomViewFrame;
//    [self.view insertSubview:chatConView atIndex:1];
//    [self.view endEditing:YES];
//}
//键盘弹出
-(void)keyBoardWillShow:(NSNotification *)noti{
    CGRect bottomViewCurrentFrame = bottomInitialFrame;
    CGRect tableViewCurrentFrame = tableViewframe;
    CGFloat change = [self keyboardEndingFrameHeight:[noti userInfo]];
    tableViewCurrentFrame.size.height -= change;
    bottomViewCurrentFrame.origin.y -= change;
    bottomView.frame = bottomViewCurrentFrame;
    tableViewChat.frame = tableViewCurrentFrame;
    if (messageArr.count > 0) {
        [tableViewChat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

//键盘收起
-(void)keyBoardWillHiden:(NSNotification *)noti{
    CGRect bottomViewCurrentFrame = bottomView.frame;
    CGRect tableViewCurrentFrame = tableViewframe;
    CGFloat change = [self keyboardEndingFrameHeight:[noti userInfo]];
    bottomViewCurrentFrame.origin.y += change;
    bottomView.frame = bottomViewCurrentFrame;
    tableViewChat.frame = tableViewCurrentFrame;
    if (messageArr.count > 0) {
        [tableViewChat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

//接收会话信息
-(void)receiveMessage:(NSNotification *)noti{
    SendAndReceiveMessageBL *receiveBL = [[SendAndReceiveMessageBL alloc] init];
    receiveBL.delegate = self;
    [receiveBL receiveMessageBL:noti conversation:conversation];
}

//loadRecords or loadMessage
-(void)loadMessageRecords{
    SendAndReceiveMessageBL *loadMessage = [[SendAndReceiveMessageBL alloc] init];
    loadMessage.delegate = self;
    [loadMessage loadMessageDeliverBL:self.conversation];
}

//loadMoreRecords UIRefreshControl
-(void)loadMoreRecords{
    if (!self.finished) {
        self.page ++;
        [self.freshControl beginRefreshing];
        
        if (messageArr.count <= 0) {
            [self.freshControl endRefreshing];
            return;
        }
        BmobIMMessage *msg = [messageArr firstObject];
        NSArray *array = [self.conversation queryMessagesWithMessage:msg limit:10];
        if (array && array.count > 0) {
            NSMutableArray *messages = [NSMutableArray arrayWithArray:messageArr];
            [messages addObjectsFromArray:array];
            NSArray *result = [messages sortedArrayUsingComparator:^NSComparisonResult(BmobIMMessage *obj1, BmobIMMessage *obj2) {
                if (obj1.updatedTime > obj2.updatedTime) {
                    return NSOrderedDescending;
                }else if(obj1.updatedTime <  obj2.updatedTime) {
                    return NSOrderedAscending;
                }else{
                    return NSOrderedSame;
                }
            }];
            
            [messageArr setArray:result];
            [tableViewChat reloadData];
        }else{
            self.finished = YES;
            [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:NO_MORE_HISTORY_RECORDS];
        }
        
    }else{
        [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:NO_MORE_HISTORY_RECORDS];
    }
    
    [self.freshControl endRefreshing];
}
#pragma @selector end

//计算键盘的高度
-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo{
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    return keyboardEndingFrame.size.height;
}

-(void)scrollToBottom{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:messageArr.count-1 inSection:0];
    [tableViewChat insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [tableViewChat scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
//关闭键盘 UITextField代理方法 关闭键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self sendTextWithTextField:textField];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    //用于点击屏幕是关闭键盘时，调整尺寸
    bottomView.frame = bottomInitialFrame;
    tableViewChat.frame = tableViewframe;
}

#pragma 从联系人页面接受要聊天的用户名
-(void)passConversationValue:(BmobIMConversation *)value{
    self.conversation = value;
    self.title = self.conversation.conversationTitle;
}
#pragma 从联系人页面接受要聊天的用户名end

//实现BL层接收会话信息的代理方法
-(void)SendAndReceiveMessageDeliverBL:(BmobIMMessage *)message{
    [messageArr addObject:message];
    [self scrollToBottom];
}
//loadMessage 数据回传到VC
-(void)loadMessageDeliverFinishedBL:(NSArray *)array{
    [messageArr setArray:array];
    [tableViewChat reloadData];
    [tableViewChat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
-(void)loadMessageDeliverFailedBL:(NSString *)error{
    [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:NO_HISTORY_RECORDS];
}
//loadMoreRecords 数据回传到VC
-(void)loadMoreRecordsFinishedBL:(NSArray *)array{
    //array 已经包含loadMessage中的信息
    [messageArr setArray:array];
    [tableViewChat reloadData];
}
-(void)loadMoreRecordsFailedBL:(NSString *)error{
    [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:NO_MORE_HISTORY_RECORDS];
    self.finished = YES;
}

#pragma config cell
-(TextWeChatTableViewCell *)textCellWithTableView:(UITableView *)tableView
                          cellForRowAtIndexPath:(NSIndexPath *)indexPath
                                        message:(BmobIMMessage *)msg{
    //解决cell重用问题，采用删除cell子视图
    TextWeChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kTextCellID];
    if(cell == nil) {
        cell = [[TextWeChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: kTextCellID];
    }else{
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell cellConfigMsg:msg userInfo: self.userInfo];
    return cell;
}



//-(void)configCell:(TextWeChatTableViewCell *)cell message:(BmobIMMessage *)msg{
//    if ([self.loginUser.objectId isEqualToString:msg.fromId]) {
//        [cell setMsg:msg userInfo:nil];
//    }else{
//        [cell setMsg:msg userInfo:self.userInfo];
//    }
//}

-(CGFloat)configCell:(TextWeChatTableViewCell *)cell message:(BmobIMMessage *)msg{
    CGFloat cellHeight;
    cellHeight = [cell cellConfigMsg:msg userInfo:self.userInfo];
    return cellHeight;
}

#pragma config cell end
#pragma tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return messageArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BmobIMMessage *msg = messageArr[indexPath.row];
    if ([msg.msgType isEqualToString:kMessageTypeText]) {
        return [self textCellWithTableView:tableView cellForRowAtIndexPath:indexPath message:msg];
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 0;
    BmobIMMessage *msg = messageArr[indexPath.row];
    TextWeChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTextCellID];
    if(cell == nil) {
        cell = [[TextWeChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTextCellID];
    }
    if([msg.msgType isEqualToString:kMessageTypeText]) {
        height = [self configCell:cell message:msg];
//        height =   [tableView fd_heightForCellWithIdentifier:kTextCellID  configuration:^(TextChatTableViewCell *cell) {
//            [self configCell:cell message:msg];
        //}];
    }

    if (height < 85) {
        height = 85;
    }
    return height;
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
#pragma tableView 代理方法end

-(void)sendTextWithTextField:(UITextField *)textField{
    if (textField.text.length == 0) {
        //[self showInfomation:@"请输入内容"];
    }else{
        
        BmobIMTextMessage *message = [BmobIMTextMessage messageWithText:textField.text attributes:nil];
        message.conversationType =  BmobIMConversationTypeSingle;
        message.createdTime = (uint64_t)([[NSDate date] timeIntervalSince1970] * 1000);
        message.updatedTime = message.createdTime;
        BmobUser *userSend = [BmobUser getCurrentUser];
        message.fromId = userSend.objectId;
        [messageArr addObject:message];
        [self scrollToBottom];
        self.bottomView.textField.text = nil;
        
        __weak typeof(self)weakSelf = self;
        [self.conversation sendMessage:message completion:^(BOOL isSuccessful, NSError *error) {
            NSLog(@"123");
           [weakSelf reloadLastRow];
        }];
        
    }
}

-(void)reloadLastRow{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:messageArr.count-1 inSection:0];
    [tableViewChat reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
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
