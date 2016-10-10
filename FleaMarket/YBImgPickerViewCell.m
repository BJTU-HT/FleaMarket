//
//  YBImgPickerViewCell.m
//  settingsTest
//
//  Created by 宋奕兴 on 15/9/7.
//  Copyright (c) 2015年 宋奕兴. All rights reserved.
//

#import "YBImgPickerViewCell.h"
@interface YBImgPickerViewCell ()
@property (nonatomic , strong) IBOutlet UIImageView * mainImageView;
@property (nonatomic , strong) IBOutlet UIImageView * isChoosenImageView;
@property (weak, nonatomic) IBOutlet UIButton *isChooseBtn;

@end
@implementation YBImgPickerViewCell

- (void)awakeFromNib {
    //20161009 1122 add for release warning
    [super awakeFromNib];
    // Initialization code
    self.isChoosenImageView.hidden = YES;
}

- (void)setAsset:(PHAsset *)asset
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    
    CGSize size = CGSizeMake(asset.pixelWidth/20, asset.pixelHeight/20);
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.mainImageView.image = result;
    }];
}

- (void)setContentImg:(UIImage *)contentImg {
    if (contentImg) {
        _contentImg = contentImg;
        self.mainImageView.image = _contentImg;
    }
}
- (void)setIsChoosen:(BOOL)isChoosen {
    _isChoosen = isChoosen;
    /*
    [UIView animateWithDuration:0.2 animations:^{
        if (isChoosen) {
            self.isChoosenImageView.image = [UIImage imageNamed:@"YBimgPickerView.bundle/isChoosenY"];
            
        }else {
            self.isChoosenImageView.image = nil;
        }
        self.isChoosenImageView.transform = CGAffineTransformMakeScale (1.1,1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.isChoosenImageView.transform = CGAffineTransformMakeScale (1.0,1.0);
        } completion:^(BOOL finished) {
            
        }];
    }];
    */
}

- (void)setIsChoosenImgHidden:(BOOL)isChoosenImgHidden {
    _isChoosenImgHidden = isChoosenImgHidden;
    //self.isChoosenImageView.hidden = isChoosenImgHidden;
}

- (void)setIsChoosenBtnSelected:(BOOL)isChoosenBtnSelected
{
    if (isChoosenBtnSelected) {
        self.isChooseBtn.selected = YES;
    } else {
        self.isChooseBtn.selected = NO;
    }
}

- (void)setIsChoosenBtnHidden:(BOOL)isChoosenBtnHidden
{
    if (isChoosenBtnHidden) {
        self.isChooseBtn.hidden = YES;
    } else {
        self.isChooseBtn.hidden = NO;
    }
}

- (IBAction)selectCurrentImg:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.selected) {
        btn.selected = NO;
        self.selectedBlock(NO);
    } else {
        btn.selected = YES;
        self.selectedBlock(YES);
    }
}

@end
