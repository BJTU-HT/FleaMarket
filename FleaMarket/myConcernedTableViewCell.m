//
//  myConcernedTableViewCell.m
//  FleaMarket
//
//  Created by Hou on 9/13/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "myConcernedTableViewCell.h"

@implementation myConcernedTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //[self initSubView];
    }
    return self;
}

-(void)cellConfig:(CGRect)frame datadic:(NSMutableDictionary *)dic{
    if(!_myConView){
        _myConView = [[myConcernedView alloc] initWithFrame:frame para:dic];
    }
    [self.contentView addSubview:_myConView];
}

@end
