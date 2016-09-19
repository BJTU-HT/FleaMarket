//
//  VisitorsCell.m
//  FleaMarket
//
//  Created by tom555cat on 16/9/15.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "VisitorsCell.h"
#import "UIImageView+WebCache.h"

@implementation VisitorsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier visitorArray:(NSMutableArray *)visitorArray
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat margin = 10;
        CGFloat iconWH = 30;
        CGFloat gap = (screenWidthPCH - 2 * margin - iconWH * MaxVisitorURLsKeep) / (MaxVisitorURLsKeep - 1);
        
        for (int i = 0; i < [visitorArray count]; i++) {
            CGFloat x = margin + iconWH * i + gap * i;
            CGFloat y = margin / 2.0f;
            UIImageView *visitorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, iconWH, iconWH)];
            [visitorImageView sd_setImageWithURL:[NSURL URLWithString:visitorArray[i]]];
            [self addSubview:visitorImageView];
        }
    }
    
    return self;
}

@end
