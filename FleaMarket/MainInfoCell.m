//
//  MainInfoCell.m
//  FleaMarket
//
//  Created by tom555cat on 16/9/15.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "MainInfoCell.h"
#import "UIImageView+WebCache.h"

@interface MainInfoCell () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *pictureImageScrollView;
@property (nonatomic, weak) UIImageView *currentImageView;
@property (nonatomic, weak) UIImageView *leftImageView;
@property (nonatomic, weak) UIImageView *rightImageView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UIImageView *sexImageView;
@property (nonatomic, weak) UILabel *publishTimeLabel;
@property (nonatomic, weak) UILabel *schoolLabel;
@property (nonatomic, weak) UILabel *nowPriceLabel;
@property (nonatomic, weak) UILabel *originalPriceLabel;
@property (nonatomic, weak) UILabel *descriptionLabel;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger leftImageIndex;
@property (nonatomic, assign) NSInteger rightImageIndex;

@end

@implementation MainInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 创建滚动视图
        UIScrollView *pictureImageScrollView = [[UIScrollView alloc] init];
        pictureImageScrollView.pagingEnabled = YES;
        pictureImageScrollView.contentSize = CGSizeMake(3 * screenWidthPCH, 0);
        pictureImageScrollView.showsHorizontalScrollIndicator = NO;
        pictureImageScrollView.delegate = self;
        self.pictureImageScrollView = pictureImageScrollView;
        [pictureImageScrollView setContentOffset:CGPointMake(screenWidthPCH, 0) animated:NO];
        
        // 创建ImageView
        UIImageView *currentImageView = [[UIImageView alloc] init];
        UIImageView *leftImageView = [[UIImageView alloc] init];
        UIImageView *rightImageView = [[UIImageView alloc] init];
        currentImageView.backgroundColor = [UIColor blackColor];
        leftImageView.backgroundColor = [UIColor blackColor];
        rightImageView.backgroundColor = [UIColor blackColor];
        currentImageView.contentMode = UIViewContentModeScaleAspectFill;
        currentImageView.clipsToBounds = YES;
        leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        leftImageView.clipsToBounds = YES;
        rightImageView.contentMode = UIViewContentModeScaleAspectFill;
        rightImageView.clipsToBounds = YES;
        self.currentImageView = currentImageView;
        self.leftImageView = leftImageView;
        self.rightImageView = rightImageView;
        [pictureImageScrollView addSubview:currentImageView];
        [pictureImageScrollView addSubview:leftImageView];
        [pictureImageScrollView addSubview:rightImageView];
        [self addSubview:pictureImageScrollView];
        
        // 设置pageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        self.pageControl = pageControl;
        [self addSubview:pageControl];
        
        // 头像
        UIImageView *iconImageView = [[UIImageView alloc] init];
        self.iconImageView = iconImageView;
        [self addSubview:iconImageView];
        
        // 姓名
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = FontSize14;
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        
        // 性别
        UIImageView *sexImageView = [[UIImageView alloc] init];
        self.sexImageView = sexImageView;
        [self addSubview:sexImageView];
        
        // 发布时间
        UILabel *publishTimeLabel = [[UILabel alloc] init];
        publishTimeLabel.font = FontSize12;
        self.publishTimeLabel = publishTimeLabel;
        [self addSubview:publishTimeLabel];
        
        // 学校
        UILabel *schoolLabel = [[UILabel alloc] init];
        schoolLabel.font = FontSize14;
        self.schoolLabel = schoolLabel;
        [self addSubview:schoolLabel];
        
        // 现在价格
        UILabel *nowPriceLabel = [[UILabel alloc] init];
        nowPriceLabel.font = FontSize14;
        nowPriceLabel.textAlignment = NSTextAlignmentCenter;
        [nowPriceLabel setTextColor:[UIColor redColor]];
        self.nowPriceLabel = nowPriceLabel;
        [self addSubview:nowPriceLabel];
        
        // 原始价格
        UILabel *originalPriceLabel = [[UILabel alloc] init];
        originalPriceLabel.textAlignment = NSTextAlignmentCenter;
        originalPriceLabel.font = FontSize12;
        [originalPriceLabel setTextColor:darkGrayColorPCH];
        self.originalPriceLabel = originalPriceLabel;
        [self addSubview:originalPriceLabel];
        
        // 描述
        UILabel *descriptionLabel = [[UILabel alloc] init];
        descriptionLabel.font = FontSize14;
        descriptionLabel.textAlignment = NSTextAlignmentLeft;
        descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        descriptionLabel.numberOfLines = 0;
        self.descriptionLabel = descriptionLabel;
        [self addSubview:descriptionLabel];
        
        NSLog(@"%f", descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height);
    }
    
    return self;
}

