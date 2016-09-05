//
//  RecentTableViewCell.m
//  FleaMarket
//
//  Created by Hou on 5/15/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "RecentTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppManager.h"

@implementation RecentTableViewCell
@synthesize avatarImageView;
@synthesize timeLabel;
@synthesize titleLabel;
@synthesize contentLabel;
@synthesize tipImageView;
@synthesize numberLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

#pragma mark 初始化视图
-(void)initSubView{
    //头像控件
    if(!avatarImageView){
        avatarImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:avatarImageView];
    }
    
    //标题控件（昵称）
    if(!titleLabel){
        titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:titleLabel];
    }
    
    //内容控件，最后一条聊天信息
    if(!contentLabel){
        contentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:contentLabel];
    }
    
    //时间控件，显示信息时间
    if(!timeLabel){
        timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:timeLabel];
    }
    
    //显示未读信息条数 imageView + label
    if(!tipImageView){
        tipImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:tipImageView];
    }
    
    if(!numberLabel){
        numberLabel = [[UILabel alloc] init];
        [self.contentView addSubview:numberLabel];
    }
}

#pragma mark 聊天历史
-(void)setStatus:(BmobIMConversation *)conversation cellHeight:(float)cellHeight{
    float height = cellHeight;
    float margin = 0.12 * height;
    float imageHeight = 0.76 * height;
    float imageWidth = imageHeight;
    float image_x_offset = margin;
    float image_y_offset = margin;
    
    self.avatarImageView.frame = CGRectMake(image_x_offset, image_y_offset, imageWidth, imageHeight);
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:conversation.conversationIcon] placeholderImage:[UIImage imageNamed:@"sharemore_pic@2x.png"]];
    
    float timeLabelWidth = screenWidthPCH * 0.20;
    float timeLabelHeight = 0.3 *height;
    float timeLabel_x_offset = screenWidthPCH - 2 * margin - timeLabelWidth;
    float timeLabel_y_offset = image_y_offset;
    self.timeLabel.frame = CGRectMake(timeLabel_x_offset, timeLabel_y_offset, timeLabelWidth, timeLabelHeight);
    self.timeLabel.text = [[AppManager defaultManager].dateFormatterSimplify stringFromDate:[NSDate dateWithTimeIntervalSince1970:conversation.updatedTime / 1000.0f]];
    self.timeLabel.font = FontSize12;
    
    float titleLabelWidth = screenWidthPCH - 4 * margin - imageWidth - timeLabelWidth;
    float titleLabelHeight = 0.30 * height;
    float titleLabel_x_offset = 2 * margin + imageWidth;
    float titleLabel_y_offset = image_y_offset;
    
    self.titleLabel.frame = CGRectMake(titleLabel_x_offset, titleLabel_y_offset, titleLabelWidth, titleLabelHeight);
    self.titleLabel.text = conversation.conversationTitle;
    self.titleLabel.font = FontSize14;
    
    float contentLabelHeight = titleLabelHeight;
    float contentLabelWidth = titleLabelWidth;
    float contentLabel_x_offset = titleLabel_x_offset;
    float contentLabel_y_offset = height - margin - contentLabelHeight;
    
    self.contentLabel.text = conversation.conversationDetail;
    self.contentLabel.frame = CGRectMake(contentLabel_x_offset, contentLabel_y_offset, contentLabelWidth, contentLabelHeight);
    self.contentLabel.font = FontSize14;
    self.contentLabel.textColor = [UIColor grayColor];
    
    float numberLabelHeight = contentLabelHeight;
    float numberLabelWidth = numberLabelHeight;
    float numberLabel_x_offset = screenWidthPCH - margin - timeLabelWidth/2 - numberLabelWidth/2;
    float numberLabel_y_offset = contentLabel_y_offset;
    
    self.numberLabel.frame =CGRectMake(numberLabel_x_offset, numberLabel_y_offset, numberLabelWidth, numberLabelHeight);
    self.numberLabel.layer.cornerRadius = numberLabelHeight/2;
    self.numberLabel.layer.masksToBounds = YES;
    self.numberLabel.text = [NSString stringWithFormat:@"%d", conversation.unreadCount];
    self.numberLabel.backgroundColor = [UIColor redColor];
    self.numberLabel.font = FontSize14;
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    if(conversation.unreadCount > 0){
        self.numberLabel.hidden = NO;
    }else{
        self.numberLabel.hidden = YES;
    }
}

#pragma mark 聊天历史 end
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end
