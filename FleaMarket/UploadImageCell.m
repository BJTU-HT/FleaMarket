//
//  UploadImageCell.m
//  FleaMarket
//
//  Created by tom555cat on 16/6/21.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "UploadImageCell.h"

@interface UploadImageCell ()



@end

@implementation UploadImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat imageW = self.frame.size.width * 5.0f / 6.0f;
        CGFloat imageH = imageW;
        CGFloat imageX = self.frame.size.width / 6.0f;
        CGFloat imageY = imageX;
        self.uploadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        [self addSubview:self.uploadImageView];
        
        self.circleProgress = [WLCircleProgressView viewWithFrame:self.uploadImageView.frame
                                                      circlesSize:CGRectMake(20, 5, 20, 5)];
        self.circleProgress.layer.cornerRadius = 0;
        self.circleProgress.progressValue = 0;
        [self addSubview:self.circleProgress];
        
        CGFloat btnX = 0;
        CGFloat btnY = 0;
        CGFloat btnW = self.frame.size.width / 3.0f;
        CGFloat btnH = btnW;
        self.dropImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        [self.dropImageBtn setBackgroundImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
        [self.dropImageBtn addTarget:self action:@selector(dropCurrentImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.dropImageBtn];
    }
    
    return self;
}

- (void)setContentImg:(UIImage *)contentImg
{
    self.uploadImageView.image = contentImg;
}

- (void)dropCurrentImage
{
    self.dropCurrentChooseImg();
}


@end
