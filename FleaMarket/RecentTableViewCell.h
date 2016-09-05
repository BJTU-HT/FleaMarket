//
//  RecentTableViewCell.h
//  FleaMarket
//
//  Created by Hou on 5/15/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobIMSDK/BmobIMSDK.h>

@interface RecentTableViewCell : UITableViewCell

//用于展示聊天消息记录页面， 包括内容：头像，用户名，最后一条聊天内容，时间，未读消息数量
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong,nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIImageView *tipImageView;
@property (strong, nonatomic) UILabel *numberLabel;

@property (strong, nonatomic) BmobIMConversation *conversation;
-(void)setStatus:(BmobIMConversation *)conversation cellHeight:(float)cellHeight;
@end
