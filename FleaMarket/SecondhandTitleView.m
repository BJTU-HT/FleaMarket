//
//  SecondhandTitleView.m
//  FleaMarket
//
//  Created by tom555cat on 16/4/9.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "SecondhandTitleView.h"

@interface SecondhandTitleView ()

@property (nonatomic, strong) UIButton *locationBtn;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation SecondhandTitleView

CGFloat margin = 10.0f;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // 地理位置按钮
        /*
         UIButton *locationBtn = [[UIButton alloc] init];
         [locationBtn setBackgroundImage:[UIImage imageNamed:@"4@2x.png"] forState:UIControlStateNormal];
         [locationBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
         [self addSubview:locationBtn];
         self.locationBtn = locationBtn;
         */
        
        // 搜索框
        /*
         UISearchBar *searchBar = [[UISearchBar alloc] init];
         [self addSubview:searchBar];
         self.searchBar = searchBar;
         */
        
        // 地址描述label
        UILabel *locationLabel = [[UILabel alloc] init];
        locationLabel.font = FontSize20;
        [self addSubview:locationLabel];
        self.locationLabel = locationLabel;
        
        // 箭头图标
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.image = [UIImage imageNamed:@"arrow"];
        [self addSubview:arrowImageView];
        self.arrowImageView = arrowImageView;
        
    }
    
    return self;
}

- (void)btnClick
{
    NSLog(@"选择地址");
    self.locationName = @"123";
    CGRect oldRect = self.frame;
    self.frame = CGRectMake(oldRect.origin.x, oldRect.origin.y, oldRect.size.width+2, oldRect.size.height+2);
    //[self setNeedsDisplay];
}

- (void)layoutSubviews
{
    CGFloat navigationBarH = 44;
    CGFloat statusBarH = 20;
    
    // 地理位置按钮
    CGFloat locationBtnX = 0;
    CGFloat locationBtnY = 0;
    CGFloat locationWH = self.frame.size.height;
    self.locationBtn.frame = CGRectMake(locationBtnX, locationBtnY, locationWH, locationWH);
    
    // 搜索bar
    /*
     CGFloat searchBarX = locationWH + margin;
     CGFloat searchBarY = 0;
     CGFloat searchBarW = self.frame.size.width - locationWH - margin;
     CGFloat searchBarH = self.frame.size.height;
     self.searchBar.frame = CGRectMake(searchBarX, searchBarY, searchBarW, searchBarH);
     */
    
    // 地址label
    CGFloat locationLabelX = 0;
    CGFloat locationLabelY = 0;
    CGFloat locationLabelW = self.frame.size.width;
    CGFloat locationLabelH = self.frame.size.height / 2.0f;
    self.locationLabel.frame = CGRectMake(locationLabelX, locationLabelY, locationLabelW, locationLabelH);
    
    // 箭头
    CGFloat margin = 3;
    CGFloat arrowHeight = self.frame.size.height / 2.0f;
    CGFloat arrowWidth = arrowHeight;
    CGFloat arrowX = self.frame.size.width / 2.0f - arrowWidth / 2.0f;
    CGFloat arrowY = CGRectGetMaxY(self.locationLabel.frame) + margin;
    self.arrowImageView.frame = CGRectMake(arrowX, arrowY, arrowWidth, arrowHeight);
}

- (void)setLocationName:(NSString *)locationName
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", locationName]];
    [attributeString addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                     NSFontAttributeName:FontSize18,
                                     NSParagraphStyleAttributeName:paragraphStyle}
                             range:NSMakeRange(0, [locationName length])];
    self.locationLabel.attributedText = attributeString;
    NSLog(@"调用");
}

@end
