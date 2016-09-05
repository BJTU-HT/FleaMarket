//
//  YBImgPickerViewCell.h
//  settingsTest
//
//  Created by 宋奕兴 on 15/9/7.
//  Copyright (c) 2015年 宋奕兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void(^SelectedBlock)(BOOL select);

@interface YBImgPickerViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImage * contentImg;
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, assign) BOOL isChoosen;
@property (nonatomic, assign) BOOL isChoosenImgHidden;

@property (nonatomic, assign) BOOL isChoosenBtnSelected;
@property (nonatomic, assign) BOOL isChoosenBtnHidden;
@property (nonatomic, strong) SelectedBlock selectedBlock;
@end
