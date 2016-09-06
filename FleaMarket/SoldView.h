//
//  SoldView.h
//  FleaMarket
//
//  Created by Hou on 7/20/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoldView : UIView

@property (strong, nonatomic) UIImageView *headImage;
@property (strong, nonatomic) UILabel *userName;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *goodsStatus;
@property (strong, nonatomic) UILabel *locationBelong;
@property (strong, nonatomic) UIScrollView *scrollViewSold;
@property (strong, nonatomic) UILabel *describeLa;
@property (strong, nonatomic) UILabel *destinationLa;
@property (strong, nonatomic) UILabel *price;

@end
