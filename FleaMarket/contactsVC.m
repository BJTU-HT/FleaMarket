//
//  contactsVC.m
//  FleaMarket
//
//  Created by Hou on 5/9/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "contactsVC.h"
#import "addContactsVC.h"
#import "ContactsBL.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobQuery.h>
#import "ContactsTableViewCell.h"
#import <BmobIMSDK/BmobIMUserInfo.h>
#import "presentLayerPublicMethod.h"
#import "FriendRequestListVC.h"
#import "SysMessage.h"
#import "chatVC.h"
#import "DetailChatVC.h"
#import <BmobIMSDK/BmobIMConversation.h>

@interface contactsVC ()

@end

@implementation contactsVC
@synthesize tableViewContacts;
NSMutableArray *userArrContacts;
BmobUser *userObjID;

- (void)viewDidLoad {
    [super viewDidLoad];
    userArrContacts = [[NSMutableArray alloc] init];
    tableViewContacts = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidthPCH, screenHeightPCH) style:UITableViewStylePlain];
    tableViewContacts.delegate = self;
    tableViewContacts.dataSource = self;
    [self addSearchBar];
    [self.view addSubview:tableViewContacts];
    self.title = @"联系人";
    //绘制导航栏
    [self contactDrawNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    //从服务器加载好友列表
    [self requestDataFromServer];
    //获取用户名用于和数据库建立连接
//    userObjID = [BmobUser getCurrentUser];
//    self.userId = userObjID.objectId;
//    self.token = @"";
//    self.sharedIM = [BmobIM sharedBmobIM];
//    if(userObjID){
//        if ([self.sharedIM isConnected]){
//        [self.sharedIM disconnect];
//    }
//        [self connectToServer];
//    }
}

//-(void)connectToServer{
//    [self.sharedIM setupBelongId:self.userId];
//    [self.sharedIM setupDeviceToken:self.token];
//    [self.sharedIM connect];
//}
-(void)addSearchBar{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, screenWidthPCH, navgationBarHeightPCH)];
    searchBar.delegate = self;
    searchBar.backgroundColor = [UIColor clearColor];
    tableViewContacts.tableHeaderView = searchBar;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
}

//201609251621 modify
-(void)contactDrawNav{
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backArrow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemClicked:)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    leftBarItem.tintColor = orangColorPCH;
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plusOrange32new.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    rightBarItem.tintColor = orangColorPCH;
    
   
    
//    UIBarButtonItem *rightBarItemContact = [[UIBarButtonItem alloc] initWithTitle:@"添加好友" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClicked:)];
//    self.navigationItem.rightBarButtonItem = rightBarItemContact;
//    rightBarItemContact.tintColor = orangColorPCH;
//    UIButton *leftBtn = [[UIButton alloc] init];
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"ic_nav_back@2x.png"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(leftBarItemClicked:) forControlEvents:UIControlEventTouchDown];
//    leftBtn.frame = CGRectMake(0, 0, 55, 20);
//    UIBarButtonItem *leftBarItemContact = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarItemContact;
}

-(void)requestDataFromServer{
    ContactsBL *conBL = [[ContactsBL alloc] init];
    conBL.delegate = self;
    [conBL getMyFriendUsersArrBL];
}

#pragma @selector 方法实现-----------------------
-(void)rightBarItemClicked:(UIButton *)sender{
    self.hidesBottomBarWhenPushed = YES;
    addContactsVC *addContact = [[addContactsVC alloc] init];
    [self.navigationController pushViewController:addContact animated:NO];
    //self.hidesBottomBarWhenPushed = NO;
}

-(void)leftBarItemClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
    if([self.sharedIM isConnected]) {
        [self.sharedIM disconnect];
    }
}
#pragma @selector 方法实现 end-------------------

#pragma 点击屏幕空白处收起键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma 点击屏幕空白处收起键盘end



#pragma  实现tableView协议方法和数据源方法----------

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }
    return [userArrContacts count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey1";
    ContactsTableViewCell *cell=[tableViewContacts dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell=[[ContactsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    //NSLog(@"创建cell中......");
    BmobIMUserInfo *userInfo;
    if(indexPath.section != 0){
        userInfo = userArrContacts[indexPath.row];
    }
    [cell setStatus: userInfo flag:indexPath.section];
    return cell;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        FriendRequestListVC *friendReqList = [[FriendRequestListVC alloc] init];
        [self.navigationController pushViewController:friendReqList animated:NO];
    }else{
        self.hidesBottomBarWhenPushed = YES;
        BmobIMUserInfo *user = userArrContacts[indexPath.row];
        DetailChatVC *detailChat = [[DetailChatVC alloc] init];
        self.delegate = detailChat;
        //建立会话
        BmobIMConversation *conversation = [BmobIMConversation conversationWithId:user.userId conversationType:BmobIMConversationTypeSingle];
        //会话标题
        conversation.conversationTitle = user.name;
        detailChat.conversation = conversation;
        //[self.delegate passConversationValue:conversation];
        [self.navigationController pushViewController:detailChat animated:NO];
        self.hidesBottomBarWhenPushed = NO;
    }
}
#pragma  实现tableView协议方法和数据源方法end-------

#pragma 获取好友列表代理方法实现
-(void)getMyFriendUsersFinishedBL:(NSMutableArray *)array{
    userArrContacts = array;
    [tableViewContacts reloadData];
}
-(void)getMyFriendUsersFaileddBL:(NSString *)error{
    presentLayerPublicMethod *pub = [[presentLayerPublicMethod alloc] init];
    //获取好友列表失败，或服务器无数据
    [pub notifyView:self.navigationController notifyContent:@"服务器无好友数据"];
}

#pragma 获取好友列表代理方法实现 end
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
