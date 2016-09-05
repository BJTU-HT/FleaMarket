//
//  TextChatTableViewCell.m
//  FleaMarket
//
//  Created by Hou on 5/23/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "TextChatTableViewCell.h"
#import "masonry.h"
#import "AppManager.h"

@implementation TextChatTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createView];
        
        //[self settingViewAutoLayout];
    }
    
    return self;
}


-(void)createView{
    UILabel *timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview: timeLabel];
    self.timeLabel = timeLabel;

    UIButton *avatarBtn = [[UIButton alloc] init];
    [self.contentView addSubview:avatarBtn];
    self.headImageBtn = avatarBtn;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview: contentLabel];
    self.contentLabel = contentLabel;
}

-(void)settingViewAutoLayout{
    int margin = 4;
    int padding = 10;
    int timeLabelLeftOffset = 110;
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(padding);
        //make.height.equalTo(@19);
        //make.width.equalTo(@140);
        make.left.mas_equalTo(self.contentView.mas_left).offset(timeLabelLeftOffset);
    }];
    
    [self.headImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(margin);
        make.left.equalTo(self.contentView).offset(padding);
        make.height.equalTo(@44);
        make.width.equalTo(@44);
    }];

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.headImageBtn);
        make.left.mas_equalTo(self.headImageBtn.mas_right).offset(padding);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-80);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-margin);
    }];
}

-(void)settingViewAutoLayoutSelf{
    int margin = 4;
    int padding = 10;
    int timeLabelLeftOffset = screenWidthPCH/2 - 70;
    int contentLabelWidth = screenWidthPCH - 80 - 2 * margin - 44;
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(padding);
        make.height.equalTo(@19);
        make.width.equalTo(@140);
        make.left.mas_equalTo(self.contentView.mas_left).offset(timeLabelLeftOffset);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(margin);
        make.left.mas_equalTo(self.contentView.mas_left).offset(80);
        make.width.mas_equalTo(contentLabelWidth);
        make.bottom.mas_equalTo(self.contentView).offset(-margin);
    }];
    
    [self.headImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(margin);
        make.left.mas_equalTo(self.contentLabel.mas_right).offset(margin);
        make.height.equalTo(@44);
        make.width.equalTo(@44);
    }];
}

-(void)setMsg:(BmobIMMessage *)msg userInfo:(BmobIMUserInfo *)userInfo{
    self.msg = msg;
    self.timeLabel.text = [[AppManager defaultManager].dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.msg.updatedTime / 1000.0f] ];
    
    BmobUser *loginUser = [BmobUser getCurrentUser];
    if ([_msg.fromId isEqualToString:loginUser.objectId]) {
        [self settingViewAutoLayoutSelf];
        [self.headImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[loginUser objectForKey:@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_default_face@2x.png"]];
        self.contentLabel.text = _msg.content;
        NSLog(@"1");
    }else{
        [self settingViewAutoLayout];
        [self.headImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:userInfo.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_default_face@2x.png"]];
        self.contentLabel.text = _msg.content;
        NSLog(@"2");
    }
}

//-(void)setMsg{
//    self.titleLabel.text = @"hellogirl";
//    self.contentLabel.text = @"make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(margin)make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(margin)make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(margin)make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(margin)make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(margin)";
//    self.contentImageView.image = [UIImage imageNamed:@"scene3.jpg"];
//    self.userLabel.text = @"hello";
//    self.timeLabel.text = @"2016-06-12";
//}
//-(void)createView {
//    
//    UILabel *titleLabel = [[UILabel alloc] init];
//    [self.contentView addSubview:titleLabel];
//    
//    self.titleLabel = titleLabel;
//    
//    UILabel *contentLabel = [[UILabel alloc] init];
//    contentLabel.numberOfLines = 0;
//    [self.contentView addSubview:contentLabel];
//    self.contentLabel = contentLabel;
//    
//    UIImageView *contentImageView = [[UIImageView alloc] init];
//    contentImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.contentView addSubview:contentImageView];
//    self.contentImageView = contentImageView;
//    
//    UILabel *userLabel = [[UILabel alloc] init];
//    [self.contentView addSubview:userLabel];
//    self.userLabel = userLabel;
//    
//    UILabel *timeLabel = [[UILabel alloc] init];
//    [self.contentView addSubview:timeLabel];
//    self.timeLabel = timeLabel;
//}
//

#pragma mark - 在此方法内使用 Masonry 设置控件的约束,设置约束不需要在layoutSubviews中设置，只需要在初始化的时候设置
//- (void) settingViewAutoLayout {
//    
//    int magin = 4;
//    int padding = 10;
//    int timeLength = 375/2 - 70;
//    
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//    make.top.and.left.mas_equalTo(self.contentView).offset(padding);    // 设置titleLabel上边跟左边与父控件的偏移量
//        
//    make.right.mas_equalTo(self.contentView.mas_right).offset(-padding); // 设置titleLabel右边与父控件的偏移量
//    }];
//
//    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.equalTo(self.titleLabel);                       // 设置contentLabel左边和右边对于titleLabel左右对齐
//        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(magin);     // 设置contentLabel的上边对于titleLabel的下边的偏移量
//    }];
//    
//    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLabel.mas_left);                        // 设置contentImageView的左边对于titleLabel的左边对齐
//        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(magin);   // 设置contentImageView的上边对于contentLabel的下面的偏移量
//    }];
//    
//    [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLabel.mas_left);                        // 设置userLabel的左边对于titleLabel的左边对齐
//        make.top.mas_equalTo(self.contentImageView.mas_bottom).offset(magin); // 设置userLabel的上边对于contentImageView的下边的偏移量
//        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-magin); // 设置userLabel的下边对于父控件的下面的偏移量
//    }];
//    
//    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.and.top.equalTo(self.userLabel);                        // 设置timeLabel的上边与下边对于userLabel对齐
//        make.right.equalTo(self.titleLabel.mas_right);                      // 设置timeLabel的右边对于titleLabel的右边对齐
//    }];
//    
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(void)setMsg:(BmobIMMessage *)msg userInfo:(BmobIMUserInfo *)userInfo {
//    self.chatView = [[TextChatView alloc] init];
//    [self.chatView setMessage:msg user: userInfo];
//    [self.contentView addSubview:_chatView];
//}
@end
