//
//  OldPriceView.m
//  FleaMarket
//
//  Created by tom555cat on 16/9/19.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "OldPriceView.h"
#import "UITextField+RYNumberKeyboard.h"

@interface OldPriceView ()

@property (nonatomic, strong) UILabel *oldPriceLabel;
@property (nonatomic, strong) UITextField *oldPriceInput;

@end

@implementation OldPriceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        oldPriceLabel.font = FontSize14;
        oldPriceLabel.textAlignment = NSTextAlignmentRight;
        oldPriceLabel.text = @"原价(￥):";
        self.oldPriceLabel = oldPriceLabel;
        [self addSubview:oldPriceLabel];
        
        UITextField *oldPriceInput = [[UITextField alloc] initWithFrame:CGRectZero];
        oldPriceInput.font = FontSize14;
        oldPriceInput.ry_inputType = RYFloatInputType;
        oldPriceInput.textAlignment = NSTextAlignmentCenter;
        oldPriceInput.placeholder = @"输入商品原来的价格";
        self.oldPriceInput = oldPriceInput;
        [self addSubview:oldPriceInput];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.oldPriceLabel.frame = CGRectMake(0, 0, self.frame.size.width/4.0, self.frame.size.height);
    self.oldPriceInput.frame = CGRectMake(self.frame.size.width/4.0, 0, self.frame.size.width*3.0/4.0, self.frame.size.height);
    
}

- (CGFloat)originalPrice
{
    NSString *temp = self.oldPriceInput.text;
    return [temp floatValue];
}


@end
