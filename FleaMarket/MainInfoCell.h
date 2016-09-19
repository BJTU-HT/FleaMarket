//
//  MainInfoCell.h
//  FleaMarket
//
//  Created by tom555cat on 16/9/15.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondhandVO.h"
#import "MainInfoFrameModel.h"

@interface MainInfoCell : UITableViewCell

@property (nonatomic, strong) SecondhandVO *model;
@property (nonatomic, strong) MainInfoFrameModel *frameModel;

@end
