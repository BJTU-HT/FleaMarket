//
//  myConcernedView.m
//  FleaMarket
//
//  Created by Hou on 9/12/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "myConcernedView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation myConcernedView

-(instancetype)initWithFrame:(CGRect)frame para: (NSMutableDictionary *)mudic{
    self = [super initWithFrame: frame];
    if(self){
        self.labelSchoolMC.text = [mudic objectForKey:@"school"];
        self.labelSchoolMC.font = FontSize12;
        self.labelNameMC.text = [mudic objectForKey:@"username"];
        self.labelNameMC.font = FontSize14;
        [self.btnSendMessageMC setTitle:@"发消息" forState: UIControlStateNormal];
        [self.btnSendMessageMC setTitleColor: orangColorPCH forState:UIControlStateNormal];
        self.btnSendMessageMC.layer.cornerRadius = 0.0f;
        self.btnSendMessageMC.layer.borderColor = orangColorPCH.CGColor;
        self.btnSendMessageMC.layer.borderWidth = 1.0f;
        self.btnSendMessageMC.layer.masksToBounds = YES;
        self.btnSendMessageMC.titleLabel.font = FontSize12;
        [self.headImageViewMC sd_setImageWithURL:[NSURL URLWithString:[mudic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"icon_default_face@2x"]];
        
        [self addSubview:self.labelNameMC];
        [self addSubview:self.labelSchoolMC];
        [self addSubview:self.btnSendMessageMC];
        [self addSubview:self.headImageViewMC];
    }
    return self;
}

//默认cell高度为70
-(void)layoutSubviews{
    float margin = 10.0f;
    float marginHorizontal = 10.0f;
    float height = 70.0f;
    float width = screenWidthPCH;
    
    float headImage_x = margin;
    float headImage_y = margin;
    float headImage_w = 50.0f;
    float headImage_h = 50.0f;
    
    self.headImageViewMC.frame = CGRectMake(headImage_x, headImage_y, headImage_w, headImage_h);
    
    float name_x = headImage_x + headImage_w + marginHorizontal;
    float name_y = headImage_y;
    float name_w = width * 0.3;
    float name_h = 20.0f;
    
    self.labelNameMC.frame = CGRectMake(name_x, name_y, name_w, name_h);
    
    float school_w = width * 0.5;
    float school_h = 20.0f;
    float school_x = name_x;
    float school_y = headImage_y + headImage_h - school_h;
    
    self.labelSchoolMC.frame = CGRectMake(school_x, school_y, school_w, school_h);
    
    float btn_w = 70.0f;
    float btn_h = 30.0f;
    float btn_x = width - margin - btn_w;
    float btn_y = height/2 - btn_h/2;
    
    self.btnSendMessageMC.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
}

#pragma property setter and getter method begin
-(UIImageView *)headImageViewMC{
    if(!_headImageViewMC){
        _headImageViewMC = [[UIImageView alloc] init];
    }
    return _headImageViewMC;
}

-(UILabel *)labelNameMC{
    if(!_labelNameMC){
        _labelNameMC = [[UILabel alloc] init];
    }
    return _labelNameMC;
}

-(UILabel *)labelSchoolMC{
    if(!_labelSchoolMC){
        _labelSchoolMC = [[UILabel alloc] init];
    }
    return _labelSchoolMC;
}

-(UIButton *)btnSendMessageMC{
    if(!_btnSendMessageMC){
        _btnSendMessageMC = [[UIButton alloc] init];
    }
    return  _btnSendMessageMC;
}
#pragma property setter and getter method end
@end
