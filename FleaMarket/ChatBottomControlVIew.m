//
//  ChatBottomControlVIew.m
//  FleaMarket
//
//  Created by Hou on 5/18/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "ChatBottomControlVIew.h"

@implementation ChatBottomControlVIew

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.picButton = [[PicAndTextBtn alloc] initWithFrame:frame];
        [self addSubview:_picButton];
        
        self.caremaButton = [[PicAndTextBtn alloc] initWithFrame:frame];
        [self addSubview:_caremaButton];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //float viewHeight = self.frame.size.height;
    float viewWidth = self.frame.size.width;
    
    float gap_width_per = 0.05;
    float btnWidth = (viewWidth - gap_width_per * viewWidth * 5)/4;
    float btnHeight = btnWidth * 5/4;
    float btn_y_offset = gap_width_per * viewWidth;
    float btn_x_offset = gap_width_per * viewWidth;
    
    self.picButton.frame = CGRectMake(btn_x_offset, btn_y_offset, btnWidth, btnHeight);
    self.picButton.imageView.image = [UIImage imageNamed:@"sharemore_pic@2x.png"];
    self.picButton.label.text = @"Photos";
    
    float camera_x_offset = btn_x_offset * 2 + btnWidth;
    float camera_y_offset = btn_y_offset;
    
    self.caremaButton.frame = CGRectMake(camera_x_offset, camera_y_offset, btnWidth, btnHeight);
    self.caremaButton.imageView.image = [UIImage imageNamed:@"sharemore_video@2x.png"];
    self.caremaButton.label.text = @"Camera";
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
