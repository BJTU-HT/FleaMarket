//
//  SecondhandFrame.h
//  FleaMarket
//
//  Created by tom555cat on 16/3/28.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SecondhandVO.h"

@interface SecondhandFrameModel : NSObject

// 头像frame
@property (nonatomic, assign) CGRect iconFrame;
// 名字frame
@property (nonatomic, assign) CGRect nameFrame;
// 发布时间frame
@property (nonatomic, assign) CGRect publishTimeFrame;
// 性别frame
@property (nonatomic, assign) CGRect sexFrame;
// 价格frame
@property (nonatomic, assign) CGRect priceFrame;
// 描述frame
@property (nonatomic, assign) CGRect descriptionFrame;
// 配图frame
@property (nonatomic, assign) CGRect pictureFrame;

@property (nonatomic, assign) CGRect picture1Frame;
@property (nonatomic, assign) CGRect picture2Frame;
@property (nonatomic, assign) CGRect picture3Frame;


// 地址frame
@property (nonatomic, assign) CGRect locationFrame;
// 学校frame
@property (nonatomic, assign) CGRect schoolFrame;

// 分割线frame
@property (nonatomic, assign) CGRect partLineFrame;

// cell间隔
@property (nonatomic, assign) CGRect cellPartFrame;

// cellHeight
@property (nonatomic, assign) CGFloat cellHeight;

// 二手实例vo
@property (nonatomic, strong) SecondhandVO *model;

+ (NSMutableArray *)frameModelWithArray:(NSMutableArray *)arr;

+ (instancetype)frameModelWithModel:(SecondhandVO *)model;


@end
