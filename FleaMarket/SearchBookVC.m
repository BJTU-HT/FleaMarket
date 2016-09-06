//
//  SearchBookVC.m
//  FleaMarket
//
//  Created by Hou on 8/12/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "SearchBookVC.h"
#import "findBookInfoBL.h"
#import "BookMainPageVC.h"

@interface SearchBookVC ()

@end

@implementation SearchBookVC
NSString *searchCate;

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addSearchBar];
    _tableViewBookSearch = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableViewBookSearch.delegate = self;
    _tableViewBookSearch.dataSource = self;
    [self.view addSubview:_tableViewBookSearch];
    if(!_userDefaultBS){
        _userDefaultBS = [NSUserDefaults standardUserDefaults];
    }
    if(!_readStorageMuDic){
        _readStorageMuDic = [[NSMutableDictionary alloc] init];
    }
    if(!_writeStorageMuDic){
        _writeStorageMuDic = [[NSMutableDictionary alloc] init];
    }
    if(!_muArrBS){
        _muArrBS = [[NSMutableArray alloc] init];
    }
    if([_userDefaultBS objectForKey:@"writeStorageMuDic"]){
        _readStorageMuDic = [_userDefaultBS objectForKey:@"writeStorageMuDic"];
        _muArrBS = [_readStorageMuDic objectForKey:@"writeStorageMuDic"];
    }
}

//navigationcontroller add searchBar
-(void)addSearchBar{
    _searchBarForBook = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    _searchBarForBook.delegate = self;
    _searchBarForBook.backgroundColor = [UIColor clearColor];
    NSString *str = @"搜索";
    NSString *str1;
    if(searchCate)
        str1 = [str stringByAppendingString:searchCate];
    NSString *str2 = [str1 stringByAppendingString:@"书籍"];
    _searchBarForBook.placeholder = str2;
    NSLog(@"1--%@",_searchBarForBook.text);
    self.navigationItem.titleView = _searchBarForBook;
    _searchBarForBook.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBarForBook.autocapitalizationType = UITextAutocapitalizationTypeNone;
}

//from book main page transfer search category delegate method implement
-(void)passMudicValue:(NSMutableDictionary *)muDictionary{
    searchCate = [muDictionary objectForKey: @"exchangeCategory"];
}


#pragma UISearchBar delegate begin
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if(_searchBarForBook.text){
        NSMutableArray *muArr = [[NSMutableArray alloc] initWithCapacity:15];
        [muArr addObjectsFromArray: _muArrBS];
        for(int i = 0; i < muArr.count; i++){
            if([_searchBarForBook.text isEqualToString:muArr[i]]){
                [muArr removeObject:muArr[i]];
            }
        }
        [muArr insertObject: _searchBarForBook.text atIndex:0];
        
        if(muArr.count == 15)
            [muArr removeLastObject];
        _muArrBS = muArr;
    }
    [_writeStorageMuDic setObject:_muArrBS forKey:@"writeStorageMuDic"];
    [_userDefaultBS setObject:_writeStorageMuDic forKey:@"writeStorageMuDic"];
    _mudicBS = [[NSMutableDictionary alloc] init];
    NSString *exchangeCate = [self exchangeCategoryTransferStr: searchCate];
    [_mudicBS setObject:exchangeCate forKey:@"exchangeCategory"];
    [_mudicBS setObject:_searchBarForBook.text forKey:@"bookName"];
    [_mudicBS setObject:@"1" forKey:@"tag"];

    //创建通知
    //NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo: _mudicBS];
    //通过通知中心发送通知
    //[[NSNotificationCenter defaultCenter] postNotification:notification];
    //_bookMain = [[BookMainPageVC alloc] init];
    //self.delegateBD = _bookMain;
    [self.delegateBD searchPagePassValue:_mudicBS];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma UISearchBar delegate end
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

#pragma tableView delegate method begin
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_muArrBS.count){
      return _muArrBS.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"cellBS";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        //NSLog(@"创建cell中......");
    }
    cell.textLabel.text = _muArrBS[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *searchBookName = _muArrBS[indexPath.row];
    NSMutableDictionary *mudicBSClick = [[NSMutableDictionary alloc] init];
    NSString *exchangeCate = [self exchangeCategoryTransferStr: searchCate];
    [mudicBSClick setObject:exchangeCate forKey:@"exchangeCategory"];
    [mudicBSClick setObject:searchBookName forKey:@"bookName"];
    [mudicBSClick setObject:@"1" forKey:@"tag"];
    [self.delegateBD searchPagePassValue:mudicBSClick];
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma tableView delegate method end
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
