//
//  ChooseLocationView.m
//  FleaMarket
//
//  Created by tom555cat on 16/6/18.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "ChooseLocationView.h"

@interface ChooseLocationView ()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *locationLabel;

@end

@implementation ChooseLocationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        iconView.image = [UIImage imageNamed:@"location"];
        self.iconView = iconView;
        [self addSubview:iconView];
        
        UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.locationLabel = locationLabel;
        [self addSubview:locationLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat iconX = 0;
    CGFloat iconY = 0;
    CGFloat iconW = self.frame.size.height;
    CGFloat iconH = iconW;
    self.iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGFloat labelX = CGRectGetMaxX(self.iconView.frame);
    CGFloat labelY = 0;
    CGFloat labelW = 150;
    CGFloat labelH = self.frame.size.height;
    self.locationLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
    
    self.location = @"选择学校";
}

- (void)setLocation:(NSString *)location
{
    if (!_location) {
        _location = [NSString stringWithString:location];
    } else {
        _location = location;
    }
    
    // 设置段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    // 格式
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:location
                                                                                        attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                                                                     NSFontAttributeName:FontSize12,
                                                                                                     NSParagraphStyleAttributeName:paragraphStyle}];
    
    self.locationLabel.attributedText = attributeString;
}

@end
