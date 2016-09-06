//
//  bookUserInfoTableViewCell.m
//  FleaMarket
//
//  Created by Hou on 8/2/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "bookUserInfoTableViewCell.h"

@implementation bookUserInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    if(!_bookUserView){
        CGRect viewFrame = CGRectMake(0, 0, screenWidthPCH, 44);
        _bookUserView  = [[bookUserInfoView alloc] initWithFrame: viewFrame];
    }
    [self.contentView addSubview:_bookUserView];
}

-(void)configBookUserCell:(NSMutableDictionary *)mudic{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_bookUserView.headImageViewBook sd_setImageWithURL:[NSURL URLWithString:[mudic objectForKey:@"userHeadImageURL"]] placeholderImage:[UIImage imageNamed:@"icon_default_face@2x"]];

    });
    _bookUserView.bookUserNameLabel.text = [mudic objectForKey:@"userName"];
    _bookUserView.bookSchoolLabel.text = [mudic objectForKey:@"school"];
    _bookUserView.pubTimeLabel.text = [[mudic objectForKey:@"createdAt"] substringToIndex:16];
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
