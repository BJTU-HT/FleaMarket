//
//  bookUserInfoView.m
//  FleaMarket
//
//  Created by Hou on 7/29/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "bookUserInfoView.h"

@implementation bookUserInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if(self){
        if(!_headImageViewBook){
            _headImageViewBook = [[UIImageView alloc] init];
            [self addSubview:_headImageViewBook];
            
        }
        if(!_bookUserNameLabel){
            _bookUserNameLabel = [[UILabel alloc] init];
            [self addSubview: _bookUserNameLabel];
            _bookUserNameLabel.textAlignment = NSTextAlignmentLeft;
            _bookUserNameLabel.font = FontSize14;
        }
        if(!_pubTimeLabel){
            _pubTimeLabel = [[UILabel alloc] init];
            [self addSubview: _pubTimeLabel];
            _pubTimeLabel.textAlignment = NSTextAlignmentLeft;
            _pubTimeLabel.font = FontSize12;
            _pubTimeLabel.textColor = [UIColor grayColor];
        }
        if(!_bookSchoolLabel){
            _bookSchoolLabel = [[UILabel alloc] init];
            [self addSubview: _bookSchoolLabel];
            _bookSchoolLabel.textAlignment = NSTextAlignmentRight;
            _bookSchoolLabel.font = FontSize14;
            _bookSchoolLabel.textColor = [UIColor blackColor];
        }
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    float height = self.frame.size.height;
    float width = self.frame.size.width;
    
    float margin = 0.1 * height;
    float headImageWidth = height - 2 * margin;
    float headImageHeight = headImageWidth;
    float headImage_x = 15;
    CGRect headImageFrame = CGRectMake(headImage_x, margin, headImageWidth, headImageHeight);
    _headImageViewBook.frame = headImageFrame;
    
    float bookUserName_x = headImageWidth + 2 * margin + headImage_x;
    float bookUserNameWidth = width/2;
    float bookUserNameHeight = 0.4 * height;
    _bookUserNameLabel.frame = CGRectMake(bookUserName_x, margin, bookUserNameWidth, bookUserNameHeight);
    
    float bookPubTime_y = bookUserNameHeight + margin;
    float bookPubTimeHeight = bookUserNameHeight;
    _pubTimeLabel.frame =CGRectMake(bookUserName_x, bookPubTime_y, bookUserNameWidth, bookPubTimeHeight);
    
    float schoolLabel_x = width/2 + bookUserName_x;
    float schoolLabelWidth = width/2 - 15 - bookUserName_x;
    float schoolLabelHeight = 0.4 * height;
    float schoolLabel_y = 0.3 * height;
    
    _bookSchoolLabel.frame = CGRectMake(schoolLabel_x, schoolLabel_y, schoolLabelWidth, schoolLabelHeight);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
