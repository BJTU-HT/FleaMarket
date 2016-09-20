//
//  PublishSecondhandVC.h
//  FleaMarket
//
//  Created by tom555cat on 16/9/19.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>

// 当提交后，删除所有选中的对象
@protocol DeleteSelectedImgDelegate

- (void)deleteSelectedImgs;

@end

@interface PublishSecondhandVC : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) id<DeleteSelectedImgDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *selectedImgArray;

// 读取相册数据相关的成员
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSMutableArray *collectionData;

@property (nonatomic, strong) UITableView *tableView;

@end
