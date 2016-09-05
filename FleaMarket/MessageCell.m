//
//  MessageCell.m
//  FleaMarket
//
//  Created by tom555cat on 16/4/14.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "MessageCell.h"
#import "Help.h"

@interface MessageCell ()

// 头像
@property (nonatomic, weak) UIImageView *iconImageView;
// 名字
@property (nonatomic, weak) UILabel *nameLabel;
// 发布时间
@property (nonatomic, weak) UILabel *publishTimeLabel;
// 留言
@property (nonatomic, weak) UILabel *messageLabel;


@end

@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 头像
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        // 名字
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = HTNameFont;   // 调整
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // 发布时间
        UILabel *publishTimeLabel = [[UILabel alloc] init];
        publishTimeLabel.font = HTNameFont;
        [self.contentView addSubview:publishTimeLabel];
        self.publishTimeLabel = publishTimeLabel;
        
        // 评论
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.font = HTTextFontLess;
        messageLabel.numberOfLines = 0;
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:messageLabel];
        self.messageLabel = messageLabel;
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _iconImageView.frame = _frameModel.iconFrame;
    _nameLabel.frame = _frameModel.nameFrame;
    _publishTimeLabel.frame = _frameModel.publishTimeFrame;
    _messageLabel.frame = _frameModel.messageFrame;
}

- (void)setModel:(SecondhandMessageVO *)model
{
    _model = model;
    
    //_iconImageView.image = [UIImage imageNamed:model.userIconImage];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.userIconImage]];
    _nameLabel.text = model.userName;
    _publishTimeLabel.text = model.publishTime;
    
    if (model.toUserName.length == 0) {
        _messageLabel.text = model.content;
    } else {
        _messageLabel.text = [NSString stringWithFormat:@"@%@:%@", model.toUserName, model.content];
    }
    
}

@end
