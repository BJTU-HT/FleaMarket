//
//  CommentCell.h
//  FleaMarket
//
//  Created by tom555cat on 16/9/15.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondhandMessageVO.h"
#import "CommentFrameModel.h"

@interface CommentCell : UITableViewCell

@property (nonatomic, strong) SecondhandMessageVO *model;
@property (nonatomic, strong) CommentFrameModel *frameModel;

@end
