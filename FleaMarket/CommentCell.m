//
//  CommentCell.m
//  FleaMarket
//
//  Created by tom555cat on 16/9/15.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"

@interface CommentCell ()

// 头像
@property (nonatomic, weak) UIImageView *iconImageView;
// 名字
@property (nonatomic, weak) UILabel *nameLabel;
// 发布时间
@property (nonatomic, weak) UILabel *publishTimeLabel;
// 留言
@property (nonatomic, weak) UILabel *messageLabel;

@end

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    // 头像
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    // 名字
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = FontSize14;   // 调整
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    // 发布时间
    UILabel *publishTimeLabel = [[UILabel alloc] init];
    publishTimeLabel.font = FontSize12;
    [self.contentView addSubview:publishTimeLabel];
    self.publishTimeLabel = publishTimeLabel;
    
    // 评论
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.font = FontSize12;
    messageLabel.numberOfLines = 0;
    messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    messageLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:messageLabel];
    self.messageLabel = messageLabel;

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
