//
//  CollectionTableViewCell.m
//  test123
//
//  Created by tom555cat on 16/5/25.
//  Copyright © 2016年 Hello World Corporation. All rights reserved.
//

#import "CollectionTableViewCell.h"

@interface CollectionTableViewCell ()

@property (nonatomic , strong) UIImageView * albumImageView;
@property (nonatomic , strong) UILabel * titleLabel;
@property (nonatomic , strong) UILabel * numLabel;

@end

@implementation CollectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self makeUI];
    }
    
    return self;
}

- (void)makeUI
{
    self.titleLabel = [[UILabel alloc] initWithFrame:self.frame];
    [self.contentView addSubview:self.titleLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
