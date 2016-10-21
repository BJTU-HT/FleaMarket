//
//  BookUniversityShowVC.m
//  FleaMarket
//
//  Created by Hou on 7/28/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "BookUniversityShowVC.h"
#import "dataDic.h"
#import "presentLayerPublicMethod.h"

@interface BookUniversityShowVC ()

@end

@implementation BookUniversityShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSearchBar];
    [self initTableView];
    // Do any additional setup after loading the view.
}

-(void)initSchoolData{
    if(!self.tableData){
        self.tableData = [[NSMutableDictionary alloc] init];
    }
    dataDic *data = [[dataDic alloc] init];
    self.tableData = [data readDic];
    _arrSchool = [self.tableData objectForKey:@"北京"];
}

-(void)initTableView{
    float tableLeftWidth = 0.26 * screenWidthPCH;
    float tableLeftHeight = screenHeightPCH;
    CGRect tableViewLeftFrame = CGRectMake(0, 0, tableLeftWidth, tableLeftHeight);
    self.tableViewLeft = [[UITableView alloc] initWithFrame:tableViewLeftFrame style:UITableViewStylePlain];
    _tableViewLeft.delegate = self;
    _tableViewLeft.dataSource = self;
    _tableViewLeft.separatorStyle = NO;
    [self.view addSubview:_tableViewLeft];
    
    float tableRight_x = tableLeftWidth;
    float tabelRightWidth = screenWidthPCH - tableLeftWidth;
    CGRect tableViewRightFrame = CGRectMake(tableRight_x, 64, tabelRightWidth, tableLeftHeight - 64);
    _tableViewRight = [[UITableView alloc] initWithFrame:tableViewRightFrame style:UITableViewStylePlain];
    _tableViewRight.delegate = self;
    _tableViewRight.dataSource = self;
    [self.view addSubview: _tableViewRight];
    [self getSectionAndCellData];
    [self initSchoolData];
}
//navigationcontroller add searchBar
-(void)addSearchBar{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    searchBar.delegate = self;
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.placeholder = @"搜索学校";

    self.navigationItem.titleView = searchBar;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
}

-(NSArray *)findSchoolDataFromCity:(NSInteger) tag{
    NSArray *array1;
    array1 = [_tableData objectForKey:_dataArr[tag]];
    if(!array1.count){
        [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"该地区目前尚无数据"];
    }
    return array1;
}

#pragma tableview delegate and datasource begin

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView isEqual:_tableViewLeft]){
        return  _dataArr.count;
    }else if([tableView isEqual:_tableViewRight]){
        return _arrSchool.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView isEqual:_tableViewLeft]){
        return 60;
    }else if([tableView isEqual:_tableViewRight]){
        return 44;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView isEqual:_tableViewLeft]){
        UITableViewCell *cellLeft = [_tableViewLeft dequeueReusableCellWithIdentifier:@"cellLeft"];
        if(cellLeft == nil){
            cellLeft = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellLeft"];
        }
        cellLeft.textLabel.text = _dataArr[indexPath.row];
        cellLeft.backgroundColor = lightGrayColorPCH;
        cellLeft.textLabel.font = FontSize14;
        return cellLeft;
        
    }else if([tableView isEqual:_tableViewRight]){
        UITableViewCell *cellRight = [_tableViewLeft dequeueReusableCellWithIdentifier:@"cellRight"];
        if(cellRight == nil){
            cellRight = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellRight"];
        }
        cellRight.textLabel.text = _arrSchool[indexPath.row];
        cellRight.textLabel.font = FontSize12;
        return cellRight;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView isEqual:_tableViewLeft]){
        self.arrSchool = [self findSchoolDataFromCity:indexPath.row];
        [_tableViewRight reloadData];
    }else if([tableView isEqual:_tableViewRight]){
        [self.delegateUniversity passStrValue:_arrSchool[indexPath.row] tag:9];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController popViewControllerAnimated:NO];
        //self.hidesBottomBarWhenPushed = NO;
    }
    
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
#pragma tableview delegate and datasource end

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getSectionAndCellData {
    // 创建要显示的数据
    _dataArr = [[ NSMutableArray alloc ] init ];
    //_sortedArrForArrays = [[ NSMutableArray alloc ] init ];
    //_sectionHeadsKeys = [[ NSMutableArray alloc ] init ];      //initialize a array to hold keys like A,B,C ...
    [ _dataArr addObject : @"北京" ];
    [ _dataArr addObject : @"上海" ];
    [ _dataArr addObject : @"天津" ];
    [ _dataArr addObject : @"重庆" ];
    [ _dataArr addObject : @"辽宁" ];
    [ _dataArr addObject : @"吉林" ];
    [ _dataArr addObject : @"黑龙江" ];
    [ _dataArr addObject : @"河北" ];
    [ _dataArr addObject : @"山西" ];
    [ _dataArr addObject : @"陕西" ];
    [ _dataArr addObject : @"甘肃" ];
    [ _dataArr addObject : @"青海" ];
    [ _dataArr addObject : @"山东" ];
    [ _dataArr addObject : @"安徽" ];
    [ _dataArr addObject : @"江苏" ];
    [ _dataArr addObject : @"浙江" ];
    [ _dataArr addObject : @"河南" ];
    [ _dataArr addObject : @"湖北" ];
    [ _dataArr addObject : @"湖南" ];
    [ _dataArr addObject : @"台湾" ];
    [ _dataArr addObject : @"福建" ];
    [ _dataArr addObject : @"云南" ];
    [ _dataArr addObject : @"海南" ];
    [ _dataArr addObject : @"四川" ];
    [ _dataArr addObject : @"贵州" ];
    [ _dataArr addObject : @"广东" ];
    [ _dataArr addObject : @"内蒙古" ];
    [ _dataArr addObject : @"新疆" ];
    [ _dataArr addObject : @"广西" ];
    [ _dataArr addObject : @"西藏" ];
    [ _dataArr addObject : @"宁夏" ];
    [ _dataArr addObject : @"香港" ];
    [ _dataArr addObject : @"澳门" ];
    [ _dataArr addObject : @"台湾" ];

    // 引用 getChineseStringArr, 并传入参数 , 最后将值赋给 sortedArrForArrays
    //_sortedArrForArrays = [ self getChineseStringArr : _dataArr ];
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
