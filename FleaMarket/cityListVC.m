//
//  cityListVC.m
//  TestDemo1
//
//  Created by Hou on 3/31/16.
//  Copyright © 2016 Hou. All rights reserved.
//

#import "cityListVC.h"
#import "ModifyPersonalPageVC.h"
#import "ChineseString.h"
#import "pinyin.h"

//国内国际切换，相对于屏幕的高度百分比
#define BUTTON_HEIGHT_PER 0.08
#define BUTTON_Y_OFFSET 0
#define BUTTON_X_OFFSET 0
#define VIEW_ORANGE_LINE_HEIGHT_PER 0.003
#define SEPRATE_LINE_HEIGHT_PER 0.0005
#define VIEW_LINE_X_OFFSET 0
#define SEPRATE_LINE_Y_OFFSET 0.082
#define VIEW_ORANGE_LINE_Y_OFFSET BUTTON_HEIGHT_PER - VIEW_ORANGE_LINE_HEIGHT_PER
#define VIEW_ORANGE_LINE_X_OFFSET 0
//gps 定位label
#define GPS_LABEL_HEIGHT_PER 0.05
#define GPS_LABEL_Y_OFFSET SEPRATE_LINE_Y_OFFSET
//表格视图
#define TABLEVIEW_Y_OFFSET_PER GPS_LABEL_Y_OFFSET + GPS_LABEL_HEIGHT_PER

@interface cityListVC ()

@end

@implementation cityListVC
@synthesize tableViewCity;
float screenWidthCity;
float screenHeightCity;
float offsetExtra;
UIColor *orangeColor;
UIView *viewYellowLine;
UIButton *internationalBtn;
UIButton *internalBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    tableViewCity = [[UITableView alloc] init];
    tableViewCity.delegate = self;
    tableViewCity.dataSource = self;
    screenWidthCity = self.view.bounds.size.width;
    screenHeightCity = self.view.bounds.size.height;
    self.title = @"城市选择";
    orangeColor = [UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0];
    CGRect rectStatusCity = [[UIApplication sharedApplication] statusBarFrame];
    float statusHeight = rectStatusCity.size.height;
    offsetExtra = self.navigationController.navigationBar.bounds.size.height + statusHeight;
    [self modifyNavButton];
    [self drawButtonGuoNeiGuoWai];
    [self getSectionAndCellData];
    // Do any additional setup after loading the view.
}

-(void)getSectionAndCellData {
    // 创建要显示的数据
    _dataArr = [[ NSMutableArray alloc ] init ];
    _sortedArrForArrays = [[ NSMutableArray alloc ] init ];
    _sectionHeadsKeys = [[ NSMutableArray alloc ] init ];      //initialize a array to hold keys like A,B,C ...
    
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
    [ _dataArr addObject : @"内蒙古"];
    [ _dataArr addObject : @"新疆" ];
    [ _dataArr addObject : @"广西" ];
    [ _dataArr addObject : @"西藏" ];
    [ _dataArr addObject : @"宁夏" ];
    [ _dataArr addObject : @"北京" ];
    [ _dataArr addObject : @"上海" ];
    [ _dataArr addObject : @"天津" ];
    [ _dataArr addObject : @"香港" ];
    [ _dataArr addObject : @"澳门" ];
    // 引用 getChineseStringArr, 并传入参数 , 最后将值赋给 sortedArrForArrays
    _sortedArrForArrays = [ self getChineseStringArr: _dataArr];
}

// 固定代码 , 每次使用只需要将数据模型替换就好 , 这个方法是获取首字母 , 将填充给 cell 的值按照首字母排序

