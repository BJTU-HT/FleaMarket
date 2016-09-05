//
//  ImagePickerCollectionViewCell.h
//  test123
//
//  Created by tom555cat on 16/5/23.
//  Copyright © 2016年 Hello World Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePickerCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *contentImg;
@property (nonatomic, assign) BOOL isChoosen;
@property (nonatomic, assign) BOOL isChoosenImgHidden;

// 2个imageView
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIImageView *isChoosenImageView;

@end
