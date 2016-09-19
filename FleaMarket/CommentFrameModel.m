//
//  CommentFrameModel.m
//  FleaMarket
//
//  Created by tom555cat on 16/9/17.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "CommentFrameModel.h"

@implementation CommentFrameModel

+ (instancetype)frameModelWithModel:(SecondhandMessageVO *)model
{
    return [[self alloc] initWithModel:model];
}

+ (NSMutableArray *)frameModelWithArray:(NSMutableArray *)arr
{
    NSMutableArray *data = [NSMutableArray array];
    for (SecondhandMessageVO *model in arr) {
        CommentFrameModel *frameModel = [self frameModelWithModel:model];
        [data addObject:frameModel];
    }
    
    return data;
}

- (instancetype)initWithModel:(SecondhandMessageVO *)model
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
        CGFloat iconWH = 20;
        self.iconFrame = CGRectMake(iconX, iconY, iconWH, iconWH);
        
        // 姓名
        NSDictionary *nameAttrs = @{NSFontAttributeName : FontSize14};
        CGSize nameSize = [self.model.userName sizeWithAttributes:nameAttrs];
        CGFloat nameY = iconY + iconWH/2.0f - nameSize.height/2.0f;
        CGFloat nameX = CGRectGetMaxX(self.iconFrame) + margin;
        self.nameFrame = (CGRect){{nameX, nameY}, nameSize};
        
        // 发布时间
        NSDictionary *publishTimeAttrs = @{NSFontAttributeName : FontSize12};
        CGSize publishTimeSize = [self.model.publishTime sizeWithAttributes:publishTimeAttrs];
        CGFloat publishTimeY = iconY + iconWH/2.0f - publishTimeSize.height/2.0f;
        CGFloat publishTimeX = winSize.width - margin - publishTimeSize.width;
        self.publishTimeFrame = (CGRect){{publishTimeX, publishTimeY}, publishTimeSize};
        
        // 留言  [需要后续修改]
        CGFloat messageX = margin;
        CGFloat messageY = CGRectGetMaxY(self.iconFrame) + margin/2.0f;
        CGFloat messageW = winSize.width - margin * 2.0f;
        CGFloat messageH = 30;
        self.messageFrame = CGRectMake(messageX, messageY, messageW, messageH);
        
        CGRect txtFrame = self.messageFrame;
        self.messageFrame = CGRectMake(messageX, messageY, messageW,
                                       txtFrame.size.height =[_model.content boundingRectWithSize:
                                                              CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
                                                                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                       attributes:[NSDictionary dictionaryWithObjectsAndKeys:FontSize12,NSFontAttributeName, nil] context:nil].size.height);
        self.messageFrame = CGRectMake(messageX, messageY, messageW, txtFrame.size.height);
        
        _cellHeight = CGRectGetMaxY(self.messageFrame) + margin/2.0f;
    }
    
    return _cellHeight;
}


@end
