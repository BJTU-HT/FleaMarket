//
//  TextChatTableViewCell.h
//  FleaMarket
//
//  Created by Hou on 5/23/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobIMSDK/BmobIMSDK.h>
#import <BmobSDK/Bmob.h>
#import <SDWebImage/UIButton+WebCache.h>

@interface TextChatTableViewCell : UITableViewCell
//@property(nonatomic, strong) TextChatView *chatView;
@property (nonatomic, strong) BmobIMMessage *msg;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *headImageBtn;

//@property (strong, nonatomic) UILabel *titleLabel;
//@property (strong, nonatomic) UILabel *contentLabel;
//@property (strong, nonatomic) UIImageView *contentImageView;
//@property (strong, nonatomic) UILabel *userLabel;
//@property (strong, nonatomic) UILabel *timeLabel;
-(void)setMsg:(BmobIMMessage *)msg userInfo:(BmobIMUserInfo *)userInfo ;
//-(void)setMsg;
@end
