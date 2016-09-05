//
//  FriendReqListTableViewCell.m
//  FleaMarket
//
//  Created by Hou on 5/16/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "FriendReqListTableViewCell.h"

@implementation FriendReqListTableViewCell

@synthesize imageViewHead;
@synthesize nickNameLabel;
@synthesize contentLabel;
@synthesize agreeBtn;

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
    
    contentLabel = [[UILabel alloc] init];
    [self.contentView addSubview:contentLabel];
    
    agreeBtn = [[UIButton alloc] init];
    [self.contentView addSubview:agreeBtn];
}

-(void)setStatus:(SysMessage *)userInfo{
    float cellHeight = 70.0;
    float image_x_offset = 0.05 * screenWidthPCH;
    float image_y_offset = 0.1 * cellHeight;
    float image_width = 0.8 * cellHeight;
    float image_Height = image_width;
    
    CGRect imageViewHeadFrame =  CGRectMake(image_x_offset, image_y_offset, image_width, image_Height);
    imageViewHead.frame = imageViewHeadFrame;
    [imageViewHead sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"icon_default_face@2x"]];
    
    float label_x_offset = 2 * image_x_offset + image_width;
    float label_width = 0.6 *screenWidthPCH;
    float label_height = 16.0;//默认采用14号字
    float label_y_offset = image_y_offset;
    CGRect labelFrame = CGRectMake(label_x_offset, label_y_offset, label_width, label_height);
    nickNameLabel.frame = labelFrame;
    nickNameLabel.text = userInfo.fromUser.username;
    
    float contentLabel_x_offset = label_x_offset;
    float contentLabelHeight = 14.0; //默认采用12号字
    float contentLabelWidth = label_width;
    float contentLabel_y_offset = image_y_offset + image_Height - contentLabelHeight;
    CGRect contentLabelFrame = CGRectMake(contentLabel_x_offset, contentLabel_y_offset, contentLabelWidth, contentLabelHeight);
    contentLabel.frame = contentLabelFrame;
    //
    float agreeBtnHeight = 0.5 * cellHeight;
    float agreeBtnWidth = 0.2 * screenWidthPCH;
    float agreeBtn_x_offset = screenWidthPCH - image_x_offset - agreeBtnWidth;
    float agreeBtn_y_offset = cellHeight/2 - agreeBtnHeight/2;
    CGRect agreeBtnFrame = CGRectMake(agreeBtn_x_offset, agreeBtn_y_offset, agreeBtnWidth, agreeBtnHeight);
    agreeBtn.frame = agreeBtnFrame;

    if (userInfo.type.intValue == SystemMessageContactAdd){
        contentLabel.text = [NSString stringWithFormat:@"%@请求添加您为好友",userInfo.fromUser.username];
        [agreeBtn setTitle:@"同意" forState: UIControlStateNormal];
        [agreeBtn setTintColor:[UIColor whiteColor]];
        [agreeBtn setBackgroundColor:[UIColor greenColor]];
        agreeBtn.userInteractionEnabled = YES;
    }else{
       contentLabel.text = [NSString stringWithFormat:@"%@已添加您为好友",userInfo.fromUser.username];
        [agreeBtn setTitle:@"已同意" forState: UIControlStateNormal];
        [agreeBtn setTintColor:[UIColor grayColor]];
        [agreeBtn setBackgroundColor:[UIColor whiteColor]];
        agreeBtn.userInteractionEnabled = NO;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
