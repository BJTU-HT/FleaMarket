//
//  bookDetailVC.m
//  FleaMarket
//
//  Created by Hou on 8/2/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "bookDetailVC.h"
#import <BmobSDK/BmobUser.h>
#import "findBookInfoBL.h"
#import "LeaveMessageVC.h"
#import "SearchBookVC.h"
#import "presentLayerPublicMethod.h"

@interface bookDetailVC ()

@end

@implementation bookDetailVC
@synthesize mudic;
NSMutableArray *heightArrRow;
NSMutableArray *heightArrSection;
NSMutableDictionary *heightDic;
NSInteger tagDelegate;
float bottomViewHeightBD;

-(void)viewDidLoad {
    [super viewDidLoad];
    //用于标记代理函数是否执行
    tagDelegate = 0;
    bottomViewHeightBD = 44.0f;
    //BmobUser *curUser = [BmobUser getCurrentUser];
    //从用户表获取关注的人
    //[self requestConcernedDataFromServer:curUser.objectId];
    [self bookDetailRequestLeaveMessageFromServer:[mudic objectForKey:@"objectId"]];
    if(!_tableViewBookDetail){
        [self initTableView];
    }
    // Do any additional setup after loading the view.
    [self initBottomView];
}

-(void)viewWillAppear:(BOOL)animated{
    if(!_tableViewBookDetail){
        [self initTableView];
    }
    if(tagDelegate == 1)
        [_tableViewBookDetail reloadData];
}

-(void)passMudicValue:(NSMutableDictionary *)muDictionary{
    mudic = [[NSMutableDictionary alloc] init];
    mudic = muDictionary;
    [self getHeadImageURL];
}

//leave message success delegate
-(void)passMudicValueLMToSecond:(NSMutableDictionary *)mudicLM{
    if(!mudic){
        mudic = [[NSMutableDictionary alloc] init];
    }
    mudic = mudicLM;
    tagDelegate = 1;
}

-(void)initBottomView{
    
    CGRect bottomViewFrame = CGRectMake(0, screenHeightPCH - bottomViewHeightBD, screenWidthPCH, bottomViewHeightBD);
    if(!_bSPBView){
        _bSPBView = [[bookSecondPageBottomView alloc] initWithFrame:bottomViewFrame];
    }
    [self.view insertSubview:_bSPBView atIndex:1];
    [_bSPBView.remarkBtnBS addTarget:self action:@selector(bSPBViewRemarkBtnClicked:) forControlEvents:UIControlEventTouchDown];
    [_bSPBView.wantedBtnBS addTarget:self action:@selector(wantBtnClicked:) forControlEvents:UIControlEventTouchDown];
}

//从用户表获取关注的人
-(void)requestConcernedDataFromServer:(NSString *)objectId{
    concernBL *conBL = [concernBL sharedManager];
    conBL.delegate = self;
    [conBL requestConcernedDataBL:objectId];
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
    self.bookUserObjectId = [mudic objectForKey:@"objectId"];
    if(array && array.count > 0){
        for(int i = 0; i < array.count; i++){
            BmobIMConversation *conversation = array[i];
            if(conversation.conversationId == self.bookUserObjectId){
                return conversation;
            }
        }
    }
    BmobIMConversation *conversation = [BmobIMConversation conversationWithId:self.bookUserObjectId conversationType:BmobIMConversationTypeSingle];
    conversation.conversationTitle = [mudic objectForKey:@"userName"];
    return conversation;
}

-(void)bSPBViewRemarkBtnClicked:(UIButton *)sender{
    LeaveMessageVC *messageVC = [[LeaveMessageVC alloc] init];
    self.delegateSecToLM = messageVC;
    [self.delegateSecToLM passDicFromSecondToLM:mudic];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVC animated:NO];
}

-(void)initTableView{
    CGRect tableViewFrame = CGRectMake(0, 0, screenWidthPCH, screenHeightPCH - bottomViewHeightBD);
    _tableViewBookDetail = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    _tableViewBookDetail.delegate = self;
    _tableViewBookDetail.dataSource = self;
    [self.view addSubview:_tableViewBookDetail];
    self.title = @"详细信息";
#pragma 解决cell分割线右错15pt的问题
    if ([_tableViewBookDetail respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableViewBookDetail setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableViewBookDetail respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableViewBookDetail setLayoutMargins:UIEdgeInsetsZero];
    }
#pragma 解决右错15pt end
}


-(void)bookDetailRequestLeaveMessageFromServer:(NSString *)objectId{
    publicSearchBL *psbl = [publicSearchBL sharedManager];
    psbl.delegatePSBL = self;
    [psbl getLeaveMessageFromServerBL:objectId];
}


