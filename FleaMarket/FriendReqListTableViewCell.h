//
//  FriendReqListTableViewCell.h
//  FleaMarket
//
//  Created by Hou on 5/16/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobIMSDK/BmobIMUserInfo.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SysMessage.h"
#import "SystemContact.h"

@interface FriendReqListTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *imageViewHead;
@property (strong, nonatomic) UILabel *nickNameLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIButton *agreeBtn;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setStatus:(SysMessage *)userInfo;

@end