/**
 *  当发生滚动时，改变了currentImageIndex，leftImageIndex和rightImageIndex的值
 **/

- (void)reloadImages
{
    CGPoint point = [self.pictureImageScrollView contentOffset];
    if (point.x == 2 *screenWidthPCH) {
        
        if ((_currentImageIndex + 1)  == self.model.pictureArray.count){
            _currentImageIndex = 0;
        }else {
            _currentImageIndex = (_currentImageIndex + 1);
        }
        
    }else if (point.x == 0) {
        if (_currentImageIndex - 1 < 0) {
            _currentImageIndex = self.model.pictureArray.count - 1;
            
        }else {
            _currentImageIndex = _currentImageIndex - 1;
        }
    }
    self.pageControl.currentPage = _currentImageIndex;
    
    // 求self.letfImageIdex的值
    if (_currentImageIndex - 1 < 0) {
        self.leftImageIndex = self.model.pictureArray.count - 1;
    }else {
        self.leftImageIndex = _currentImageIndex - 1;
    }
    
    // 求self.rightImageIndex的值
    if (self.currentImageIndex + 1 == self.model.pictureArray.count) {
        self.rightImageIndex = 0;
    }else {
        self.rightImageIndex = self.currentImageIndex + 1;
    }
    
    [self.currentImageView sd_setImageWithURL:self.model.pictureArray[self.currentImageIndex]];
    [self.leftImageView sd_setImageWithURL:self.model.pictureArray[self.leftImageIndex]];
    [self.rightImageView sd_setImageWithURL:self.model.pictureArray[self.rightImageIndex]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self reloadImages];
    [self.pictureImageScrollView setContentOffset:CGPointMake(screenWidthPCH, 0) animated:NO];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _pictureImageScrollView.frame = _frameModel.pictureImageScrollViewFrame;
    _pageControl.frame = _frameModel.pageControlFrame;
    _currentImageView.frame = _frameModel.currentImageViewFrame;
    _leftImageView.frame = _frameModel.leftImageViewFrame;
    _rightImageView.frame = _frameModel.rightImageViewFrame;
    //_currentImageView.contentMode = UIViewContentModeScaleAspectFit;
    //_leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    //_rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImageView.frame = _frameModel.iconImageViewFrame;
    _nameLabel.frame = _frameModel.nameLabelFrame;
    _sexImageView.frame = _frameModel.sexImageViewFrame;
    _publishTimeLabel.frame = _frameModel.publishTimeLabelFrame;
    _schoolLabel.frame = _frameModel.schoolLabelFrame;
    _nowPriceLabel.frame = _frameModel.nowPriceLabelFrame;
    _originalPriceLabel.frame = _frameModel.originalPriceLabelFrame;
    _descriptionLabel.frame = _frameModel.descriptionLabelFrame;
    NSLog(@"%f, %f", _frameModel.descriptionLabelFrame.size.width, _frameModel.descriptionLabelFrame.size.height);
}

- (void)setModel:(SecondhandVO *)model
{
    _model = model;
    
    _pageControl.numberOfPages = model.pictureArray.count;
    _currentImageIndex = 0;
    _leftImageIndex = model.pictureArray.count - 1;
    if (model.pictureArray.count == 1) {
        _rightImageIndex = 0;
    } else {
        _rightImageIndex = 1;
    }

    [_currentImageView sd_setImageWithURL:model.pictureArray[_currentImageIndex]];
    [_leftImageView sd_setImageWithURL:model.pictureArray[_leftImageIndex]];
    [_rightImageView sd_setImageWithURL:model.pictureArray[_rightImageIndex]];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.userIconImage]];
    _nameLabel.text = model.userName;
    _publishTimeLabel.text = model.publishTime;
    _schoolLabel.text = model.school;
    _nowPriceLabel.text = [NSString stringWithFormat:@"￥%d", (int)model.nowPrice];
    NSString *oldPrice = [NSString stringWithFormat:@"￥%d", (int)model.originalPrice];
    NSUInteger length = [oldPrice length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:darkGrayColorPCH range:NSMakeRange(0, length)];
    [_originalPriceLabel setAttributedText:attri];
    _descriptionLabel.text = model.productDescription;
}

@end