#pragma record visit guys begin
-(void)getHeadImageURL{
    BmobUser *curUser = [BmobUser getCurrentUser];
    if(![[mudic objectForKey: @"userName"] isEqualToString:curUser.username]){
        publicSearchBL *psbl = [publicSearchBL sharedManager];
        psbl.delegatePSBL = self;
        [psbl getUserTableInfoBL:curUser.username];
    }
}

#pragma record visit guys end

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

#pragma publicSearchDelegate begin
-(void)publicSearchFinishedBL:(NSMutableDictionary *)mudicPS{
    [mudic setObject:[mudicPS objectForKey:@"avatar"] forKey:@"visitorURL"];
    findBookInfoBL *fbl = [findBookInfoBL sharedManager];
    [fbl updateVisitorDataBL:mudic];
}

-(void)publicSearchFinishedNODataBL:(BOOL)val{
    if(val){
        NSLog(@"无访客数据");
    }
}

-(void)publicSearchFailedBL:(NSError *)error{
    // do nothing when failed
    if(error){
        NSLog(@"更新访客数据失败...");
    }
}

-(void)returnLeaveMessageFinishedBL:(NSMutableArray *)muArrLM{
    if(muArrLM){
        [mudic setObject:muArrLM forKey:@"contentArr"];
    }
    [_tableViewBookDetail reloadData];
}
#pragma publicSearchDelegate end

#pragma 从用户表获取关注的数据代理函数 begin
-(void)concernedDataRequestFinishedBL:(NSArray *)arr{
    NSString *ownerObjectId = [mudic objectForKey:@"ownerObjectId"];
    BOOL concernTag;
    for(int i = 0; i < arr.count; i++){
        NSString *str = [arr objectAtIndex:i];
        if([str isEqualToString:ownerObjectId]){
            concernTag = 1;
            break;
        }
    }
    if(concernTag){
        dispatch_async(dispatch_get_main_queue(), ^{
            [_bookDetailCell.bookDetail.btnConcernS0 setTitle:@"已关注" forState: UIControlStateNormal];
//            [detailView.btnConcernS0 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//            [detailView.btnConcernS0 setBackgroundColor:[UIColor clearColor]];
        });
    }
}

-(void)concernedDataRequestFailedBL:(NSError *)error{
    [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"未能添加关注"];
}
-(void)cocnernedDataRequestNODataBL:(BOOL)value{
    NSLog(@"Concerned no data");
}

#pragma 从用户表获取关注的数据代理函数 end

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BookDetailTableViewCell *)bookDetailCellWithTableView:(UITableView *)tableView
                                      cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //解决cell重用问题，采用删除cell子视图
    NSString *cellId = [NSString stringWithFormat:@"cell%ld%ld", indexPath.section,indexPath.row];
    _bookDetailCell = [tableView dequeueReusableCellWithIdentifier: cellId];
    if(_bookDetailCell == nil) {
        _bookDetailCell = [[BookDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellId];
    }else{
        //删除cell的所有子视图
        while ([_bookDetailCell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[_bookDetailCell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    _bookDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *strRow = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section, (long)indexPath.row];
    CGRect cell1Frame = CGRectMake(0, 0, screenWidthPCH, [[heightDic objectForKey:strRow] integerValue]);
    NSLog(@"row -- %ld", indexPath.row);

    [_bookDetailCell configCellBook:cell1Frame index:indexPath data:mudic];
    return _bookDetailCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01 * screenHeightPCH;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = whiteSmokePCH;
    return view1;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float cellHeightBookDetail;
    if(indexPath.section == 0){
        cellHeightBookDetail = 60;
    }else if(indexPath.section == 1 || (indexPath.section == 3 && indexPath.row != 0)){
        BookDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if(cell == nil) {
            cell = [[BookDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1" index:indexPath];
        }
        cellHeightBookDetail = [cell configCellBook:cell.frame index:indexPath data: mudic];
        if (cellHeightBookDetail < 45) {
            cellHeightBookDetail = 45;
        }
    }else{
        cellHeightBookDetail = 45;
    }
    if(!heightDic){
        heightDic = [[NSMutableDictionary alloc] init];
    }
    NSString *strRow = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section, (long)indexPath.row];
    NSString *strH = [NSString stringWithFormat:@"%f", cellHeightBookDetail];
    [heightDic setObject:strH forKey:strRow];
    return cellHeightBookDetail;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else if(section == 3){
        NSInteger rowConunt = [[mudic objectForKey:@"contentArr"] count];
        if(rowConunt >= 2 ){
            return rowConunt + 1;
        }else{
            return 2;
        }
    }
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self bookDetailCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 3 && indexPath.row >= 1){
        LeaveMessageVC *messageVC = [[LeaveMessageVC alloc] init];
        self.delegateSecToLM = messageVC;
        [self.delegateSecToLM passDicFromSecondToLM:mudic];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:messageVC animated:NO];
    }
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
