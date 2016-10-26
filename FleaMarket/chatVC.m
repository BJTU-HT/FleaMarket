//
//  chatVC.m
//  FleaMarket
//
//  Created by Hou on 4/7/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "chatVC.h"
#import "contactsVC.h"
#import <BmobIMSDK/BmobIMSDK.h>
#import <BmobSDK/Bmob.h>
#import "RecentTableViewCell.h"
#import "DetailChatVC.h"
#import "logInViewController.h"

@interface chatVC ()

@end

@implementation chatVC
static NSString *RecentCellID = @"RecentCellID";
float cellHeight;

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天";
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview: _tableView];
    //导航栏左右按钮
    [self ChatDrawNav];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRecentConversations) name: kNewMessageFromer object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRecentConversations) name: kNewMessagesNotifacation object:nil];
    _dataArray = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
}

-(void)checkLogInStatus{
    BmobUser *currentUser = [BmobUser getCurrentUser];
    if(!currentUser){
        logInViewController *logIn = [[logInViewController alloc]init];
        [self.navigationController pushViewController:logIn animated:NO];
    }
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self checkLogInStatus];
    if ([BmobUser getCurrentUser]) {
        [self loadRecentConversations];
    }
}

//获取用户的聊天
-(void)loadRecentConversations{
    NSArray *array = [[BmobIM sharedBmobIM] queryRecentConversation];
    if (array && array.count > 0) {
        [self.dataArray setArray:array];
        [self.tableView reloadData];
    }
}

#pragma ----------2016-09-25-16-02 modify begin ------------------------------------------
-(void)ChatDrawNav{
//    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"friendBlack32.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarFriendButtonClicked:)];
//    self.navigationItem.leftBarButtonItem = leftBarItem;
//    leftBarItem.tintColor = orangColorPCH;
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"friendBlack32new.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarAddFriendButtonClicked:)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    rightBarItem.tintColor = orangColorPCH;
}

-(void)rightBarAddFriendButtonClicked:(UIButton *)sender{
    self.hidesBottomBarWhenPushed = YES;
    contactsVC *contacts = [[contactsVC alloc] init];
    [self.navigationController pushViewController:contacts animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)chatrightBarItemClicked:(UIButton *)sender{

}
#pragma ----------2016-09-25-16-02 modify end    ------------------------------------------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    cellHeight = 72;
    return cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    RecentTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: RecentCellID];
    if(cell == nil){
        cell = [[RecentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RecentCellID];
    }
    BmobIMConversation *conversation = self.dataArray[indexPath.row];
    [cell setStatus: conversation cellHeight:cellHeight];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidthPCH, screenHeightPCH * 0.04)];
    v.backgroundColor = grayColorPCH;
    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return grayLineHeightPCH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BmobIMConversation *conversation = self.dataArray[indexPath.row];
    DetailChatVC *detailChatVC = [[DetailChatVC alloc] init];
    detailChatVC.conversation = conversation;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailChatVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
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
