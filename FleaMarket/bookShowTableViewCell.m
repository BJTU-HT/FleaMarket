//
//  bookShowTableViewCell.m
//  FleaMarket
//
//  Created by Hou on 8/1/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "bookShowTableViewCell.h"

@implementation bookShowTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    if(!_bookDisView){
        _bookDisView  = [[bookDisplayCellView alloc] init];
    }
    [self.contentView addSubview:_bookDisView];
}


-(CGFloat)cellConfig:(NSMutableDictionary *)mudic{
    CGFloat height;
    height = [_bookDisView layoutViewSelf:mudic];
    return height;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
