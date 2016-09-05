//
//  ImagePickerCollectionViewCell.m
//  test123
//
//  Created by tom555cat on 16/5/23.
//  Copyright © 2016年 Hello World Corporation. All rights reserved.
//

#import "ImagePickerCollectionViewCell.h"

@implementation ImagePickerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // 主显示界面
        self.mainImageView = [[UIImageView alloc] initWithFrame:frame];
        self.mainImageView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.mainImageView];
        
        // 是否选中
        CGFloat chooseX = frame.size.width * 0.8f;
        CGFloat chooseY = 0;
        CGFloat chooseWH = frame.size.width * 0.2f;
        self.isChoosenImageView = [[UIImageView alloc] init];
        self.isChoosenImageView.frame = CGRectMake(chooseX, chooseY, chooseWH, chooseWH);
        self.isChoosenImageView.hidden= YES;   // 默认是未选中的
        [self addSubview:self.isChoosenImageView];
    }
    
    return self;
}

- (void)setContentImg:(UIImage *)contentImg {
    if (contentImg) {
        _contentImg = contentImg;
        self.mainImageView.image = _contentImg;
    }
}

- (void)setIsChoosen:(BOOL)isChoosen {
    _isChoosen = isChoosen;
    [UIView animateWithDuration:0.2 animations:^{
        if (isChoosen) {
            self.isChoosenImageView.image = [UIImage imageNamed:@"isChoosenY.png"];
            
        }else {
            self.isChoosenImageView.image = nil;
        }
        self.isChoosenImageView.transform = CGAffineTransformMakeScale (1.1,1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.isChoosenImageView.transform = CGAffineTransformMakeScale (1.0,1.0);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}
- (void)setIsChoosenImgHidden:(BOOL)isChoosenImgHidden {
    _isChoosenImgHidden = isChoosenImgHidden;
    self.isChoosenImageView.hidden = isChoosenImgHidden;
}

@end
