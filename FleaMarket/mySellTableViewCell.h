//
//  mySellTableViewCell.h
//  FleaMarket
//
//  Created by Hou on 8/24/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mySellAndBorrowView.h"

@interface mySellTableViewCell : UITableViewCell

@property(nonatomic, strong) mySellAndBorrowView *mySellView;
-(void)cellConfig:(CGRect)frame datadic:(NSMutableDictionary *)dic;

@end
