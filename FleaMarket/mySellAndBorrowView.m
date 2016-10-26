//
//  mySellAndBorrowView.m
//  FleaMarket
//
//  Created by Hou on 8/24/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "mySellAndBorrowView.h"

@implementation mySellAndBorrowView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.labelSchoolSell.font = FontSize14;
        self.labelSchoolSell.textAlignment = NSTextAlignmentRight;
        self.labelPriceSell.font = FontSize14;
        self.labelDateSell.font = FontSize14;
    }
    [self addSubview:self.labelSchoolSell];
    [self addSubview:self.labelPriceSell];
    [self addSubview:self.labelDateSell];
    [self addSubview:self.imageViewSell];
    return self;
}

-(void)layoutSubviews{
    float margin = 5.0f;
    float marginParallel = 10.0f;
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    float imageView_x = marginParallel;
    float imageView_y = margin;
    float imageView_width = width * 0.35;
    float imageView_h = height - 2 *margin;

    self.imageViewSell.frame = CGRectMake(imageView_x, imageView_y, imageView_width, imageView_h);
    
    float price_x = imageView_width + 2 * marginParallel;
    float price_y = imageView_y;
    float price_w = width * 0.30;
    float price_h = 16;
    
    self.labelPriceSell.frame = CGRectMake(price_x, price_y, price_w, price_h);
    
    float school_w = width * 0.4;
    float school_x = width - marginParallel - school_w;
    float school_y = price_y;
    float school_h = 16;
    
    self.labelSchoolSell.frame = CGRectMake(school_x, school_y, school_w, school_h);
    
    float date_h = 16;
    float date_w = 0.5 * width;
    float date_x = price_x;
    float date_y = margin + imageView_h - date_h;
    
    self.labelDateSell.frame = CGRectMake(date_x, date_y, date_w, date_h);
}

-(UILabel *)labelDateSell{
    if(!_labelDateSell){
        _labelDateSell = [[UILabel alloc] init];
    }
    return _labelDateSell;
}

-(UILabel *)labelPriceSell{
    if(!_labelPriceSell){
        _labelPriceSell = [[UILabel alloc] init];
    }
    return _labelPriceSell;
}

-(UILabel *)labelSchoolSell{
    if(!_labelSchoolSell){
        _labelSchoolSell = [[UILabel alloc] init];
    }
    return _labelSchoolSell;
}

-(UIImageView *)imageViewSell{
    if(!_imageViewSell){
        _imageViewSell = [[UIImageView alloc] init];
    }
    return _imageViewSell;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
