//
//  setUpViewController.m
//  TestDemo1
//
//  Created by Hou on 4/11/16.
//  Copyright © 2016 Hou. All rights reserved.
//

#import "setUpViewController.h"
#import "myVC.h"
#import "SDImageCache.h"
#import "presentLayerPublicMethod.h"
#import <BmobSDK/BmobUser.h>

@interface setUpViewController ()

@end

@implementation setUpViewController
NSMutableArray *mutableArraySetUp;
NSString *userName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"更多";
    NSUserDefaults *userDefaultSetUp = [NSUserDefaults standardUserDefaults];
    userName = [userDefaultSetUp objectForKey:@"userName"];
    CGRect frame = CGRectMake(0, 0, screenWidthPCH, screenHeightPCH);
    tableViewSetUp = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableViewSetUp.delegate = self;
    tableViewSetUp.dataSource = self;
    [self initWithArray];
    [self.view addSubview: tableViewSetUp];
    [self drawNav];
}

-(void)drawNav{
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_back@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClicked:)];
    self.navigationItem.leftBarButtonItem = leftBar;
}
-(void)initWithArray
{
    mutableArraySetUp = [[NSMutableArray alloc] init];
    NSArray *arraySection0 = [NSArray arrayWithObjects:@"账户绑定与设置",@"通知设置", @"清除缓存", nil];
    NSArray *arraySection1 = [NSArray arrayWithObjects:@"常见问题与反馈", @"推荐给好友", @"支持我们，打分评价", @"关于书香人家", nil];
    NSArray *arraySection2 = [NSArray arrayWithObjects:@"退出当前账号", nil];
    [mutableArraySetUp addObject:arraySection0];
    [mutableArraySetUp addObject:arraySection1];
    [mutableArraySetUp addObject:arraySection2];
}

//退出登录，
-(void)logOutCellClicked
{
    UIAlertController *alertConLogOut = [UIAlertController alertControllerWithTitle:nil message:@"确认退出登录吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertConfirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *defaultLogOut = [NSUserDefaults standardUserDefaults];
        [defaultLogOut setObject:nil forKey:@"userName"];
        [defaultLogOut synchronize];
        [BmobUser logout];
        myVC *myView = [[myVC alloc] init];
        [self.navigationController pushViewController:myView animated:NO];
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertConLogOut addAction:alertConfirm];
    [alertConLogOut addAction:alertCancel];
    [self.view.window.rootViewController presentViewController:alertConLogOut animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 获取缓存大小，清理缓存-------------
-(NSString *)getImageCacheAndDisk{
    float tmpSize = [[SDImageCache sharedImageCache] getSize];
    NSString *tmpSizeStr = [NSString stringWithFormat:@"%.2fMB", tmpSize/1024.0/1024.0];
    return tmpSizeStr;
}

-(void)cleanCacheAndDisk{
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
}
#pragma 获取缓存大小，清理缓存-end---------
#pragma 弹出清理内存提示框并执行操作---------
-(void)popAlertViewForClearCache{
    UIAlertController *alertConLogOut = [UIAlertController alertControllerWithTitle:@"清理缓存" message:@"缓存可以让浏览更流畅哦，确定要清理吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertConfirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cleanCacheAndDisk];
        [tableViewSetUp reloadData];
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertConLogOut addAction:alertConfirm];
    [alertConLogOut addAction:alertCancel];
    [self.view.window.rootViewController presentViewController:alertConLogOut animated:NO completion:nil];
}
#pragma 弹出清理内存提示框并执行操作-end------

#pragma 实现tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(userName == nil){
        return 3;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 0;
    }else if(section == 1){
        return 3;
    }else if( section == 2){
        return 4;
    }
    return 1; //section2
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey1";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        if(indexPath.section == 3){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }else{
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        //NSLog(@"创建cell中......");
    }
    NSArray *array = [mutableArraySetUp objectAtIndex:indexPath.section -1];
    cell.textLabel.font = FontSize16;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    if(indexPath.section == 1 && indexPath.row == 2)
    {
        cell.detailTextLabel.text = [self getImageCacheAndDisk];
    }
    if(indexPath.section == 3){
        cell.textLabel.textColor = orangColorPCH;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidthPCH, screenHeightPCH * 0.04)];
    v.backgroundColor = ghostWhitePCH;
    return v;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 3){
        return screenHeightPCH * 0.002;
    }
    return screenHeightPCH * 0.04;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section){
        case 1:
            if(indexPath.row == 1){
            }else if(indexPath.row == 2){
                [self popAlertViewForClearCache];
            }
            break;
        case 2:
            if(indexPath.row == 0){
            }
            break;
        case 3:
            if(indexPath.row == 0){
                [self logOutCellClicked];
            }
            break;
        }
}
#pragma 实现tableView代理方法 end

#pragma 实现导航栏左侧按钮返回功能----------------------------
-(void)leftItemClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma 实现导航栏左侧按钮返回功能 end-------------------------
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
