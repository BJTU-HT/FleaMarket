//
//  PlaceholderTextView.m
//  test
//
//  Created by tom555cat on 16/6/22.
//  Copyright © 2016年 Hello World Corporation. All rights reserved.
//

#import "PlaceholderTextView.h"

@interface PlaceholderTextView ()

@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation PlaceholderTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.backgroundColor = [UIColor clearColor];
        placeholderLabel.numberOfLines = 0;
        [self addSubview:placeholderLabel];
        self.placeholderLabel = placeholderLabel;
        
        self.myPlaceholderColor = [UIColor lightGrayColor];
        self.font = [UIFont systemFontOfSize:14];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    
    return self;
}

- (void)textDidChange
{
    self.placeholderLabel.hidden = self.hasText;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat labelX = 8;
    CGFloat labelY = 8;
    NSDictionary *labelAttrs = @{NSFontAttributeName: self.font};
    CGSize labelSize = [self.myPlaceholder sizeWithAttributes:labelAttrs];
    
    self.placeholderLabel.frame = (CGRect){{labelX, labelY}, labelSize};
}

- (void)setMyPlaceholder:(NSString *)myPlaceholder
{
    _myPlaceholder = myPlaceholder;
    
    // 设置文字
    self.placeholderLabel.text = myPlaceholder;
    
    // 重新计算子空间的frame
    [self setNeedsLayout];
}

- (void)setMyPlaceholderColor:(UIColor *)myPlaceholderColor
{
    _myPlaceholderColor = myPlaceholderColor;
    
    // 设置颜色
    self.placeholderLabel.textColor = myPlaceholderColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderLabel.font = font;
    [self setNeedsLayout];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self textDidChange];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:UITextViewTextDidChangeNotification];
}

@end
