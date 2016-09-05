//
//  ThumbnailCollectionViewCell.m
//  test123
//
//  Created by tom555cat on 16/6/4.
//  Copyright © 2016年 Hello World Corporation. All rights reserved.
//

#import "ThumbnailCollectionViewCell.h"

@interface ThumbnailCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *dropImgBtn;

@property (weak, nonatomic) IBOutlet UIImageView *seletedImgView;

@end

@implementation ThumbnailCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setAsset:(PHAsset *)asset
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    
    CGSize size = CGSizeMake(asset.pixelWidth/20, asset.pixelHeight/20);
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.seletedImgView.image = result;
    }];
}


- (void)setContentImg:(UIImage *)contentImg
{
    if (contentImg) {
        _contentImg = contentImg;
        self.seletedImgView.image = _contentImg;
    }
}

- (IBAction)dropImgAction:(id)sender {
    self.dropSelectedBlock();
}


@end
