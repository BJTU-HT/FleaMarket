//
//  BookMainPageVC.m
//  FleaMarket
//
//  Created by Hou on 7/28/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "BookMainPageVC.h"
#import "BookPublishVC.h"
#import "BookUniversityShowVC.h"
#import "CategoryView.h"
#import "bookShowTableViewCell.h"
#import "bookUserInfoTableViewCell.h"
#import "presentLayerPublicMethod.h"
#import "SearchBookVC.h"


@interface BookMainPageVC ()

@end

@implementation BookMainPageVC
float btnHeight;
float sectionHeaderHeight;
NSString *kTextCellID1 = @"cell1";
NSString *kTextCellID2 = @"cell2";

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
    _recMuDic = [[NSMutableArray alloc] init];
    //设置三个按钮的高度
    btnHeight = 50;
    self.tableViewHeight = 0;
    NSMutableDictionary *mudic = [[NSMutableDictionary alloc] init];
    [mudic setObject:@"sell" forKey:@"exchangeCategory"];
    if(!self.recSearchMudic){
        self.recSearchMudic = [[NSMutableDictionary alloc] init];
    }
    if(![self.recSearchMudic objectForKey:@"tag"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self requestBookDataFromServer: mudic];
        });
    }
    [self addButtonToNav];
    [self addSearchBar];
    [self drawThreeBtn];
    [self drawInitTableView];
    //[self drawNav];
}

- (void)tongzhi:(NSNotification *)text{
    NSLog(@"－－－－－接收到通知------");
    [self.recSearchMudic addEntriesFromDictionary:text.userInfo];
}

//-(void)drawNav{
//    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClicked:)];
//    self.navigationItem.leftBarButtonItem = leftBar;
//}
//
//-(void)leftItemClicked:(UIButton *)sender{
//    [self.navigationController popViewControllerAnimated:NO];
//}

-(void)drawInitTableView{
    CGRect tableViewFrame = CGRectMake(0, 64 + btnHeight, screenWidthPCH, 0.94 * screenHeightPCH - 64);
    if(_tableViewBook){
        [_tableViewBook removeFromSuperview];
        _tableViewBook = nil;
    }
    _tableViewBook = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    _tableViewBook.delegate = self;
    _tableViewBook.dataSource = self;
    //用于解决uitableView在popViewController返回之后scrollView下移问题
    self.automaticallyAdjustsScrollViewInsets = NO;
    //set separatorColor
    _tableViewBook.separatorColor = lightGrayColorPCH;
    [self.view insertSubview:_tableViewBook atIndex:0];
    _tableViewBook.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewBookDataAction)];
    _tableViewBook.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreBookDataAction)];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    //添加刷新
//    __weak BookMainPageVC *weakSelf = self;
//    self.refresh = [[WJRefresh alloc] init];
//    [self.refresh addHeardRefreshTo:self.tableViewBook heardBlock:^{
//        [weakSelf loadNewBookDataAction];
//    } footBlok:^{
//        [weakSelf loadMoreBookDataAction];
//    }];
    NSString *str = [self.recSearchMudic objectForKey:@"tag"];
    if([str isEqualToString:@"1"]){
        findBookInfoBL *findBL = [findBookInfoBL sharedManager];
        findBL.delegate = self;
        [findBL getBookDataAccordBookNameFromBmobBL:self.recSearchMudic];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    //[self.refresh removeFromSuperview];
    [self.tableViewBook.mj_footer endRefreshing];
    [self.tableViewBook.mj_header endRefreshing];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tongzhi" object:self];
}

#pragma delegate transfer begin
-(void)passStrValue:(NSString *)str tag:(NSInteger)tag{
    if(tag == 3){
        //交易类型
        [self.btnExchangeCate setTitle:str forState:UIControlStateNormal];
    }else if(tag == 4){
        //书籍分类
        [self.btnBookCate setTitle:str forState:UIControlStateNormal];
    }else{
        //学校选择
        [self.btnSchool setTitle:str forState:UIControlStateNormal];
    }
    [self.cateViewBookMain removeFromSuperview];
    [_recMuDic removeAllObjects];
    [self.recSearchMudic setObject:str forKey:@"test"];
    //向服务器请求数据
    [self requestBookDataFromServer:[self setRequestDictionary]];
}

-(NSMutableDictionary *)recSearchMudic{
    if(!_recSearchMudic){
        _recSearchMudic = [[NSMutableDictionary alloc] init];
    }
    return _recSearchMudic;
}

