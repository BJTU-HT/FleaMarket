//
//  CategoryFilterCell.h
//  FleaMarket
//
//  Created by tom555cat on 16/9/22.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryGroupModel.h"

@interface CategoryFilterCell : UITableViewCell

@property (nonatomic, strong) CategoryGroupModel *groupM;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withFrame:(CGRect)frame;

@end
