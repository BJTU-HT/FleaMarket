//
//  PreViewController.h
//  test123
//
//  Created by tom555cat on 16/5/24.
//  Copyright © 2016年 Hello World Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePickerVC.h"

@protocol SelectedArrayDelegate <NSObject>

- (void)updateSelectedArray:(NSMutableArray *)array;

@end

@interface PreViewController : UIViewController

@property (nonatomic, weak) id <SelectedArrayDelegate> delegate;

// 该代理由PublishDetail实现
@property (nonatomic, weak) id<AddMoreImgDelegate> moreImgdelegate;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (nonatomic, strong) NSMutableArray *imgModelArray;

// 我们新的数据源
@property (nonatomic, strong) NSMutableArray *collectionData;

@end