-(void)searchPagePassValue:(NSMutableDictionary *)mudic{
    NSLog(@"%@", self.recSearchMudic);
    
    if(!self.recSearchMudic){
        self.recSearchMudic = [[NSMutableDictionary alloc] init];
    }
    [self.recSearchMudic addEntriesFromDictionary: mudic];
    _searchBarBook.text = [self.recSearchMudic objectForKey:@"bookName"];
}

#pragma delegate transfer end

-(void)loadNewBookDataAction{
    [self requestBookDataFromServerForDownDrag:[self setRequestDictionary]];
}

-(void)loadMoreBookDataAction{
    [self requestBookDataFromServerForUpDrag:[self setRequestDictionary]];
}
//用于刚进入页面时请求数据
-(void)requestBookDataFromServer:(NSMutableDictionary *)mudic{
    findBookInfoBL *findBookInfo = [findBookInfoBL sharedManager];
    findBookInfo.delegate = self;
    [findBookInfo resetOffset];
    [findBookInfo resetOffsetDownDrag];
    [findBookInfo getBookDataFromBmobBL: mudic];
    [self.activityIndicatorView startAnimating];
}

//用于上拉刷新时请求数据
-(void)requestBookDataFromServerForUpDrag:(NSMutableDictionary *)mudic{
    findBookInfoBL *findBookInfo = [findBookInfoBL sharedManager];
    findBookInfo.delegate = self;
    [findBookInfo getBookDataFromBmobBL: mudic];
    [self.activityIndicatorView startAnimating];
}

//用于下拉刷新时请求数据
-(void)requestBookDataFromServerForDownDrag:(NSMutableDictionary *)mudic{
    if([_recMuDic count]){
       [mudic setObject:[_recMuDic[0] objectForKey:@"createdAt"] forKey:@"time"];
    }
    findBookInfoBL *findBookInfo = [findBookInfoBL sharedManager];
    findBookInfo.delegate = self;
    [findBookInfo getBookDataDownDragFromBmobBL: mudic];
    [self.activityIndicatorView startAnimating];
}
#pragma navigationcontroller part begin
//导航栏左右两个按钮修改为 取消和保存
-(void)addButtonToNav
{
    self.navigationController.navigationBar.tintColor = orangColorPCH;
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClicked:)];
    rightBarItem.tintColor = orangColorPCH;
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

//navigationcontroller add searchBar
-(void)addSearchBar{
    _searchBarBook = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    _searchBarBook.delegate = self;
    _searchBarBook.backgroundColor = [UIColor clearColor];
    _searchBarBook.placeholder = @"搜索书籍";
    NSLog(@"1--%@",_searchBarBook.text);
    self.navigationItem.titleView = _searchBarBook;
    _searchBarBook.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBarBook.autocapitalizationType = UITextAutocapitalizationTypeNone;
}

//点击发布按钮页面跳转
-(void)saveButtonClicked:(UIButton *)sender{
    self.hidesBottomBarWhenPushed = YES;
    BookPublishVC *bookPub = [[BookPublishVC alloc] init];
    [self.navigationController pushViewController:bookPub animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}

//click return image
-(void)returnImageClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma navigationcontroller part begin

#pragma three button begin
-(void)drawThreeBtn{
    for(int i = 0; i < 3; i++)
    {
        NSString *btnLabel;
        UIButton *btn = [[UIButton alloc] init];
        btn.layer.borderColor = grayColorPCH.CGColor;
        btn.layer.borderWidth = 0.5;
        btn.frame = CGRectMake(i * screenWidthPCH/3, 64, screenWidthPCH/3, btnHeight);
        [self.view insertSubview:btn atIndex:1];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
        if(i == 0){
            btnLabel = @"所有高校";
            self.btnSchool = btn;
        }else if(i == 1){
            btnLabel = @"出售";
            self.btnExchangeCate = btn;
        }else if(i == 2){
            btnLabel = @"所有分类";
            self.btnBookCate = btn;
        }
        [btn setTitle:btnLabel forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = FontSize14;
    }
}

//所有学校， 交易分类，图书分类
-(void)btnClicked:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
        {
            BookUniversityShowVC *univer = [[BookUniversityShowVC alloc] init];
            univer.delegateUniversity = self;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:univer animated:NO];
            self.hidesBottomBarWhenPushed = NO;
        }
        break;
        case 1:
        {
            [self btnClickedCase1];
        }
        break;
        case 2:
        {
            [self btnClickedCase2];
        }
        break;
        default:
            break;
    }
}

