//
//  TextWeChatTableViewCell.m
//  FleaMarket
//
//  Created by Hou on 6/14/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "TextWeChatTableViewCell.h"


@implementation TextWeChatTableViewCell

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    return self;
//}

-(CGFloat)cellConfigMsg:(BmobIMMessage *)msg userInfo: (BmobIMUserInfo *)userInfo{
    CGFloat height;
    weChatView *weChat = [[weChatView alloc] init];
    height = [weChat configMsg:msg userInfo: userInfo];
    [self.contentView addSubview:weChat];
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
