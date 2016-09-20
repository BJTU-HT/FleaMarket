//
//  PreViewCell.h
//  test123
//
//  Created by tom555cat on 16/5/24.
//  Copyright © 2016年 Hello World Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "CollectionDataModel.h"

@interface PreViewCell : UICollectionViewCell

//@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, strong) CollectionDataModel *model;

- (void)configWith:(PHAsset *)phasset;

@end
