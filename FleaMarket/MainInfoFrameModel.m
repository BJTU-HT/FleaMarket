//
//  MainInfoFrameModel.m
//  FleaMarket
//
//  Created by tom555cat on 16/9/16.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "MainInfoFrameModel.h"

@implementation MainInfoFrameModel

+ (instancetype)frameModelWithModel:(SecondhandVO *)model
{
    return [[self alloc] initWithModel:model];
}

- (instancetype)initWithModel:(SecondhandVO *)model
{
    self = [super init];
    if (self) {
        self.model = model;
    }
    
    return self;
}

- (CGFloat)cellHeight
{
    if (_cellHeight == 0) {
        CGSize winSize = [UIScreen mainScreen].bounds.size;
        CGFloat margin = 10;
        
        // 滚动视图
        CGFloat scrollViewX = 0;
        CGFloat scrollViewY = 0;
        CGFloat scrollViewW = winSize.width;
        CGFloat scrollViewH = 350;
        self.pictureImageScrollViewFrame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);
        
        // pageControlFrame
        CGFloat spaceForOne = screenWidthPCH / 10.0f;   // 最多上传10张图片
        CGFloat pageControlW = spaceForOne * self.model.pictureArray.count;
        CGFloat pageControlH = spaceForOne;
        CGFloat pageControlX = screenWidthPCH / 2.0f - pageControlW / 2.0f;
        CGFloat pageControlY = scrollViewH * 0.7f;
        self.pageControlFrame = CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH);
        
        self.currentImageViewFrame = CGRectMake(screenWidthPCH, 0, screenWidthPCH, scrollViewH);
        self.leftImageViewFrame = CGRectMake(0, 0, screenWidthPCH, scrollViewH);
        self.rightImageViewFrame = CGRectMake(2 * screenWidthPCH, 0, screenWidthPCH, scrollViewH);
        
        // 头像
        CGFloat iconX = margin;
        CGFloat iconY = CGRectGetMaxY(self.pictureImageScrollViewFrame) + margin;
        CGFloat iconWH = 30;
        self.iconImageViewFrame = CGRectMake(iconX, iconY, iconWH, iconWH
                                             );
        // 姓名
        NSDictionary *nameAttrs = @{NSFontAttributeName : FontSize14};
        CGSize nameSize = [self.model.userName sizeWithAttributes:nameAttrs];
        CGFloat nameY = iconY;
        CGFloat nameX = CGRectGetMaxX(self.iconImageViewFrame) + margin;
        self.nameLabelFrame = (CGRect){{nameX, nameY}, nameSize};
        
        // 发布时间
        NSDictionary *publishTimeAttrs = @{NSFontAttributeName : FontSize12};
        CGSize publishTimeSize = [self.model.publishTime sizeWithAttributes:publishTimeAttrs];
        CGFloat publishTimeY = CGRectGetMaxY(self.iconImageViewFrame) - publishTimeSize.height;
        CGFloat publishTimeX = CGRectGetMaxX(self.iconImageViewFrame) + margin;
        self.publishTimeLabelFrame = (CGRect){{publishTimeX, publishTimeY}, publishTimeSize};
        
        // 学校
        NSDictionary *schoolAttrs = @{NSFontAttributeName : FontSize14};
        CGSize schoolSize = [self.model.school sizeWithAttributes:schoolAttrs];
        CGFloat schoolY = iconY + iconWH/2.0f - schoolSize.height/2.0f;
        CGFloat schoolX = screenWidthPCH - schoolSize.width - margin;
        self.schoolLabelFrame = CGRectMake(schoolX, schoolY, schoolSize.width, schoolSize.height);
        
        // 现在价格
        CGFloat nowPriceX = margin;
        CGFloat nowPriceY = CGRectGetMaxY(self.iconImageViewFrame) + margin/2.0f;
        NSDictionary *nowPriceAttr = @{NSFontAttributeName : FontSize14};
        CGSize nowPriceSize = [[NSString stringWithFormat:@"￥%.1f", self.model.nowPrice] sizeWithAttributes:nowPriceAttr];
        self.nowPriceLabelFrame = CGRectMake(nowPriceX, nowPriceY, nowPriceSize.width, nowPriceSize.height);
        
        // 原始价格
        NSDictionary *originalPriceAttr = @{NSFontAttributeName : FontSize12};
        CGSize originalPriceSize = [[NSString stringWithFormat:@"￥%.1f", self.model.originalPrice] sizeWithAttributes:originalPriceAttr];
        CGFloat originalPriceX = CGRectGetMaxX(self.nowPriceLabelFrame);
        CGFloat originalPriceY = CGRectGetMaxY(self.nowPriceLabelFrame) - originalPriceSize.height;
        self.originalPriceLabelFrame = CGRectMake(originalPriceX, originalPriceY, originalPriceSize.width, originalPriceSize.height);
    
        // 描述
        CGFloat descriptionX = margin;
        CGFloat descriptionY = CGRectGetMaxY(self.nowPriceLabelFrame) + margin/2.0f;
        CGFloat descriptionW = screenWidthPCH - 2 * margin;
        self.descriptionLabelFrame = CGRectMake(descriptionX, descriptionY, descriptionW, 0);
        CGRect txtFrame = self.descriptionLabelFrame;
        self.descriptionLabelFrame = CGRectMake(descriptionX, descriptionY, descriptionW, txtFrame.size.height = [self.model.productDescription boundingRectWithSize:CGSizeMake(txtFrame.size.width, 1000000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:FontSize14, NSFontAttributeName, nil] context:nil].size.height);
        NSLog(@"%f", txtFrame.size.height);
        //self.descriptionLabelFrame = CGRectMake(descriptionX, descriptionY, descriptionW, txtFrame.size.height);
        
        _cellHeight = CGRectGetMaxY(self.descriptionLabelFrame) + margin/2.0f;
    }
    
    return _cellHeight;
}

@end
