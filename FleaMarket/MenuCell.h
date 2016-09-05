//
//  MenuCell.h
//  FleaMarket
//
//  Created by tom555cat on 16/4/7.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondhandCategoryDelegate.h"

@interface MenuCell : UITableViewCell

@property (weak, nonatomic) id <SecondhandCategoryDelegate> delegate;

@property (nonatomic, assign) NSInteger currentCategory;

@end
