//
//  myConcernedVC.m
//  FleaMarket
//
//  Created by Hou on 9/12/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "myConcernedVC.h"
#import "presentLayerPublicMethod.h"
#import "DetailChatVC.h"
#import "logInViewController.h"
#import <BmobSDK/BmobUser.h>

@interface myConcernedVC ()

@end

@implementation myConcernedVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    //向服务器请求数据
    _curUserMyConcerned = [BmobUser getCurrentUser];
    [self requestMyConcernedDataFromServer: _curUserMyConcerned.objectId];
    self.title = @"我的关注";
    CGRect tableViewFrame = CGRectMake(0, 64, screenWidthPCH, screenHeightPCH - 64);
    _tableViewConcerned = [[UITableView alloc] initWithFrame: tableViewFrame style:UITableViewStylePlain];
    _tableViewConcerned.delegate = self;
    _tableViewConcerned.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    //201609261108 add
    [self drawNav];
}

#pragma ----------2016-09-26-11-07 modify begin ------------------------------------------
-(void)drawNav{
    //201609251624 modify
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemClicked:)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    leftBarItem.tintColor = orangColorPCH;
}

-(void)leftBarItemClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma ----------2016-09-26-11-07 modify end ---------------------------------------------

-(void)requestMyConcernedDataFromServer:(NSString *)objectId{
    myConcernedBL *myConBL = [myConcernedBL sharedManager];
    myConBL.delegate = self;
    [myConBL requestMyConcernedConcretedBL:objectId];
    [self.activityIndicatorView startAnimating];
}

//服务器返回数据代理函数
-(void)myConcernedDataRequestFinishedBL:(NSArray *)arr{
    [self.muArrMyConcerned setArray:arr];
    [self.activityIndicatorView stopAnimating];
    [self.view insertSubview:_tableViewConcerned atIndex:0];
}

-(void)myConcernedDataRequestFailedBL:(NSError *)error{
    if(error){
        [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"服务器开小差了哦..."];
    }
    [self.activityIndicatorView stopAnimating];
}

-(void)myCocnernedDataRequestNODataBL:(BOOL)value{
    if(value){
        [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"您尚未关注他人哦..."];
    }
    [self.activityIndicatorView stopAnimating];
}

#pragma property setter getter method begin
-(NSMutableArray *)muArrMyConcerned{
    if(!_muArrMyConcerned){
        _muArrMyConcerned = [[NSMutableArray alloc] init];
    }
    return _muArrMyConcerned;
}

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [_activityIndicatorView setBackgroundColor:[UIColor blackColor]];
        _activityIndicatorView.center = self.view.center;
        //[self.view addSubview:_activityIndicatorView];
        [self.view insertSubview:_activityIndicatorView atIndex:1];
    }
    return _activityIndicatorView;
}
#pragma property setter getter method end



#pragma  tableView delegate and datasource begin
-(myConcernedTableViewCell *)concernedCellWithTableView:(UITableView *)tableView
                        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //解决cell重用问题，采用删除cell子视图
    myConcernedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cellConcerned"];
    if(cell == nil) {
        cell = [[myConcernedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"cellConcerned"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //frame 参数没使用
    [cell cellConfig:self.view.frame datadic: self.muArrMyConcerned[indexPath.row]];
    //添加发消息按钮点击事件
    cell.myConView.btnSendMessageMC.tag = indexPath.row;
    [cell.myConView.btnSendMessageMC addTarget:self action:@selector(sendMesClicked:) forControlEvents:UIControlEventTouchDown];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.muArrMyConcerned.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self concernedCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
}

//清除无数据的多余分割线
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidthPCH, screenHeightPCH * 0.04)];
    v.backgroundColor = grayColorPCH;
    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return grayLineHeightPCH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



#pragma  tableView delegate and datasource end
-(void)sendMesClicked:(UIButton *)sender{
    BmobUser *currentUser = [BmobUser getCurrentUser];
    if(currentUser == nil){
        self.hidesBottomBarWhenPushed = YES;
        logInViewController *logIn = [[logInViewController alloc] init];
        [self.navigationController pushViewController:logIn animated:NO];
        //self.hidesBottomBarWhenPushed = NO;
    }else{
        DetailChatVC *privacyChat = [[DetailChatVC alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        privacyChat.conversation = [self findConversation:sender.tag];
        [self.navigationController pushViewController: privacyChat animated:NO];
    }
}

-(BmobIMConversation *)findConversation:(NSInteger)indexPath{
    NSArray *array = [[BmobIM sharedBmobIM] queryRecentConversation];
    NSString *objectId = [self.muArrMyConcerned[indexPath] objectForKey:@"objectId"];
    if(array && array.count > 0){
        for(int i = 0; i < array.count; i++){
            BmobIMConversation *conversation = array[i];
            if(conversation.conversationId == objectId){
                return conversation;
            }
        }
    }
    BmobIMConversation *conversation = [BmobIMConversation conversationWithId:objectId conversationType:BmobIMConversationTypeSingle];
    conversation.conversationTitle = [self.muArrMyConcerned[indexPath] objectForKey:@"username"];
    return conversation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
