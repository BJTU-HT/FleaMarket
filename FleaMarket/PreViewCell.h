//
//  PreViewCell.h
//  test123
//
//  Created by tom555cat on 16/5/24.
//  Copyright © 2016年 Hello World Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface PreViewCell : UICollectionViewCell

@property (nonatomic, strong) PHAsset *asset;

- (void)configWith:(PHAsset *)phasset;

@end
