//
//  myConcernedTableViewCell.h
//  FleaMarket
//
//  Created by Hou on 9/13/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myConcernedView.h"

@interface myConcernedTableViewCell : UITableViewCell

@property(strong, nonatomic) myConcernedView *myConView;

-(void)cellConfig:(CGRect)frame datadic:(NSMutableDictionary *)dic;
@end