-(NSMutableArray *)getChineseStringArr:( NSMutableArray *)arrToSort
{
    // 创建一个临时的变动数组
    NSMutableArray *chineseStringsArray = [ NSMutableArray array ];
    for ( int i = 0 ; i < [arrToSort count ]; i++)
    {
        // 创建一个临时的数据模型对象
        ChineseString *chineseString=[[ChineseString alloc] init];
        // 给模型赋值
        chineseString.string = [ NSString stringWithString :[arrToSort objectAtIndex :i]];
        if (chineseString.string == nil )
        {
            chineseString.string = @"";
        }
        if (![chineseString. string isEqualToString : @"" ])
        {
            //join( 链接 ) the pinYin (letter 字母 )  链接到首字母
            NSString *pinYinResult = [ NSString string ];
            // 按照数据模型中 row 的个数循
            for ( int j = 0 ;j < chineseString. string . length ; j++)
            {
                NSString *singlePinyinLetter = [[ NSString stringWithFormat : @"%c" ,
                                                 pinyinFirstLetter ([chineseString.string characterAtIndex :j])] uppercaseString ];
                pinYinResult = [pinYinResult stringByAppendingString :singlePinyinLetter];
            }
            chineseString. pinYin = pinYinResult;
        }
        else
        {
            chineseString. pinYin = @"" ;
        }
        [chineseStringsArray addObject :chineseString];
    }
    //sort( 排序 ) the ChineseStringArr by pinYin( 首字母 )
    NSArray *sortDescriptors = [ NSArray arrayWithObject :[ NSSortDescriptor sortDescriptorWithKey : @"pinYin" ascending : YES ]];
    [chineseStringsArray sortUsingDescriptors :sortDescriptors];
    NSMutableArray *arrayForArrays = [ NSMutableArray array ];
    BOOL checkValueAtIndex= NO ;  //flag to check
    NSMutableArray *TempArrForGrouping = nil ;
    for ( int index = 0 ; index < [chineseStringsArray count ]; index++)
    {
        ChineseString *chineseStr = ( ChineseString *)[chineseStringsArray objectAtIndex :index];
        NSMutableString *strchar= [ NSMutableString stringWithString :chineseStr. pinYin ];
        NSString *sr= [strchar substringToIndex : 1 ];
        //sr containing here the first character of each string  ( 这里包含的每个字符串的第一个字符 )
        //NSLog ( @"%@" ,sr);
        //here I'm checking whether the character already in the selection header keys or not  ( 检查字符是否已经选择头键 )
        if (![ _sectionHeadsKeys containsObject :[sr uppercaseString ]])
        {
            [ _sectionHeadsKeys addObject :[sr uppercaseString ]];
            TempArrForGrouping = [[ NSMutableArray alloc ] init];
            checkValueAtIndex = NO;
        }
        if ([ _sectionHeadsKeys containsObject :[sr uppercaseString ]])
        {
            [TempArrForGrouping addObject :[chineseStringsArray objectAtIndex :index]];
            if (checkValueAtIndex == NO )
            {
                [arrayForArrays addObject :TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    return arrayForArrays;
}
-(void)drawButtonGuoNeiGuoWai
{
    UIView *viewLineCity = [[UIView alloc] init];
    
    viewLineCity.frame = CGRectMake(VIEW_LINE_X_OFFSET, screenHeightCity * SEPRATE_LINE_Y_OFFSET +offsetExtra, screenWidthCity, screenHeightCity * SEPRATE_LINE_HEIGHT_PER);
    viewLineCity.backgroundColor = [UIColor lightGrayColor];
    
    
    internalBtn = [[UIButton alloc] init];
    internalBtn.frame = CGRectMake(BUTTON_X_OFFSET, BUTTON_Y_OFFSET + offsetExtra, screenWidthCity/2, screenHeightCity * BUTTON_HEIGHT_PER);
    internalBtn.backgroundColor = [UIColor whiteColor];
    [internalBtn setTitle:@"国内" forState:UIControlStateNormal];
    [internalBtn setTitleColor:orangeColor forState:UIControlStateNormal];
    [internalBtn addTarget:self action:@selector(internalBtnClicked:) forControlEvents:UIControlEventTouchDown];
    
    internationalBtn = [[UIButton alloc] init];
    internationalBtn.frame = CGRectMake(screenWidthCity/2, BUTTON_Y_OFFSET + offsetExtra, screenWidthCity/2, screenHeightCity * BUTTON_HEIGHT_PER);
    internationalBtn.backgroundColor = [UIColor whiteColor];
    [internationalBtn setTitle:@"国外" forState:UIControlStateNormal];
    [internationalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [internationalBtn addTarget:self action:@selector(internationalBtnClicked:) forControlEvents:UIControlEventTouchDown];

    viewYellowLine = [[UIView alloc] init];
    viewYellowLine.frame = CGRectMake(screenWidthCity/8, screenHeightCity * VIEW_ORANGE_LINE_Y_OFFSET  + offsetExtra, screenWidthCity/4, screenHeightCity * VIEW_ORANGE_LINE_HEIGHT_PER);
    viewYellowLine.backgroundColor = orangeColor;
    
    [self.view addSubview:internationalBtn];
    [self.view addSubview:internalBtn];
    [self.view addSubview:viewLineCity];
    [self.view addSubview:viewYellowLine];
    
    //添加GPS定位部分
    UILabel *GPSLabel = [[UILabel alloc] init];
    GPSLabel.text = @"GPS 定位";
    GPSLabel.frame = CGRectMake(0, screenHeightCity * GPS_LABEL_Y_OFFSET + offsetExtra, screenWidthCity, screenHeightCity * GPS_LABEL_HEIGHT_PER);
    GPSLabel.textColor = [UIColor blackColor];
    [self.view addSubview:GPSLabel];
    //添加表格视图 tableViewCell
    float y_offset_per = TABLEVIEW_Y_OFFSET_PER;
    tableViewCity.frame = CGRectMake(0, screenHeightCity *y_offset_per  + offsetExtra, screenWidthCity, screenHeightCity * (1 - TABLEVIEW_Y_OFFSET_PER) - offsetExtra);
    
    [self.view addSubview:tableViewCity];
}

-(void)internalBtnClicked:(UIButton *)sender
{
    [viewYellowLine removeFromSuperview];
    viewYellowLine.frame = CGRectMake(screenWidthCity/8, screenHeightCity * VIEW_ORANGE_LINE_Y_OFFSET  + offsetExtra, screenWidthCity/4, screenHeightCity * VIEW_ORANGE_LINE_HEIGHT_PER);
    [internalBtn setTitleColor:orangeColor forState:UIControlStateNormal];
    [internationalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:viewYellowLine];
}
-(void)internationalBtnClicked:(UIButton *)sender
{
    [viewYellowLine removeFromSuperview];
    viewYellowLine.frame = CGRectMake(screenWidthCity * 5/8, screenHeightCity * VIEW_ORANGE_LINE_Y_OFFSET  + offsetExtra, screenWidthCity/4, screenHeightCity * VIEW_ORANGE_LINE_HEIGHT_PER);
    [internationalBtn setTitleColor:orangeColor forState:UIControlStateNormal];
    [internalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:viewYellowLine];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)modifyNavButton
{
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked:)];
    rightBarItem.tintColor = [UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

-(void)cancelButtonClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenWidthPCH, 10.0)];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    customView.backgroundColor = lightGrayColorPCH;
    headerLabel.font = FontSize12;
    headerLabel.frame =  CGRectMake(15.0, 0.0, screenWidthPCH, 10.0);
    headerLabel.text = [_sectionHeadsKeys objectAtIndex: section];
    [customView addSubview:headerLabel];
    return customView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"CellId" ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier :cellId];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (cell == nil ) {
        cell = [[ UITableViewCell alloc ] initWithStyle : UITableViewCellStyleDefault reuseIdentifier :cellId];
    }
    //sortedArrForArrays 存放 cell 值的动态数组 , 首先将数组中得值赋给一个静态数组
    if ([_sortedArrForArrays count] > indexPath.section )
    {
        NSArray *arr = [_sortedArrForArrays objectAtIndex:indexPath.section];
        if ([arr count] > indexPath.row)
        {
            // 之后 , 将数组的元素取出 , 赋值给数据模型
            ChineseString *str = ( ChineseString *) [arr objectAtIndex:indexPath.row ];
            // 给 cell 赋给相应地值 , 从数据模型处获得
            cell.textLabel.text = str.string;
            cell.textLabel.font = FontSize14;
        }
        else {
            NSLog ( @"arr out of range" );
        }
    }
    else
    {
        NSLog ( @"sortedArrForArrays out of range" );
    }
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sortedArrForArrays count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [[_sortedArrForArrays objectAtIndex :section] count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModifyPersonalPageVC *mpVc = [[ModifyPersonalPageVC alloc] init];
    self.delegate = mpVc;
    ChineseString *cityName = (ChineseString *)[[_sortedArrForArrays objectAtIndex: indexPath.section] objectAtIndex:indexPath.row];
    [self.delegate passStrValue:cityName.string];
    [self.navigationController popViewControllerAnimated:YES];
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
