//
//  CollectionDataModel.h
//  test123
//
//  Created by tom555cat on 16/6/6.
//  Copyright © 2016年 Hello World Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface CollectionDataModel : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImage *img;
@property (nonatomic, assign) BOOL selected;

@end
