//
//  SortCell.m
//  FleaMarket
//
//  Created by tom555cat on 16/9/22.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "SortCell.h"

@implementation SortCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.sortLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidthPCH, 42)];
        self.sortLabel.font = FontSize12;
        self.sortLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.sortLabel];
    }
    
    return self;
}

@end
