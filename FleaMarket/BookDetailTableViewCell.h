//
//  BookDetailTableViewCell.h
//  FleaMarket
//
//  Created by Hou on 8/2/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bookDetailView.h"
#import "leaveMessageView.h"

@interface BookDetailTableViewCell : UITableViewCell


@property(nonatomic, strong) bookDetailView *bookDetail;
@property(nonatomic, strong) leaveMessageView *lmView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier index: (NSIndexPath *)indexPath;
-(CGFloat)configCellBook:(CGRect)frame index:(NSIndexPath *)indexPath data:(NSMutableDictionary *)mudic;
@end
