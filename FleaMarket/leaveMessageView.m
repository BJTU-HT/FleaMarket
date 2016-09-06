//
//  leaveMessageView.m
//  FleaMarket
//
//  Created by Hou on 8/10/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "leaveMessageView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation leaveMessageView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        if(!self.headImageLM){
            self.headImageLM = [[UIImageView alloc] init];
            [self addSubview:self.headImageLM];
        }
        if(!self.userLabelLM){
            self.userLabelLM = [[UILabel alloc] init];
            [self addSubview:self.userLabelLM];
            self.userLabelLM.textAlignment = NSTextAlignmentLeft;
            self.userLabelLM.font = FontSize12;
            self.userLabelLM.textColor = [UIColor blackColor];
        }
        if(!self.timeLabelLM){
            self.timeLabelLM = [[UILabel alloc] init];
            [self addSubview:self.timeLabelLM];
            self.timeLabelLM.textAlignment = NSTextAlignmentRight;
            self.timeLabelLM.font = FontSize12;
            self.timeLabelLM.textColor = [UIColor grayColor];
        }
        if(!self.contentLabelLM){
            self.contentLabelLM = [[UILabel alloc] init];
            [self addSubview:self.contentLabelLM];
            self.contentLabelLM.font = FontSize14;
            self.contentLabelLM.textColor = [UIColor blackColor];
        }
    }
    return self;
}

-(CGFloat)layoutSubviews:(NSDictionary *)dic{
    [super layoutSubviews];
    
    float marginVertical = 10.0f;
    float marginHorizontal = 5.0f;
    
    //头像采用32x32 label字号12 内容字号14
    float headImage_x = marginHorizontal;
    float headImage_y = marginVertical;
    float headImageHeight = 32.0;
    float headImageWidth = 32.0;
    
    self.headImageLM.frame = CGRectMake(headImage_x, headImage_y, headImageWidth, headImageHeight);
    [self.headImageLM sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatarLM"]] placeholderImage:[UIImage imageNamed:@"icon_default_face@2x"]];
    
    float contentWidth = screenWidthPCH - 3 * marginHorizontal - headImageWidth;
    
    float nameLabel_x = headImage_x + marginHorizontal + headImageWidth;
    float nameLabel_y = headImage_y;
    float nameLabelHeight = 14.0f;
    float nameLabelWidth = contentWidth/2;
    
    self.userLabelLM.frame = CGRectMake(nameLabel_x, nameLabel_y, nameLabelWidth, nameLabelHeight);
    self.userLabelLM.text = [dic objectForKey:@"userName"];
    
    float timeW = contentWidth/2;
    float time_x = screenWidthPCH - marginHorizontal - contentWidth/2;
    float time_y = nameLabel_y;
    float timeHeight = nameLabelHeight;
    
    self.timeLabelLM.frame = CGRectMake(time_x, time_y, timeW, timeHeight);
    self.timeLabelLM.text = [dic objectForKey: @"publishTime"];
    float content_x = nameLabel_x;
    float content_y = marginVertical + nameLabelHeight + 5;
    NSString *toUser = [dic objectForKey:@"to_userName"];
    if(toUser){
        NSString *prefix1 = [@"@" stringByAppendingString:toUser];
        NSString *prefix2 = [prefix1 stringByAppendingString:@": "];
        NSString *prefix3 = [prefix2 stringByAppendingString:[dic objectForKey:@"content"]];
        self.contentLabelLM.text = prefix3;
    }else{
        self.contentLabelLM.text = [dic objectForKey:@"content"];
    }
    
    CGSize contentSize = [self.contentLabelLM.text boundingRectWithSize:CGSizeMake(contentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    if(contentSize.height < 20){
        contentSize.height = 20;
    }
    self.contentLabelLM.frame = CGRectMake(content_x, content_y, contentWidth, contentSize.height);
    
    return 2 * marginVertical + nameLabelHeight + contentSize.height;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
