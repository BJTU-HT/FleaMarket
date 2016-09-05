//
//  AssetCollectionCell.h
//  test123
//
//  Created by tom555cat on 16/5/26.
//  Copyright © 2016年 Hello World Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetCollectionCell : UITableViewCell

@property (nonatomic , strong) UIImage *albumImg;
@property (nonatomic , strong) NSString *albumTitle;
@property (nonatomic , assign) NSInteger photoNum;

@end
