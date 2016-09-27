//
//  addContactsVC.m
//  FleaMarket
//
//  Created by Hou on 5/9/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "addContactsVC.h"
#import "AddContactsBL.h"
#import <BmobIMSDK/BmobIMUserInfo.h>
#import "AddContactsTableViewCell.h"
#import "DetailedAddContactsVC.h"

@interface addContactsVC ()

@end

@implementation addContactsVC
@synthesize tableViewAddContact;

NSMutableArray *userArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加好友";
    userArr = [[NSMutableArray alloc] init];
    tableViewAddContact = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidthPCH, screenHeightPCH) style:UITableViewStylePlain];
    tableViewAddContact.delegate = self;
    tableViewAddContact.dataSource = self;
    [self.view addSubview:tableViewAddContact];
    //绘制导航栏
    [self contactDrawNav];
    //获取用户数据
    [self loadUsers];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadUsers{
    AddContactsBL *addContacts = [[AddContactsBL alloc] init];
    addContacts.delegate = self;
    [addContacts loadUsersBL];
}

-(void)contactDrawNav{
    //201609251624 modify
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backArrow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemClicked:)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    leftBarItem.tintColor = orangColorPCH;

//    UIButton *leftBtn = [[UIButton alloc] init];
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"ic_nav_back@2x.png"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(leftBarItemClicked:) forControlEvents:UIControlEventTouchDown];
//    leftBtn.frame = CGRectMake(0, 0, 50, 20);
//    UIBarButtonItem *leftBarItemAddContact = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftBarItemAddContact;
}

#pragma @selector 方法实现-------------------
-(void)leftBarItemClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma @selector 方法实现 end---------------

#pragma tableView delegate method------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [userArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey1";
    AddContactsTableViewCell *cell=[tableViewAddContact dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
            cell=[[AddContactsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        //NSLog(@"创建cell中......");
    BmobIMUserInfo *userInfo = userArr[indexPath.row];
    [cell setStatus: userInfo];
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
    BmobIMUserInfo *userInfo = userArr[indexPath.row];
    DetailedAddContactsVC *detailAdd = [[DetailedAddContactsVC alloc] init];
    self.delegate = detailAdd;
    [self.delegate passUserInfo:userInfo.avatar nickName:userInfo.name userId:userInfo.userId];
    [self.navigationController pushViewController:detailAdd animated:NO];
}
#pragma tableView delegate method end--------

#pragma 获取用户列表代理回传数据-----------------
-(void)addContactsLoadAllUsersInfoFinishedBL:(NSMutableArray *)arr{
    userArr = arr;
    [tableViewAddContact reloadData];
}
-(void)addContactsLoadAllUsersInfoFailedBL:(NSString *)error{
    
}

#pragma 获取用户列表代理回传数据 end-------------
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
