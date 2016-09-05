//
//  MessageCell.h
//  FleaMarket
//
//  Created by tom555cat on 16/4/14.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondhandMessageVO.h"
#import "MessageFrameModel.h"

@interface MessageCell : UITableViewCell

@property (nonatomic, strong) SecondhandMessageVO *model;

@property (nonatomic, strong) MessageFrameModel *frameModel;

@end
