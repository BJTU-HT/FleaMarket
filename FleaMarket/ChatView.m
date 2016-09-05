//
//  ChatView.m
//  FleaMarket
//
//  Created by Hou on 5/23/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "ChatView.h"

@implementation ChatView

-(UIButton *)avatarButton{
    if(!_avatarButton){
        _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_avatarButton];
        [_avatarButton.layer setMasksToBounds: YES];
        [_avatarButton.layer setCornerRadius:20];
    }
    return _avatarButton;
}

-(UIImageView *)avatarBackgroundImageView{
    if(!_avatarBackgroundImageView){
        _avatarBackgroundImageView = [[UIImageView alloc] init];
        [self addSubview: _avatarBackgroundImageView];
    }
    return _avatarBackgroundImageView;
}

-(UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = FontSize12;
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.layer.cornerRadius = 3;
        _timeLabel.backgroundColor = [UIColor colorWithRed:227/255.0 green:228/255.0 blue:232/255.0 alpha:1.0];
        [self addSubview:_timeLabel];
        _timeLabel.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
        _timeLabel.textAlignment   = NSTextAlignmentCenter;
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            //make.centerX.equalTo(@160);
            make.width.equalTo(@140);
            make.top.equalTo(self.mas_top).with.offset(8);
            make.height.equalTo(@19);
        }];
    }
    return _timeLabel;
}

-(UIImageView *)chatBackgroundImageView{
    if(!_chatBackgroundImageView){
        _chatBackgroundImageView = [[UIImageView alloc] init];
        [self.chatContentView addSubview:_chatBackgroundImageView];
    }
    return _chatBackgroundImageView;
}

-(UIView *)chatContentView{
    if(!_chatContentView){
        _chatContentView = [[UIView alloc] init];
        [self addSubview: _chatContentView];
    }
    return _chatContentView;
}

-(void)setMessage:(BmobIMMessage *)msg user:(BmobIMUserInfo *)userInfo {
    self.msg = msg;
    
    self.avatarBackgroundImageView.image = [UIImage imageNamed:@"icon_default_face@2x.png"];
    self.timeLabel.text = [[AppManager defaultManager].dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.msg.updatedTime / 1000.0f] ];
    
    BmobUser *loginUser = [BmobUser getCurrentUser];
    if ([_msg.fromId isEqualToString:loginUser.objectId]) {
        [self layoutViewsSelf];
        [self.avatarButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[loginUser objectForKey:@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_default_face@2x.png"]];
    }else{
        [self layoutViewsOther];
        [self.avatarButton sd_setBackgroundImageWithURL:[NSURL URLWithString:userInfo.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_default_face@2x.png"]];
    }
}

-(void)setMsg:(BmobIMMessage *)msg{
    _msg = msg;
}


#pragma mark - self layout
-(void)layoutViewsSelf{
    [self.avatarBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@44);
        make.width.equalTo(@44);
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(10);
    }];
    
    [self.avatarButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.avatarBackgroundImageView);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    self.chatBackgroundImageView.image = [UIImage imageNamed:@"smile.jpg"];
    
}


#pragma mark - other layout


-(void)layoutViewsOther{
    [self.avatarBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.height.equalTo(@44);
        make.width.equalTo(@44);
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(10);
    }];
    
    [self.avatarButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.avatarBackgroundImageView);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    
    self.chatBackgroundImageView.image = [UIImage imageNamed:@"bg_chat_left_nor"] ;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
