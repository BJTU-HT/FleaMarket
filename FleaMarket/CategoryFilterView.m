//
//  CategoryFilterView.m
//  FleaMarket
//
//  Created by tom555cat on 16/9/22.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "CategoryFilterView.h"
#import "CategoryGroupModel.h"
#import "CategoryFilterCell.h"
#import "MJExtension.h"

@interface CategoryFilterView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *bigGroupArray;       // 左边分组数据源
@property (nonatomic, strong) NSMutableArray *smallGroupArray;     // 右边分组数据源
@property (nonatomic, assign) NSInteger bigSelectedIndex;
@property (nonatomic, assign) NSInteger smallSelectedIndex;

@end

@implementation CategoryFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bigGroupArray = [[NSMutableArray alloc] init];
        self.smallGroupArray = [[NSMutableArray alloc] init];
        
        [self initViews];
        [self getCateListData];
    }
    
    return self;
}

- (void)initViews
{
    //分组
    self.tableViewOfGroup = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height) style:UITableViewStylePlain];
    self.tableViewOfGroup.tag = 10;
    self.tableViewOfGroup.delegate = self;
    self.tableViewOfGroup.dataSource = self;
    self.tableViewOfGroup.backgroundColor = [UIColor whiteColor];
    self.tableViewOfGroup.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableViewOfGroup];
    
    //详情
    self.tableViewOfDetail = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height) style:UITableViewStylePlain];
    self.tableViewOfDetail.tag = 20;
    self.tableViewOfDetail.dataSource = self;
    self.tableViewOfDetail.delegate = self;
    self.tableViewOfDetail.backgroundColor = lightGrayColorPCH;
    self.tableViewOfDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableViewOfDetail];
    
    self.userInteractionEnabled = YES;
}

- (void)getCateListData
{
    // 解析JSON
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"CategoryJSON" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:strPath];
    NSMutableDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@", dataDic);
    NSMutableArray *dataArray1 = dataDic[@"data"];
    
    for (int i = 0; i < dataArray1.count; i++) {
        CategoryGroupModel *schoolM = [CategoryGroupModel objectWithKeyValues:dataArray1[i]];
        [_bigGroupArray addObject:schoolM];
    }
    
    [self.tableViewOfGroup reloadData];
}

#pragma mark --- UITableViewDelegate ---

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 10) {
        return _bigGroupArray.count;
    }else{
        if (_bigGroupArray.count == 0) {
            return 0;
        }
        CategoryGroupModel *cateM = (CategoryGroupModel *)_bigGroupArray[_bigSelectedIndex];
        if (cateM.list == nil) {
            return 0;
        }else{
            return cateM.list.count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 10) {
        static NSString *cellIndentifier = @"filterCell1";
        CategoryFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[CategoryFilterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier withFrame:CGRectMake(0, 0, screenWidthPCH/2, 42)];
        }
        
        CategoryGroupModel *cateM = _bigGroupArray[indexPath.row];
        [cell setGroupM:cateM];
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = darkGrayColorPCH;
        return cell;
    }else{
        static NSString *cellIndentifier = @"filterCell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
            //下划线
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 41.5, cell.frame.size.width, 0.5)];
            lineView.backgroundColor = lightGrayColorPCH;
            [cell.contentView addSubview:lineView];
        }
        
        CategoryGroupModel *cateM = (CategoryGroupModel *)_bigGroupArray[_bigSelectedIndex];
        cell.textLabel.text = [cateM.list[indexPath.row] objectForKey:@"name"];
        
        //cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[cateM.list[indexPath.row] objectForKey:@"count"]];
        
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        
        
        cell.backgroundColor = lightGrayColorPCH;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 10) {
        _bigSelectedIndex = indexPath.row;
        
        CategoryGroupModel *cateM = (CategoryGroupModel *)_bigGroupArray[_bigSelectedIndex];
        if (cateM.list == nil) {
            [self.tableViewOfDetail reloadData];
            [self.delegate categoryTableView:tableView didSelectRowAtIndexPath:indexPath withId:cateM.id withName:cateM.name];
        }else{
            [self.tableViewOfDetail reloadData];
        }
    }else{
        _smallSelectedIndex = indexPath.row;
        CategoryGroupModel *cateM = (CategoryGroupModel *)_bigGroupArray[_bigSelectedIndex];
        
        NSDictionary *dic = cateM.list[_smallSelectedIndex];
        NSNumber *ID = [dic objectForKey:@"id"];
        NSString *name = [dic objectForKey:@"name"];
        [self.delegate categoryTableView:tableView didSelectRowAtIndexPath:indexPath withId:ID withName:name];
    }
}


@end
