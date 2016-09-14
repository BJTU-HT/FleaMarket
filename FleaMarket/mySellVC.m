//
//  mySellVC.m
//  FleaMarket
//
//  Created by Hou on 8/24/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "mySellVC.h"
#import "mySellTableViewCell.h"
#import <BmobSDK/BmobUser.h>
#import "presentLayerPublicMethod.h"

@interface mySellVC ()

@end

@implementation mySellVC
float cellHeightSell;

-(void)viewDidLoad {
    [super viewDidLoad];
    cellHeightSell = 150.0f;
    BmobUser *curUser = [BmobUser getCurrentUser];
    [self getSellInfoData:curUser.username];
    self.title = @"我的在售商品";
    // Do any additional setup after loading the view.
}

-(void)initializeTableViewSell{
    CGRect tableViewFrame = CGRectMake(0, 64, screenWidthPCH, screenHeightPCH - 64);
    _tableViewSell = [[UITableView alloc] initWithFrame: tableViewFrame style:UITableViewStylePlain];
    _tableViewSell.delegate = self;
    _tableViewSell.dataSource = self;
    [self.view addSubview:_tableViewSell];
}

-(void)getSellInfoData:(NSString *)userName{
    mySellBL *myBL = [mySellBL sharedManager];
    myBL.delegate = self;
    [myBL getSellGoodsInfoBL:userName];
    [self.activityIndicatorViewSell startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ----get data from server delegate method begin---------------
-(void)sellGoodsInfoSearchFinishedBL:(NSMutableArray *)arr{
    [self.recMutableArrSell addObjectsFromArray: arr];
    [self initializeTableViewSell];
    [self.activityIndicatorViewSell stopAnimating];
}

-(void)sellGoodsInfoSearchFailedBL:(NSError *)error{
    [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"服务器开小差了哦"];
}

-(void)sellGoodsInfoSearchFinishedNoDataBL:(BOOL)value{
    [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"服务器没有相关数据"];
}


#pragma ----get data from server delegate method end-----------------

-(mySellTableViewCell *)sellCellWithTableView:(UITableView *)tableView
                                      cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //解决cell重用问题，采用删除cell子视图
    mySellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cellSell"];
    if(cell == nil) {
        cell = [[mySellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"cellSell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGRect cellFrame = CGRectMake(0, 0, screenWidthPCH, cellHeightSell);
    [cell cellConfig:cellFrame datadic: _recMutableArrSell[indexPath.row]];
    return cell;
}

#pragma ------tableView Delegate and DataSource begin----------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recMutableArrSell.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeightSell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self sellCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma ------tableView Delegate and DataSource end----------------

#pragma ------variables setter and getter method begin-------------
-(NSMutableArray *)recMutableArrSell{
    if(!_recMutableArrSell){
        _recMutableArrSell = [[NSMutableArray alloc] init];
    }
    return _recMutableArrSell;
}

#pragma ------variables setter and getter method end-------------

#pragma ------activity view begin--------------------------------
- (UIActivityIndicatorView *)activityIndicatorViewSell
{
    if (!_activityIndicatorViewSell) {
        _activityIndicatorViewSell = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_activityIndicatorViewSell setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [_activityIndicatorViewSell setBackgroundColor:[UIColor blackColor]];
        _activityIndicatorViewSell.center = self.view.center;
        //[self.view addSubview:_activityIndicatorView];
        [self.view insertSubview:_activityIndicatorViewSell atIndex:1];
    }
    return _activityIndicatorViewSell;
}
#pragma ------activity view end--------------------------------

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
