//
//  bookShowTableViewCell.h
//  FleaMarket
//
//  Created by Hou on 8/1/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bookDisplayCellView.h"

@interface bookShowTableViewCell : UITableViewCell

@property(nonatomic, strong) bookDisplayCellView *bookDisView;
-(CGFloat)cellConfig:(NSMutableDictionary *)mudic;
@end
