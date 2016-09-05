//
//  RecentCommentViewController.m
//  FleaMarket
//
//  Created by tom555cat on 16/8/14.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <BmobIMSDK/BmobIMSDK.h>
#import <BmobSDK/Bmob.h>
#import "RecentCommentViewController.h"

@interface RecentCommentViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation RecentCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRecentComments:) name:kNewMessageFromer object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRecentComments:) name:kNewMessagesNotifacation object:nil];
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRecentComments:(NSNotification *)noti
{
    /*
    BmobIMMessage *message = noti.object;
    
    NSLog(@"%@", message.extra);
    
    if (message.extra[KEY_IS_TRANSIENT] && [message.extra[KEY_IS_TRANSIENT] boolValue]) {
        return;
    }
    if ([message.fromId isEqualToString:self.conversation.conversationId]) {
        
        BmobIMMessage *tmpMessage = nil;
        if ([message.msgType isEqualToString:@"comment"]) {
            tmpMessage = message;
            [self.dataArray addObject:tmpMessage];
        }
    }
     */
}

#pragma mark ----------- tableViewDelegate -----------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recentcommentcell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"recentcommentcell"];
    }
    
    BmobIMMessage *tmpMessage = self.dataArray[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:@"test"];
    cell.textLabel.text = tmpMessage.content;
    cell.detailTextLabel.text = @"111";
    
    return cell;
}

#pragma mark ----------- getter & setter -------------

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    return _dataArray;
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
