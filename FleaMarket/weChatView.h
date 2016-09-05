//
//  weChatView.h
//  FleaMarket
//
//  Created by Hou on 6/14/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobIMSDK/BmobIMSDK.h>
#import <BmobSDK/Bmob.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "AppManager.h"

@interface weChatView : UIView

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIButton *imageBtn;
@property (strong, nonatomic) BmobIMMessage *msg;

-(CGFloat)configMsg:(BmobIMMessage *)msg userInfo: (BmobIMUserInfo *)userInfo;
@end
