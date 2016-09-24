//
//  SortView.m
//  FleaMarket
//
//  Created by tom555cat on 16/9/22.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "SortView.h"
#import "SortCell.h"

@interface SortView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *sortTypeArray;

@end

@implementation SortView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.sortTypeArray = [[NSMutableArray alloc] init];
        
        [self initViews];
        [self getData];
    }
    
    return self;
}

- (void)initViews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 100) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    
    self.userInteractionEnabled = YES;
}

- (void)getData
{
    [self.sortTypeArray addObject:@"按发布时间排序"];
    [self.tableView reloadData];
}

#pragma mark --- UITableViewDelegate ---

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sortTypeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"sortCell";
    SortCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SortCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.sortLabel.text = self.sortTypeArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate sortTableView:tableView didSelectRowAtIndexPath:indexPath withId:[NSNumber numberWithInteger:indexPath.row] withName:self.sortTypeArray[indexPath.row]];
}

@end
