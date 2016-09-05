//
//  MessageFrameModel.h
//  FleaMarket
//
//  Created by tom555cat on 16/4/14.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SecondhandMessageVO.h"

@interface MessageFrameModel : NSObject

// 头像frame
@property (nonatomic, assign) CGRect iconFrame;
// 名字frame
@property (nonatomic, assign) CGRect nameFrame;
// 发布时间frame
@property (nonatomic, assign) CGRect publishTimeFrame;
// 内容frame
@property (nonatomic, assign) CGRect messageFrame;

// cellHeight
@property (nonatomic, assign) CGFloat cellHeight;
// 实例
@property (nonatomic, strong) SecondhandMessageVO *model;

+ (NSMutableArray *)frameModelWithArray:(NSMutableArray *)arr;

+ (instancetype)frameModelWithModel:(SecondhandMessageVO *)model;

@end
