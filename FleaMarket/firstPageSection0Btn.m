//
//  firstPageSection0Btn.m
//  FleaMarket
//
//  Created by Hou on 9/18/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "firstPageSection0Btn.h"

@implementation firstPageSection0Btn

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.labelS0.font = [UIFont systemFontOfSize:12.0];
    self.labelS0.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.imageViewS0];
    [self addSubview:self.labelS0];
    return self;
}

-(void)layoutSubviews{
    float imageView_x = 0;
    float imageView_y = 0;
    float imageView_w = 48.0;
    float imageView_h = 48.0;
    
    self.imageViewS0.frame = CGRectMake(imageView_x, imageView_y, imageView_w, imageView_h);
    
    float labelS0_x = 0;
    float labelS0_y = imageView_h + 12;
    float labelS0_w = 48.0;
    float labelS0_h = 12.0;
    
    self.labelS0.frame = CGRectMake(labelS0_x, labelS0_y, labelS0_w, labelS0_h);
    
}

-(void)setBtn:(UIImage *)imageS0 para: (NSString *)str{
    self.imageViewS0.image = imageS0;
    self.labelS0.text = str;
}

-(UIImageView *)imageViewS0{
    if(!_imageViewS0){
        _imageViewS0 = [[UIImageView alloc] init];
    }
    return _imageViewS0;
}

-(UILabel *)labelS0{
    if(!_labelS0){
        _labelS0 = [[UILabel alloc] init];
    }
    return _labelS0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
