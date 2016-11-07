//
//  FriendRequestListVC.m
//  FleaMarket
//
//  Created by Hou on 5/16/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "FriendRequestListVC.h"
#import "presentLayerPublicMethod.h"
#import "ContactsBL.h"
#import "FriendReqListTableViewCell.h"
#import "SysMessage.h"
#import "SystemContact.h"
#import "AddContactsBL.h"

@interface FriendRequestListVC ()

@end

@implementation FriendRequestListVC
@synthesize tableViewReqList;
NSMutableArray *mutableArrRequestList;
UIButton *buttonClickTemp;
- (void)viewDidLoad {
    [super viewDidLoad];
    mutableArrRequestList = [[NSMutableArray alloc] init];
    tableViewReqList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidthPCH, screenHeightPCH) style:UITableViewStylePlain];
    tableViewReqList.delegate = self;
    tableViewReqList.dataSource = self;
    [self.view addSubview:tableViewReqList];
    //获取好友申请列表
    [self loadInvitedMessage];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取好友请求申请
-(void)loadInvitedMessage{
    ContactsBL *conBL = [[ContactsBL alloc] init];
    conBL.delegate = self;
    [conBL loadInvitedMessagesBL];
}

//同意好友申请
-(void)agreeFriendReq:(NSInteger)tag{
    SysMessage *msg = mutableArrRequestList[tag];
    AddContactsBL *addConBL = [[AddContactsBL alloc] init];
    addConBL.delegate = self;
    [addConBL agreeFriendRequest:msg];
}
#pragma 实现获取添加好友申请列表回传数据代理函数
-(void)requesInvitedMessageFinishedBL:(NSMutableArray *)array{
    mutableArrRequestList = array;
    [tableViewReqList reloadData];
}
-(void)requesInvitedMessageFailedBL:(NSString *)error{
    [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"请求添加好友通知列表失败"];
}
#pragma 实现获取添加好友申请列表回传数据代理函数 end

#pragma 同意按钮点击实现
-(void)agreeBtnClicked:(UIButton *)sender{
    buttonClickTemp = [[UIButton alloc] init];
    buttonClickTemp = sender;
    [self agreeFriendReq: sender.tag];
}
#pragma 同意按钮点击实现

#pragma 同意按钮点击后回传数据代理函数实现
-(void)agreeFriendRequestFinishedBL:(BOOL)value{
    if(value){
        [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"添加好友成功"];
        NSLog(@"添加好友成功");
        dispatch_async(dispatch_get_main_queue(), ^{
            [buttonClickTemp setTitle:@"已同意" forState:UIControlStateNormal];
            [buttonClickTemp setTintColor:[UIColor grayColor]];
            [buttonClickTemp setBackgroundColor:orangColorPCH];
            buttonClickTemp.userInteractionEnabled = NO;
        });
        
    }else{
        [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"请稍后重试"];
        NSLog(@"请稍后重试");
    }
}

#pragma 同意按钮点击后回传数据代理函数实现 end
#pragma tableView 代理方法，数据源方法 实现
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mutableArrRequestList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SystemMessageCellID";
    FriendReqListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[FriendReqListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SysMessage *msg = mutableArrRequestList[indexPath.row];
    [cell setStatus:msg];
    cell.agreeBtn.tag = indexPath.row;
    [cell.agreeBtn addTarget:self action:@selector(agreeBtnClicked:) forControlEvents:UIControlEventTouchDown];
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
#pragma tableView 代理方法，数据源方法 实现 end

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