// btnClicked case1
-(void)btnClickedCase1{
    if(_cateViewBookMain.frame.origin.y != (64 + btnHeight)){
        CGRect cateFrame = CGRectMake(0, 64, screenWidthPCH, tableViewCellHeight32 * 4);
        _cateViewBookMain = [[CategoryView alloc] initWithFrame:cateFrame tag:3];
        _cateViewBookMain.delegate12 = self;
        [self.view insertSubview:_cateViewBookMain atIndex:1];
        [UIView animateWithDuration:0.1  animations:^{
            _cateViewBookMain.frame = CGRectMake(0, 64 + btnHeight, screenWidthPCH, tableViewCellHeight32 * 4);
        } completion:^(BOOL finished) {

        }];
    }else{
        [_cateViewBookMain removeFromSuperview];
        _cateViewBookMain.frame = CGRectMake(0, 0, 0, 0);
    }
}

// btnClicked case2
-(void)btnClickedCase2{
    if(_cateViewBookMain.frame.origin.y != (64 + btnHeight)){
        CGRect cateFrame = CGRectMake(0, 64, screenWidthPCH, tableViewCellHeight32 * 4);
        _cateViewBookMain = [[CategoryView alloc] initWithFrame:cateFrame tag:4];
        _cateViewBookMain.delegate12 = self;
        [self.view insertSubview:_cateViewBookMain atIndex:1];
        [UIView animateWithDuration:0.1  animations:^{
            _cateViewBookMain.frame = CGRectMake(0, 64 + btnHeight, screenWidthPCH, tableViewCellHeight32 * 12);
        } completion:^(BOOL finished) {
        }];
    }else{
        [_cateViewBookMain removeFromSuperview];
        _cateViewBookMain.frame = CGRectMake(0, 0, 0, 0);
    }
}
#pragma three button end

-(NSMutableDictionary *)setRequestDictionary{
    //university bookCategory exchangeCategory 三个关键字，请求字典
    NSMutableDictionary *mudic = [[NSMutableDictionary alloc] init];
    NSString *strSchool = self.btnSchool.titleLabel.text;
    NSString *strExchangeCate = self.btnExchangeCate.titleLabel.text;
    NSString *strBookCate = self.btnBookCate.titleLabel.text;
    if([strSchool rangeOfString:@"所有高校"].location !=NSNotFound){
        dataDic *data = [[dataDic alloc] init];
        NSMutableDictionary *mudicTemp = [[NSMutableDictionary alloc] init];
        mudicTemp = [data readDic];
        NSInteger strLength = [strSchool length] - 4;
        NSString *strCity = [strSchool substringToIndex:strLength];
        NSArray *arr = [mudicTemp objectForKey:strCity];
        [mudic setObject: arr forKey:@"university"];
        [mudic setObject:@"schoolArr" forKey:@"schoolTag"];
    }else{
        [mudic setObject: strSchool forKey:@"university"];
        [mudic setObject:@"schoolAlone" forKey:@"schoolTag"];
    }
    if(![strBookCate isEqualToString:@"所有分类"]){
        [mudic setObject:strBookCate forKey:@"bookCategory"];
    }
    [mudic setObject:[self exchangeCategoryTransferStr:strExchangeCate] forKey:@"exchangeCategory"];
    return mudic;
}

-(NSString *)exchangeCategoryTransferStr:(NSString *)str{
    NSString *resultStr;
    if([str isEqualToString:@"出售"]){
        resultStr = @"sell";
    }else if([str isEqualToString:@"求购"]){
        resultStr = @"buy";
    }else if([str isEqualToString:@"借阅"]){
        resultStr = @"borrow";
    }else if([str isEqualToString:@"赠送"]){
        resultStr = @"present";
    }
    return resultStr;
}
#pragma delegate findBookInfo begin
-(void)searchBookInfoFailedBL:(NSError *)error{
    [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"服务器开小差了哦"];
}

-(void)searchBookInfoFromSearchBL:(NSMutableArray *)arr{
    [_recMuDic removeAllObjects];
    [_recMuDic addObjectsFromArray:arr];
    [_tableViewBook reloadData];
    [self.activityIndicatorView stopAnimating];
}

