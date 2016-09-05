//
//  PriceView.m
//  FleaMarket
//
//  Created by tom555cat on 16/6/15.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "PriceView.h"
#import "UITextField+RYNumberKeyboard.h"

@interface PriceView ()

@property (nonatomic, strong) UILabel *nowPriceLabel;
@property (nonatomic, strong) UITextField *nowPriceInput;
@property (nonatomic, strong) UILabel *originalPriceLabel;
@property (nonatomic, strong) UITextField *originalPriceInput;

@property (nonatomic, strong) UIView *marginBar;

@end

@implementation PriceView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 现价标签
        UILabel *nowPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.nowPriceLabel = nowPriceLabel;
        //nowPriceLabel.backgroundColor = [UIColor grayColor];
        [self addSubview:self.nowPriceLabel];
        
        // 现价输入
        UITextField *nowPriceInput = [[UITextField alloc] initWithFrame:CGRectZero];
        nowPriceInput.ry_inputType = RYFloatInputType;
        nowPriceInput.textAlignment = NSTextAlignmentLeft;
        self.nowPriceInput = nowPriceInput;
        [self addSubview:self.nowPriceInput];
        
        // 原价标签
        UILabel *originalPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.originalPriceLabel = originalPriceLabel;
        //self.originalPriceLabel.backgroundColor = [UIColor grayColor];
        [self addSubview:self.originalPriceLabel];
        
        // 原价输入
        UITextField *originalPriceInput = [[UITextField alloc] initWithFrame:CGRectZero];
        originalPriceInput.ry_inputType = RYFloatInputType;
        originalPriceInput.textAlignment = NSTextAlignmentLeft;
        self.originalPriceInput = originalPriceInput;
        [self addSubview:self.originalPriceInput];
        
        // 间隔条
        UIView *marginBar = [[UIView alloc] init];
        self.marginBar = marginBar;
        self.marginBar.backgroundColor = [UIColor grayColor];
        [self addSubview:self.marginBar];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat labelW = (self.frame.size.width - 0.5) * 0.5f / 2.0f;
    CGFloat labelH = self.frame.size.height;
    CGFloat inputW = labelW;
    CGFloat inputH = self.frame.size.height;
    
    // 设置段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    // 现价标签
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *nowAttributeString = [[NSMutableAttributedString alloc]
                                                     initWithString:@"现价￥:"
                                                     attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                                  NSFontAttributeName:FontSize14,
                                                                  NSParagraphStyleAttributeName:paragraphStyle}];
    
    CGFloat nowLabelX = 0;
    CGFloat nowLabelY = 0;
    CGFloat nowLabelW = labelW;
    CGFloat nowLabelH = labelH;
    self.nowPriceLabel.attributedText = nowAttributeString;
    self.nowPriceLabel.frame = CGRectMake(nowLabelX, nowLabelY, nowLabelW, nowLabelH);
    
    
    // 现价输入
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSMutableAttributedString *nowPlaceHolderAttributeString = [[NSMutableAttributedString alloc]
                                                                initWithString:@"0.00"
                                                                attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                                                             NSFontAttributeName:FontSize14,
                                                                             NSParagraphStyleAttributeName:paragraphStyle}];
    
    CGFloat nowInputX = CGRectGetMaxX(self.nowPriceLabel.frame);
    CGFloat nowInputY = 0;
    CGFloat nowInputW = inputW;
    CGFloat nowInputH = inputH;
    self.nowPriceInput.attributedPlaceholder = nowPlaceHolderAttributeString;
    self.nowPriceInput.frame = CGRectMake(nowInputX, nowInputY, nowInputW, nowInputH);
    
    // 间隔
    CGFloat marginX = CGRectGetMaxX(self.nowPriceInput.frame);
    CGFloat marginY = 0;
    CGFloat marginW = 0.5f;
    CGFloat marginH = labelH;
    self.marginBar.frame = CGRectMake(marginX, marginY, marginW, marginH);
    
    // 原价标签
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *originalAttributeString = [[NSMutableAttributedString alloc]
                                                          initWithString:@"原价￥:"
                                                          attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                                       NSFontAttributeName:FontSize14,
                                                                       NSParagraphStyleAttributeName:paragraphStyle}];
    
    CGFloat originalLabelX = CGRectGetMaxX(self.marginBar.frame);
    CGFloat originalLabelY = 0;
    CGFloat originalLabelW = labelW;
    CGFloat originalLabelH = labelH;
    self.originalPriceLabel.attributedText = originalAttributeString;
    self.originalPriceLabel.frame = CGRectMake(originalLabelX, originalLabelY, originalLabelW, originalLabelH);
    
    // 原价输入
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSMutableAttributedString *originalPlaceHolderAttributeString = [[NSMutableAttributedString alloc]
                                                                     initWithString:@"0.00"
                                                                     attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                                                                  NSFontAttributeName:FontSize14,
                                                                                  NSParagraphStyleAttributeName:paragraphStyle}];
    
    CGFloat originalInputX = CGRectGetMaxX(self.originalPriceLabel.frame);
    CGFloat originalInputY = 0;
    CGFloat originalInputW = inputW;
    CGFloat originalInputH = inputH;
    self.originalPriceInput.attributedPlaceholder = originalPlaceHolderAttributeString;
    self.originalPriceInput.frame = CGRectMake(originalInputX, originalInputY, originalInputW, originalInputH);
}

- (CGFloat)originalPrice
{
    NSString *temp = self.originalPriceInput.text;
    return [temp floatValue];
}

- (CGFloat)nowPrice
{
    NSString *temp = self.nowPriceInput.text;
    return [temp floatValue];
}

@end
