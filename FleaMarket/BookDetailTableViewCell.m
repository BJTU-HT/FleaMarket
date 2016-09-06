//
//  BookDetailTableViewCell.m
//  FleaMarket
//
//  Created by Hou on 8/2/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "BookDetailTableViewCell.h"

@implementation BookDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier index: (NSIndexPath *)indexPath{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}


-(CGFloat)configCellBook:(CGRect)frame index:(NSIndexPath *)indexPath data:(NSMutableDictionary *)mudic{
    if(indexPath.section == 3 && indexPath.row != 0){
        //frame useless
        _lmView = [[leaveMessageView alloc] initWithFrame: frame];
        [self.contentView addSubview:_lmView];
        NSMutableArray *tempArr = [mudic objectForKey:@"contentArr"];
        return [_lmView layoutSubviews:tempArr[indexPath.row - 1]];
    }
    if(!_bookDetail){
        _bookDetail = [[bookDetailView alloc] initWithFrame:frame index:indexPath];
    }
    [self.contentView addSubview:_bookDetail];
    return [_bookDetail layoutSubviews:indexPath data:mudic];
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
