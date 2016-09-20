//
//  CategoryChooseView.m
//  FleaMarket
//
//  Created by tom555cat on 16/9/19.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "CategoryChooseView.h"

@implementation CategoryChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.categoryLabel.font = FontSize14;
        self.categoryLabel.textAlignment = NSTextAlignmentRight;
        self.categoryLabel.text = @"选择分类:";
        [self addSubview:self.categoryLabel];
        
        self.categoryBtn = [[UILabel alloc] initWithFrame:CGRectZero];
        self.categoryBtn.font = FontSize14;
        self.categoryBtn.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.categoryBtn];
        
        self.category = @"分类";
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.categoryLabel.frame = CGRectMake(0, 0, self.frame.size.width/4.0, self.frame.size.height);
    self.categoryBtn.frame = CGRectMake(self.frame.size.width/4.0, 0, self.frame.size.width*3.0/4.0, self.frame.size.height);
}

- (void)setCategory:(NSString *)category
{
    self.categoryBtn.text = category;
}

@end