-(void)searchBookInfoFinishedBL:(NSMutableArray *)arr{
    
    if([arr[arr.count - 1]  isEqual: @"downDrag"]){
        [arr removeObjectAtIndex:arr.count - 1];
        for(NSInteger i = arr.count - 1; i >= 0; i--){
            [_recMuDic insertObject: arr[i] atIndex:0];
        }
        [self.tableViewBook.mj_header endRefreshing];
    }else{
        for(int i = 0; i < arr.count; i++){
            [_recMuDic addObject:arr[i]];
        }
        [self.tableViewBook.mj_footer endRefreshing];
    }
    [_tableViewBook reloadData];
    [self.activityIndicatorView stopAnimating];
}

-(void)searchBookInfoFinishedNODataBL:(NSString *)str{
    //2016-10-20 16:17 cut
    //[presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:str];
    if([str isEqualToString:@"当前页面数据已是最新"]){
        [self.tableViewBook.mj_header endRefreshing];
    }else if([str isEqualToString:@"服务器无数据"]){
        [_tableViewBook reloadData];
        [self.tableViewBook.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableViewBook.mj_footer endRefreshingWithNoMoreData];
    }
    [self.activityIndicatorView stopAnimating];
}
#pragma delegate findBookInfo end

-(bookShowTableViewCell *)bookCellWithTableView:(UITableView *)tableView
                          cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //解决cell重用问题，采用删除cell子视图
    bookShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kTextCellID1];
    if(cell == nil) {
        cell = [[bookShowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: kTextCellID1];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell cellConfig: _recMuDic[indexPath.section]];
    return cell;
}

-(bookUserInfoTableViewCell *)bookUserInfoCellWithTableView:(UITableView *)tableView
                                      cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //解决cell重用问题，采用删除cell子视图
    bookUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kTextCellID2];
    if(cell == nil) {
        cell = [[bookUserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: kTextCellID2];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configBookUserCell: _recMuDic[indexPath.section]];
    return cell;
}

-(CGFloat)configCell:(bookShowTableViewCell *)cell dic:(NSMutableDictionary *)mudic{
    CGFloat cellHeight;
    cellHeight = [cell cellConfig:mudic];
    return cellHeight;
}

#pragma UISearchBarDelegate begin

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSString *strExchangeCate = self.btnExchangeCate.titleLabel.text;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:strExchangeCate forKey:@"exchangeCategory"];
    SearchBookVC *searchBook = [[SearchBookVC alloc] init];
    searchBook.delegateBD = self;
    self.delegateM2S = searchBook;
    [self.delegateM2S passMudicValue:dic];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchBook animated:NO];
    self.hidesBottomBarWhenPushed = NO;
    return NO;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    SearchBookVC *searchBook = [[SearchBookVC alloc] init];
//    [self.navigationController pushViewController:searchBook animated:NO];
}

#pragma UISearchBarDelegate end
#pragma tableview delegate dataSource method begin

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    bookDetailVC *bookDetail = [[bookDetailVC alloc] init];
    self.delegateM2S = bookDetail;
    NSString *strExchangeCate = self.btnExchangeCate.titleLabel.text;
    [_recMuDic[indexPath.section] setObject:[self exchangeCategoryTransferStr:strExchangeCate] forKey:@"exchangeCategory"];
    [self.delegateM2S passMudicValue: _recMuDic[indexPath.section]];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bookDetail animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    sectionHeaderHeight = 0.01 * screenHeightPCH;
    return sectionHeaderHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = whiteSmokePCH;
    return view1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if(indexPath.row == 1){
        bookShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTextCellID1];
        if(cell == nil) {
            cell = [[bookShowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTextCellID1];
        }
        height = [self configCell:cell dic:_recMuDic[indexPath.section]];
        if (height < 85) {
            height = 85;
        }
    }else if(indexPath.row == 0){
        height = 44;
    }
    
    return height;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _recMuDic.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return [self bookUserInfoCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return [self bookCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma tableview delegate dataSource method end
- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [_activityIndicatorView setBackgroundColor:[UIColor blackColor]];
        _activityIndicatorView.center = self.view.center;
        //[self.view addSubview:_activityIndicatorView];
        [self.view insertSubview:_activityIndicatorView atIndex:2];
    }
    return _activityIndicatorView;
}

-(void)didReceiveMemoryWarning {
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
