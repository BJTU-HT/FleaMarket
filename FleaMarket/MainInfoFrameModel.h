//
//  MainInfoFrameModel.h
//  FleaMarket
//
//  Created by tom555cat on 16/9/16.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SecondhandVO.h"

@interface MainInfoFrameModel : NSObject

@property (nonatomic, assign) CGRect pictureImageScrollViewFrame;
@property (nonatomic, assign) CGRect pageControlFrame;
@property (nonatomic, assign) CGRect currentImageViewFrame;
@property (nonatomic, assign) CGRect leftImageViewFrame;
@property (nonatomic, assign) CGRect rightImageViewFrame;
@property (nonatomic, assign) CGRect iconImageViewFrame;
@property (nonatomic, assign) CGRect nameLabelFrame;
@property (nonatomic, assign) CGRect sexImageViewFrame;
@property (nonatomic, assign) CGRect publishTimeLabelFrame;
@property (nonatomic, assign) CGRect schoolLabelFrame;
@property (nonatomic, assign) CGRect nowPriceLabelFrame;
@property (nonatomic, assign) CGRect originalPriceLabelFrame;
@property (nonatomic, assign) CGRect descriptionLabelFrame;
//20161121 10:31 add by hou
@property (nonatomic, assign) CGRect reportBtnFrame;
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) SecondhandVO *model;

+ (instancetype)frameModelWithModel:(SecondhandVO *)model;

- (instancetype)initWithModel:(SecondhandVO *)model;

@end
