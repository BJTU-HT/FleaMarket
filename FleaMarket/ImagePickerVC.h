//
//  ImagePickerVC.h
//  test123
//
//  Created by tom555cat on 16/5/23.
//  Copyright © 2016年 Hello World Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>


@protocol AddMoreImgDelegate

- (void)addMoreImg:(NSMutableArray *)collectionData;

@end

@interface ImagePickerVC : UIViewController

@property (nonatomic, weak) id<AddMoreImgDelegate> delegate;

// 已经选中的相片array
@property (nonatomic, strong) NSMutableArray *selectedModel;

@property (nonatomic, strong) NSMutableArray *tableData;

@property (nonatomic, strong) NSMutableArray *collectionData;

// 选中相片的array，只有相片
@property (nonatomic, strong) NSMutableArray *selectedArray;

// 当前的相册
@property (nonatomic, strong) PHAssetCollection *assetCollection;

// 标记, 是否是从发布页中的添加新图片跳转过来的，如果是，则为YES；
// 如果是直接选择图片过来的，则为NO
//@property (nonatomic, assign) BOOL flag;

@end
