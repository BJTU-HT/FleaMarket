//
//  PreViewCell.m
//  test123
//
//  Created by tom555cat on 16/5/24.
//  Copyright © 2016年 Hello World Corporation. All rights reserved.
//

#import "PreViewCell.h"

#define WIDTH_PIC       self.bounds.size.width
#define HEIGHT_PIC      self.bounds.size.height

@interface PreViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PreViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self makeUI];
    }
    
    return self;
}

- (void)makeUI
{
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_PIC, HEIGHT_PIC)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.imageView];
    
    // 没有必要点击隐藏navBar
    /*
     UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddeNav)];
     [self.imageView addGestureRecognizer:tap];
     */
}

/*
- (void)configWith:(PHAsset *)phasset
{
    // 在资源的集合中获取第一个集合，并获取其中的图片
    self.imageView.image = nil;
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:phasset
                            targetSize:PHImageManagerMaximumSize
                           contentMode:PHImageContentModeDefault
                               options:nil
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             self.imageView.image = result;
                         }];
    
}

- (void)setAsset:(PHAsset *)asset
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.imageView.image = result;
    }];
}
 */

- (void)setModel:(CollectionDataModel *)model
{
    PHAsset *asset = model.asset;
    if (asset) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.imageView.image = result;
        }];
    } else if (model.img) {
        self.imageView.image = model.img;
    }
}

- (void)configWith:(PHAsset *)phasset
{
    // nothing
}

@end
