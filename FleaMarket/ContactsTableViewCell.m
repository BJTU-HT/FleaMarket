//
//  ContactsTableViewCell.m
//  FleaMarket
//
//  Created by Hou on 5/16/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "ContactsTableViewCell.h"

@implementation ContactsTableViewCell

@synthesize imageViewHead;
@synthesize nickNameLabel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
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

-(void)setStatus:(BmobIMUserInfo *)userInfo flag:(BOOL)value{
    float cellHeight = 70.0;
    float image_x_offset = 0.05 * screenWidthPCH;
    float image_y_offset = 0.1 * cellHeight;
    float image_width = 0.8 * cellHeight;
    float image_Height = image_width;
    
    CGRect imageViewHeadFrame =  CGRectMake(image_x_offset, image_y_offset, image_width, image_Height);
    imageViewHead.frame = imageViewHeadFrame;
    if(value == 0){
        imageViewHead.image = [UIImage imageNamed:@"mail.PNG"];
    }else{
        [imageViewHead sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:@"icon_default_face@2x"]];
    }

    float label_x_offset = 2 * image_x_offset + image_width;
    float label_width = 0.6 *screenWidthPCH;
    float label_height = 16.0;//默认采用14号字
    float label_y_offset = cellHeight/2 - label_height/2;
    CGRect labelFrame = CGRectMake(label_x_offset, label_y_offset, label_width, label_height);
    nickNameLabel.frame = labelFrame;
    if(value == 0){
        nickNameLabel.text = @"新朋友";
    }else{
        nickNameLabel.text = userInfo.name;
    }    
}

-(void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
