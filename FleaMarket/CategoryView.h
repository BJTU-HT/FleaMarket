//
//  CategoryView.h
//  FleaMarket
//
//  Created by Hou on 7/22/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BookPubDelegate.h"
#import "BookPublishDelegate.h"


@interface CategoryView : UIView <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableViewCategory;
@property(nonatomic, strong) NSMutableArray *muArrayCategory;
@property(nonatomic, strong) UILabel *labelTitle;
@property(nonatomic, strong) UIButton *btnClose;
@property(nonatomic, strong) UIView *viewForCell0;
@property(nonatomic, strong) NSString *cellHeight;
@property(nonatomic, strong) NSString *cellAmount;
//@property(nonatomic, weak) id<BookPubDelegate> delegate12;
@property(nonatomic, weak) id<BookPublishDelegate> delegate12;

-(instancetype)initWithFrame:(CGRect)frame tag:(NSInteger)btnTag;
@end
