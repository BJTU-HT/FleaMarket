//
//  weChatView.m
//  FleaMarket
//
//  Created by Hou on 6/14/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "weChatView.h"


@implementation weChatView
float height;

-(UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        [self addSubview: _timeLabel];
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.layer.cornerRadius = 3.0;
        _timeLabel.textColor = [UIColor whiteColor];
    }
    return _timeLabel;
}

-(UILabel*)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        [self addSubview:_contentLabel];
        _contentLabel.layer.masksToBounds = YES;
        _contentLabel.layer.cornerRadius = 3.0;
        self.contentLabel.font = FontSize16;
        //self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.numberOfLines = 0.0;
    }
    return _contentLabel;
}

-(UIButton *)imageBtn{
    if(!_imageBtn){
        _imageBtn = [[UIButton alloc] init];
        [self addSubview:_imageBtn];
    }
    return _imageBtn;
}

-(CGFloat)configMsg:(BmobIMMessage *)msg userInfo: (BmobIMUserInfo *)userInfo{
    CGFloat cellHeight = 0;
    self.msg = msg;
    self.timeLabel.text = [[AppManager defaultManager].dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.msg.updatedTime / 1000.0f] ];
    
    BmobUser *loginUser = [BmobUser getCurrentUser];
    if ([_msg.fromId isEqualToString:loginUser.objectId]) {
        cellHeight = [self layoutViewSelf:_msg.content userInfo: nil];
    }else{
        cellHeight = [self layoutViewOther:_msg.content userInfo: userInfo];
    }
    return cellHeight;
}

-(float)layoutViewSelf:(NSString *)contentText userInfo:(BmobIMUserInfo *)userInfo{
    
    height = 0;
    float margin = 0.02 * screenWidthPCH;
    float timeLabelWidth = 140;
    float timeLabelHeight = 19;
    float timeLabel_X_Offset = screenWidthPCH/2 - timeLabelWidth/2;
    float timeLabel_Y_Offset = margin;
    
    CGRect timeLabelFrame = CGRectMake(timeLabel_X_Offset, timeLabel_Y_Offset, timeLabelWidth, timeLabelHeight);
    self.timeLabel.frame = timeLabelFrame;
    _timeLabel.backgroundColor = [UIColor colorWithRed:227/255.0 green:228/255.0 blue:232/255.0 alpha:1.0];
    [self addSubview:_timeLabel];
    _timeLabel.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
    self.timeLabel.text = [[AppManager defaultManager].dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.msg.updatedTime / 1000.0f] ];
    float imageBtnWidth = 44;
    float imageBtnHeight = imageBtnWidth;
    float imageBtn_X_Offset = screenWidthPCH - imageBtnWidth - margin;
    float imageBtn_Y_Offset = timeLabel_Y_Offset + margin +timeLabelHeight;
    self.imageBtn.frame = CGRectMake(imageBtn_X_Offset, imageBtn_Y_Offset, imageBtnWidth, imageBtnHeight);
    BmobUser *loginUser = [BmobUser getCurrentUser];
    [self.imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[loginUser objectForKey:@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"me.png"]];
    
    float contentLabelWidth = screenWidthPCH - 2 * imageBtnWidth - 3 *margin;
    float contentLabel_Y_offset = imageBtn_Y_Offset;
    self.contentLabel.text = contentText;
    CGSize titleSize = [self.contentLabel.text boundingRectWithSize:CGSizeMake(contentLabelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    float contentLabel_X_offset = imageBtn_X_Offset - margin - titleSize.width - 10;
    self.contentLabel.frame = CGRectMake(contentLabel_X_offset, contentLabel_Y_offset, titleSize.width + 10, titleSize.height);
    _contentLabel.backgroundColor = [UIColor colorWithRed:0 green:255.0/255.0 blue:0 alpha:1.0];
    height = contentLabel_Y_offset + titleSize.height + margin;
    
    return height;
}

-(float)layoutViewOther: (NSString *)contentText userInfo:(BmobIMUserInfo *)userInfo{
    
    height = 0;
    float margin = 0.02 * screenWidthPCH;
    float timeLabelWidth = 140;
    float timeLabelHeight = 19;
    float timeLabel_X_Offset = screenWidthPCH/2 - timeLabelWidth/2;
    float timeLabel_Y_Offset = margin;
    
    CGRect timeLabelFrame = CGRectMake(timeLabel_X_Offset, timeLabel_Y_Offset, timeLabelWidth, timeLabelHeight);
    self.timeLabel.frame = timeLabelFrame;
    _timeLabel.backgroundColor = [UIColor colorWithRed:227/255.0 green:228/255.0 blue:232/255.0 alpha:1.0];
    [self addSubview:_timeLabel];
    _timeLabel.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
    self.timeLabel.text = [[AppManager defaultManager].dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.msg.updatedTime / 1000.0f] ];
    
    float imageBtnWidth = 44;
    float imageBtnHeight = imageBtnWidth;
    float imageBtn_X_Offset = margin;
    float imageBtn_Y_Offset = timeLabel_Y_Offset + margin +timeLabelHeight;
    self.imageBtn.frame = CGRectMake(imageBtn_X_Offset, imageBtn_Y_Offset, imageBtnWidth, imageBtnHeight);
    [self.imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString: userInfo.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"first.png"]];
    
    float contentLabelWidth = screenWidthPCH - 2 * imageBtnWidth - 3 *margin;
    float contentLabel_X_offset = imageBtnWidth + 2 * margin;
    float contentLabel_Y_offset = imageBtn_Y_Offset;
    self.contentLabel.text = contentText;
    CGSize titleSize = [contentText boundingRectWithSize:CGSizeMake(contentLabelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    
    self.contentLabel.frame = CGRectMake(contentLabel_X_offset, contentLabel_Y_offset, titleSize.width, titleSize.height);
    self.contentLabel.backgroundColor = [UIColor whiteColor];
    height = contentLabel_Y_offset + titleSize.height + margin;
    return height;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
