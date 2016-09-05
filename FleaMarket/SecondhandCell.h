//
//  SecondhandCell.h
//  FleaMarket
//
//  Created by tom555cat on 16/3/28.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondhandVO.h"
#import "SecondhandFrameModel.h"

@interface SecondhandCell : UITableViewCell

@property (nonatomic, strong) SecondhandVO *model;

@property (nonatomic, strong) SecondhandFrameModel *frameModel;

@end
