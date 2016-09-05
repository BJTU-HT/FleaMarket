//
//  CollectionTableViewCell.h
//  test123
//
//  Created by tom555cat on 16/5/25.
//  Copyright © 2016年 Hello World Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionTableViewCell : UITableViewCell

@property (nonatomic , strong) UIImage * albumImg;
@property (nonatomic , strong) NSString * albumTitle;
@property (nonatomic , assign) NSInteger photoNum;

@end
