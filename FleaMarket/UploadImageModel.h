//
//  UpLoadImageModel.h
//  FleaMarket
//
//  Created by tom555cat on 16/6/19.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface UploadImageModel : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImage *img;
@property (nonatomic, assign) BOOL isUploaded;

@end
