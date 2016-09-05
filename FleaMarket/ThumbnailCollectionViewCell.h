//
//  ThumbnailCollectionViewCell.h
//  test123
//
//  Created by tom555cat on 16/6/4.
//  Copyright © 2016年 Hello World Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void(^DropSelectdBlock)(void);

@interface ThumbnailCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImage *contentImg;
@property (nonatomic, strong) DropSelectdBlock dropSelectedBlock;

@end
