//
//  bookUserInfoTableViewCell.h
//  FleaMarket
//
//  Created by Hou on 8/2/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bookUserInfoView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface bookUserInfoTableViewCell : UITableViewCell

@property(nonatomic, strong) bookUserInfoView *bookUserView;
-(void)configBookUserCell:(NSMutableDictionary *)mudic;
@end
