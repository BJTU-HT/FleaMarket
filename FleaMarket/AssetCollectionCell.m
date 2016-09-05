//
//  AssetCollectionCell.m
//  test123
//
//  Created by tom555cat on 16/5/26.
//  Copyright © 2016年 Hello World Corporation. All rights reserved.
//

#import "AssetCollectionCell.h"

@interface AssetCollectionCell ()

@property (nonatomic , strong) UIImageView *albumImageView;
@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic , strong) UILabel *numLabel;

@end

@implementation AssetCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self makeUI];
    }
    
    return self;
}

- (void)makeUI
{
    CGFloat margin = 5.0f;
    CGFloat albumX = margin;
    CGFloat albumY = margin;
    CGFloat albumWH = self.frame.size.height - 2 * margin;
    self.albumImageView = [[UIImageView alloc] init];
    self.albumImageView.frame= CGRectMake(albumX, albumY, albumWH, albumWH);
    [self.contentView addSubview:self.albumImageView];
    
    CGFloat titleX = CGRectGetMaxX(self.albumImageView.frame) + margin;
    CGFloat titleY = margin;
    CGFloat titleW = (self.frame.size.width - albumWH - 4 * margin) / 2.0f;
    CGFloat titleH = self.frame.size.height - 2 * margin;
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    [self.contentView addSubview:self.titleLabel];
    
    CGFloat numX = CGRectGetMaxX(self.titleLabel.frame) + margin;
    CGFloat numY = margin;
    CGFloat numW = (self.frame.size.width - albumWH - 4 * margin) / 2.0f;
    CGFloat numH = self.frame.size.height - 2 * margin;
    self.numLabel = [[UILabel alloc] init];
    self.numLabel.frame = CGRectMake(numX, numY, numW, numH);
    [self.contentView addSubview:self.numLabel];
}

- (void)setAlbumImg:(UIImage *)albumImg
{
    self.albumImageView.image = albumImg;
}

- (void)setAlbumTitle:(NSString *)albumTitle
{
    self.titleLabel.text = albumTitle;
}

- (void)setPhotoNum:(NSInteger)photoNum
{
    self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)_photoNum];
}

@end
