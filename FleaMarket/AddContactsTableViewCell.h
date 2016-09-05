//
//  AddContactsTableViewCell.h
//  FleaMarket
//
//  Created by Hou on 5/16/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobIMSDK/BmobIMUserInfo.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface AddContactsTableViewCell : UITableViewCell


@property (strong, nonatomic) UIImageView *imageViewHead;
@property (strong, nonatomic) UILabel *nickNameLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setStatus:(BmobIMUserInfo *)userInfo;

@end
