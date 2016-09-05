//
//  ChatView.h
//  FleaMarket
//
//  Created by Hou on 5/23/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobIMSDK/BmobIMSDK.h>
#import "Masonry.h"
#import <BmobSDK/Bmob.h>
#import "AppManager.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface ChatView : UIView

@property (strong, nonatomic) UIButton *avatarButton;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIImageView *avatarBackgroundImageView;
@property (strong, nonatomic) UIView *chatContentView;
@property (nonatomic, strong) UIImageView *chatBackgroundImageView;

@property (nonatomic, strong) BmobIMMessage *msg;

-(void)setMessage:(BmobIMMessage *)msg user:(BmobIMUserInfo *)userInfo;
-(void)layoutViewsSelf;
-(void)layoutViewsOther;

@end
