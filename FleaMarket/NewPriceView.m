//
//  NewPriceView.m
//  FleaMarket
//
//  Created by tom555cat on 16/9/19.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "NewPriceView.h"
#import "UITextField+RYNumberKeyboard.h"

@interface NewPriceView ()

@property (nonatomic, strong) UILabel *nowPriceLabel;
@property (nonatomic, strong) UITextField *nowPriceInput;

@end

@implementation NewPriceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *nowPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nowPriceLabel.font = FontSize14;
        nowPriceLabel.textAlignment = NSTextAlignmentRight;
        nowPriceLabel.text = @"现价(￥):";
        self.nowPriceLabel = nowPriceLabel;
        [self addSubview:nowPriceLabel];
        
        UITextField *nowPriceInput = [[UITextField alloc] initWithFrame:CGRectZero];
        nowPriceInput.font = FontSize14;
        nowPriceInput.ry_inputType = RYFloatInputType;
        nowPriceInput.textAlignment = NSTextAlignmentCenter;
        nowPriceInput.placeholder = @"输入现在出售价格";
        self.nowPriceInput = nowPriceInput;
        [self addSubview:nowPriceInput];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.nowPriceLabel.frame = CGRectMake(0, 0, self.frame.size.width/4.0, self.frame.size.height);
    self.nowPriceInput.frame = CGRectMake(self.frame.size.width/4.0, 0, self.frame.size.width*3.0/4.0, self.frame.size.height);
    
}

- (CGFloat)nowPrice
{
    NSString *temp = self.nowPriceInput.text;
    return [temp floatValue];
}

@end
