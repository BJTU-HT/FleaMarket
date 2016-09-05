//
//  UploadImageCell.h
//  FleaMarket
//
//  Created by tom555cat on 16/6/21.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLCircleProgressView.h"

typedef void(^DropCurrentChooseImg)();
typedef void(^SelectMoreImg)();

@interface UploadImageCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *contentImg;

@property (nonatomic, strong) UIImageView *uploadImageView;

@property (nonatomic, strong) UIButton *dropImageBtn;

@property (nonatomic, strong) WLCircleProgressView *circleProgress;

// 点击删除图标删除当前选中图片
@property (nonatomic, strong) DropCurrentChooseImg dropCurrentChooseImg;

// 如果当前图标是个“+”，则添加更多图片
@property (nonatomic, strong) SelectMoreImg selectMoreImg;

@end
