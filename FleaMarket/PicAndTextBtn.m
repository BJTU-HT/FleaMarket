//
//  PicAndTextBtn.m
//  FleaMarket
//
//  Created by Hou on 5/18/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "PicAndTextBtn.h"

@implementation PicAndTextBtn
@synthesize imageView;
@synthesize label;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        
        self.label = [[UILabel alloc] init];
        [self addSubview: self.label];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    float buttonWidth = self.frame.size.width;
    float buttonHeight = self.frame.size.height;
    
    //图片
    float image_x_offset = 0;
    float image_y_offset = 0;
    float imageWidth = buttonWidth;
    float imageHeight = buttonHeight * 0.8;
    
    self.imageView.frame = CGRectMake(image_x_offset, image_y_offset, imageWidth, imageHeight);
    
    //文字
    float label_x_offset = 0;
    float label_y_offset = imageHeight;
    float labelWidth = buttonWidth;
    float labelHeight = buttonHeight * 0.2;
    
    self.label.frame = CGRectMake(label_x_offset, label_y_offset, labelWidth, labelHeight);
    self.label.font = FontSize12;
    self.label.textAlignment = NSTextAlignmentCenter;
}

//-(void)setImageView:(UIImage *)image{
//    self.imageView.image = image;
//}
//
//-(void)setLabel:(NSString *)str{
//    self.label.text = str;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
