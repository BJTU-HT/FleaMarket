//
//  SecondhandFrame.m
//  FleaMarket
//
//  Created by tom555cat on 16/3/28.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "SecondhandFrameModel.h"
#import "Help.h"

@implementation SecondhandFrameModel

+(instancetype)frameModelWithModel:(SecondhandVO *)model
{
    return [[self alloc] initWithModel:model];
}

+(NSMutableArray *)frameModelWithArray:(NSMutableArray *)arr
{
    NSMutableArray *data = [NSMutableArray array];
    for (SecondhandVO *model in arr) {
        SecondhandFrameModel *newFrameModel = [self frameModelWithModel:model];
        [data addObject:newFrameModel];
    }
    return data;
}


- (instancetype)initWithModel:(SecondhandVO *)model
{
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

- (CGFloat)cellHeight
{
    if (_cellHeight == 0) {
        CGSize winSize = [UIScreen mainScreen].bounds.size;
        CGFloat margin = 10;
        
        // 头像
        CGFloat iconX = margin;
        CGFloat iconY = margin;
        CGFloat iconWH = 30;
        self.iconFrame = CGRectMake(iconX, iconY, iconWH, iconWH);
        
        // 姓名
        CGFloat nameY = iconY;
        CGFloat nameX = CGRectGetMaxX(self.iconFrame) + margin;
        NSDictionary *nameAttrs = @{NSFontAttributeName : FontSize14};
        CGSize nameSize = [self.model.userName sizeWithAttributes:nameAttrs];
        self.nameFrame = (CGRect){{nameX, nameY}, nameSize};
        
        //20161121 add by hou report function
        CGFloat report_x = screenWidthPCH - margin - 80.0f;
        CGFloat report_y = nameY;
        CGFloat report_w = 80.0f;
        CGFloat report_h = 20.0f;
        self.reportLabelFrame = CGRectMake(report_x, report_y, report_w, report_h);
        
        // 性别
        CGFloat sexY = iconY;
        CGFloat sexX = CGRectGetMaxX(self.nameFrame) + margin/2.0f;
        CGFloat sexWH = nameSize.height;
        self.sexFrame = CGRectMake(sexX, sexY, sexWH, sexWH);
        
        // 发布时间
        NSDictionary *publishAttrs = @{NSFontAttributeName : FontSize12};
        CGSize publishSize = [self.model.publishTime sizeWithAttributes:publishAttrs];
        CGFloat publishY = CGRectGetMaxY(self.iconFrame) - publishSize.height;
        CGFloat publishX = CGRectGetMaxX(self.iconFrame) + margin;
        self.publishTimeFrame = (CGRect){{publishX, publishY}, publishSize};
        
        // 学校
        NSDictionary *schoolAttrs = @{NSFontAttributeName : FontSize14};
        CGSize schoolSize = [self.model.school sizeWithAttributes:schoolAttrs];
        CGFloat schoolY = iconY + iconWH/2.0f - schoolSize.height/2.0f;
        CGFloat schoolX = winSize.width - schoolSize.width - margin;
        self.schoolFrame = (CGRect){{schoolX, schoolY}, schoolSize};
        
        
        // 配图
        CGFloat pictureX = 0;
        CGFloat pictureY = CGRectGetMaxY(self.iconFrame) + margin/2.0f;
        CGFloat pictureH = 121.67f;
        self.pictureFrame = CGRectMake(pictureX, pictureY, winSize.width, pictureH);
        
        CGFloat pictureMargin = 5.0f;
        CGFloat pictureW = (winSize.width - 4.0f * pictureMargin) / 3.0f;
        pictureX = pictureMargin;
        pictureH = pictureW;
        if ([_model.pictureArray count] >= 2) {
            _picture1Frame = CGRectMake(pictureX, pictureY, pictureW, pictureH);
            _picture2Frame = CGRectMake(pictureX+pictureW+pictureMargin, pictureY, pictureW, pictureH);
            _picture3Frame = CGRectMake(pictureX+2.0f*pictureW+2.0f*pictureMargin, pictureY, pictureW, pictureH);
        } else {
            _picture1Frame = CGRectMake(pictureX, pictureY, winSize.width*0.7f, pictureH);
        }
        
        // 文字描述
        CGFloat descriptionH = 30;
        CGFloat descriptionX = margin;
        CGFloat descriptionY = CGRectGetMaxY(self.pictureFrame) + margin/2.0f;
        self.descriptionFrame = CGRectMake(descriptionX, descriptionY, winSize.width-margin*2.0f, descriptionH);
        
        // 分隔线
        CGFloat partLineX = margin;
        CGFloat partLineY = CGRectGetMaxY(self.descriptionFrame) + margin/4.0f;
        self.partLineFrame = CGRectMake(partLineX, partLineY, winSize.width - 2.0f*margin, 0.5f);
        
        // 地址
        CGFloat locationX = iconX;
        CGFloat locationY = CGRectGetMaxY(self.partLineFrame) + margin;
        NSDictionary *locationAttrs = @{NSFontAttributeName : FontSize14};
        CGSize locationSize = [self.model.school sizeWithAttributes:locationAttrs];
        self.locationFrame = (CGRect){{locationX, locationY}, locationSize};
        
        // 价格
        NSDictionary *priceAttrs = @{NSFontAttributeName : FontSize14};
        CGSize priceSize = [[NSString stringWithFormat:@"￥%.1f", self.model.nowPrice] sizeWithAttributes:priceAttrs];
        CGFloat priceY = CGRectGetMaxY(self.partLineFrame) + margin;
        CGFloat priceX = winSize.width - priceSize.width - margin;
        self.priceFrame = (CGRect){{priceX, priceY}, priceSize};
        
        // cell间隔
        CGFloat cellPartX = 0;
        CGFloat cellPartY = CGRectGetMaxY(self.locationFrame) + margin;
        CGFloat cellPartH = HTPartBar;
        self.cellPartFrame = CGRectMake(cellPartX, cellPartY, winSize.width, cellPartH);
        
        _cellHeight = CGRectGetMaxY(self.cellPartFrame);
        
    }
    
    return _cellHeight;
}

@end
