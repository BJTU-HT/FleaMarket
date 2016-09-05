//
//  HomePageVC.m
//  FleaMarket
//
//  Created by Hou on 6/19/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "HomePageVC.h"

@interface HomePageVC ()

@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _homeTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _homeTableView.delegate = self;
    _homeTableView.dataSource = self;
    
    [self.view addSubview:_homeTableView];
    
#pragma 解决cell分割线右错15pt的问题
    if ([_homeTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_homeTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_homeTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_homeTableView setLayoutMargins:UIEdgeInsetsZero];
    }
#pragma 解决右错15pt end
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height = 0;
    switch (indexPath.row) {
        case 0:
            height = screenHeightPCH * 0.20;
            break;
        case 1:
            height = screenHeightPCH * 0.08;
            break;
        case 2:
            height = screenHeightPCH * 0.4;
            break;
        case 3:
            height = screenHeightPCH * 0.8;
            break;
        case 4:
            height = screenHeightPCH * 0.5;
            break;
        default:
            break;
    }
    return height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier= [NSString stringWithFormat:@"cellForRowIdentifier%ld%ld", (long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        //NSLog(@"创建cell中......");
    }

    return cell;
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
