//
//  AddContactsTableViewCell.m
//  FleaMarket
//
//  Created by Hou on 5/16/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "AddContactsTableViewCell.h"

@implementation AddContactsTableViewCell
@synthesize imageViewHead;
@synthesize nickNameLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    imageViewHead = [[UIImageView alloc] init];
    [self.contentView addSubview:imageViewHead];
    
    nickNameLabel = [[UILabel alloc] init];
    [self.contentView addSubview: nickNameLabel];
}

-(void)setStatus:(BmobIMUserInfo *)userInfo{
    float cellHeight = 70.0;
    float image_x_offset = 0.05 * screenWidthPCH;
    float image_y_offset = 0.1 * cellHeight;
    float image_width = 0.8 * cellHeight;
    float image_Height = image_width;
    
    CGRect imageViewHeadFrame =  CGRectMake(image_x_offset, image_y_offset, image_width, image_Height);
    imageViewHead.frame = imageViewHeadFrame;
    [imageViewHead sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:@"icon_default_face@2x"]];
    
    float label_x_offset = 2 * image_x_offset + image_width;
    float label_y_offset = image_y_offset;
    float label_width = 0.6 *screenWidthPCH;
    float label_height = 16.0;//默认采用14号字
    CGRect labelFrame = CGRectMake(label_x_offset, label_y_offset, label_width, label_height);
    nickNameLabel.frame = labelFrame;
    nickNameLabel.text = userInfo.name;
}
@end
