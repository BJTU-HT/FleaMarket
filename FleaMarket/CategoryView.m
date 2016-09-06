//
//  CategoryView.m
//  FleaMarket
//
//  Created by Hou on 7/22/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "CategoryView.h"

@implementation CategoryView
float cellHeightBookPub;
NSInteger pubTag;

-(instancetype)initWithFrame:(CGRect)frame tag:(NSInteger)btnTag{
    self = [super initWithFrame:frame];
    if(self){
        _muArrayCategory = [[NSMutableArray alloc] init];
        [self initArray: btnTag];
        cellHeightBookPub = tableViewCellHeight32;
    }
    return self;
}

-(void)initArray:(NSInteger)tag{
    pubTag = tag;
    NSArray *arr;
    //tag 1 2 使用于BookPublishVC.m 原文件中的图书发布相应内容
    if(tag == 1){
        arr = @[@"所有分类",@"计算机科学与技术", @"自然科学", @"外语学习", @"经济管理", @"文学艺术", @"人文社科", @"生活休闲", @"医学", @"考试教育", @"小说", @"其他"];
    }else if(tag == 2){
        arr = @[@"折旧率", @"9成新",@"8成新",@"7成新",@"6成新",@"5成新",];
    }else if(tag == 3){
        //tag 3 bookMainPage.m 源文件中 交易类别按钮弹出数据列表
        arr = @[@"出售", @"求购", @"借阅", @"赠送"];
    }else if(tag == 4){
        arr = @[@"所有分类",@"计算机科学与技术", @"自然科学", @"外语学习", @"经济管理", @"文学艺术", @"人文社科", @"生活休闲", @"医学", @"考试教育", @"小说", @"其他"];
    }
    [_muArrayCategory setArray:arr];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect tableViewFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.tableViewCategory = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    _tableViewCategory.delegate = self;
    _tableViewCategory.dataSource = self;
#pragma 解决cell分割线右错15pt的问题
    if ([_tableViewCategory respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableViewCategory setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableViewCategory respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableViewCategory setLayoutMargins:UIEdgeInsetsZero];
    }
#pragma 解决右错15pt end
    [self addSubview:self.tableViewCategory];

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
    self.cellHeight = [NSString stringWithFormat:@"%f", cellHeightBookPub];
    return cellHeightBookPub;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.cellAmount = [NSString stringWithFormat:@"%lu", (unsigned long)_muArrayCategory.count];
    return _muArrayCategory.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIden = @"cellIden1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    }
    cell.textLabel.text = _muArrayCategory[indexPath.row];
    //加标tag是为了在BookMainPage中调用时保证所有内容居中 201607291144
    if(indexPath.row == 0 && (pubTag == 1 || pubTag == 2)){
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }else{
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font =FontSize12;
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate12 passStrValue:_muArrayCategory[indexPath.row] tag:pubTag];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
