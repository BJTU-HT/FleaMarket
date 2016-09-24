//
//  SecondhandFilterCell.h
//  FleaMarket
//
//  Created by tom555cat on 16/9/22.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolGroupModel.h"

@interface SecondhandFilterCell : UITableViewCell

@property (nonatomic, strong) SchoolGroupModel *groupM;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withFrame:(CGRect)frame;

@end
