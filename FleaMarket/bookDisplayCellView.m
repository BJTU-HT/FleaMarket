//
//  bookDisplayCellView.m
//  FleaMarket
//
//  Created by Hou on 7/28/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "bookDisplayCellView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation bookDisplayCellView

-(instancetype)init{
    self = [super init];
    if(self){
        if(!_bookImageView){
            _bookImageView = [[UIImageView alloc] init];
            [self addSubview: _bookImageView];
        }
        if(!_bookNameLabel){
            _bookNameLabel = [[UILabel alloc] init];
            [self addSubview: _bookNameLabel];
            _bookNameLabel.font = FontSize16;
            _bookNameLabel.numberOfLines = 0;
            _bookNameLabel.textColor = [UIColor blackColor];
        }
        //press house and author use the same label to combine text
        if(!_bookAuthorLabel){
            _bookAuthorLabel = [[UILabel alloc] init];
            _bookAuthorLabel.numberOfLines = 0;
            [self addSubview:_bookAuthorLabel];
            _bookAuthorLabel.font = FontSize14;
            _bookAuthorLabel.textColor = [UIColor grayColor];
        }
        if(!_oriPriceLabel){
            _oriPriceLabel = [[UILabel alloc] init];
            _oriPriceLabel.font = FontSize14;
            _oriPriceLabel.textColor = [UIColor grayColor];
            _oriPriceLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview: _oriPriceLabel];
            
        }
        if(!_sellPriceLabel){
            _sellPriceLabel = [[UILabel alloc] init];
            _sellPriceLabel.textColor = orangColorPCH;
            _sellPriceLabel.font = FontSize16;
            [self addSubview:_sellPriceLabel];
        }
        if(!_remarkLabel){
            _remarkLabel = [[UILabel alloc] init];
            [self addSubview: _remarkLabel];
            _remarkLabel.font = FontSize14;
            _remarkLabel.textColor = [UIColor grayColor];
        }
        if(!_depreciateLabel){
            _depreciateLabel = [[UILabel alloc] init];
            [self addSubview: _depreciateLabel];
            _depreciateLabel.font =FontSize14;
            _depreciateLabel.textColor = [UIColor grayColor];
            _depreciateLabel.textAlignment = NSTextAlignmentRight;
        }
        if(!_viewLine1){
            _viewLine1 = [[UIView alloc] init];
            [self addSubview:_viewLine1];
            _viewLine1.backgroundColor = [UIColor grayColor];
        }
    }
    return self;
}
//[imageViewHead sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:@"icon_default_face@2x"]];
-(CGFloat)layoutViewSelf:(NSMutableDictionary *)mudic{
    [super layoutSubviews];
    
    float margin = 10;
    float marginWidth = 15;
    //float height = self.frame.size.height;
    float width = screenWidthPCH;;
    float verticalMargin1 = 15;
    float verticalMargin2 = 20;
    float bookImageWidth = 0.25 * width;
    float bookImage_x = 15;
    
    float bookName_x = bookImageWidth + marginWidth + bookImage_x;
    float bookName_y = margin;
    float bookNameWidth = width - bookName_x - marginWidth;
    
    _bookNameLabel.text = [mudic objectForKey:@"bookName"];
    CGSize titleSize = [_bookNameLabel.text boundingRectWithSize:CGSizeMake(bookImageWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    _bookNameLabel.frame = CGRectMake(bookName_x, bookName_y, bookNameWidth, titleSize.height);
    
    NSString *strAuthor = [NSString stringWithString:[mudic objectForKey:@"author"]];
    NSString *strAuthorAppend = [strAuthor stringByAppendingString:@" I "];
    NSString *strAuthorAndPress = [strAuthorAppend stringByAppendingString:[mudic objectForKey:@"pressHouse"]];
    _bookAuthorLabel.text = strAuthorAndPress;
    float _bookAuthor_x = bookName_x;
    float _bookAuthor_y = bookName_y + titleSize.height + verticalMargin1;
    float _bookAuthorWidth = bookNameWidth;
    CGSize titleSizeAuthor = [_bookAuthorLabel.text boundingRectWithSize:CGSizeMake(_bookAuthorWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    _bookAuthorLabel.frame = CGRectMake(_bookAuthor_x, _bookAuthor_y, _bookAuthorWidth, titleSizeAuthor.height);
    
    float sellLabelHeight = 20;
    float sellPrice_x = bookName_x;
    float sellPrice_y = _bookAuthor_y + titleSizeAuthor.height + verticalMargin2;
    float sellPriceHeight = sellLabelHeight;
    float sellPriceWidth = screenWidthPCH * 0.2;
    NSString *str1 = @"¥";
    _sellPriceLabel.frame = CGRectMake(sellPrice_x, sellPrice_y, sellPriceWidth, sellPriceHeight);
    if([mudic objectForKey:@"sellPrice"]){
        _sellPriceLabel.text = [str1 stringByAppendingString:[mudic objectForKey:@"sellPrice"]];
    }else if([mudic objectForKey:@"borrowPrice"]){
        _sellPriceLabel.text = [str1 stringByAppendingString:[mudic objectForKey:@"borrowPrice"]];
    }else if([mudic objectForKey:@"buyPrice"]){
        _sellPriceLabel.text = [str1 stringByAppendingString:[mudic objectForKey:@"buyPrice"]];
    }else{
        _sellPriceLabel.text = [str1 stringByAppendingString:@"赠送"];
    }
    
    float originalPrice_x = sellPrice_x + sellPriceWidth;
    float originalPrice_y = sellPrice_y;
    float originalPriceWidth = screenWidthPCH * 0.10;
    float originalPriceHeight = sellLabelHeight;
    NSString *str = @"¥";
    _oriPriceLabel.text = [str stringByAppendingString:[mudic objectForKey:@"originalPrice"]];
    _oriPriceLabel.frame = CGRectMake(originalPrice_x, originalPrice_y, originalPriceWidth, originalPriceHeight);
    
    float viewLine1Height = 1.0;
    float viewLine1_y = originalPrice_y + originalPriceHeight/2 - viewLine1Height/2;
    _viewLine1.frame =CGRectMake(originalPrice_x, viewLine1_y, originalPriceWidth, viewLine1Height);
    
    float labelHeight = 15;
    float remark_x = bookName_x;
    float remark_y = sellPrice_y + sellPriceHeight + verticalMargin1;
    float remarkWidth = bookNameWidth/2;
    float remarkHeight = labelHeight;
    _remarkLabel.frame = CGRectMake(remark_x, remark_y, remarkWidth, remarkHeight);
    _remarkLabel.text = @"评论:0";
    
    float depre_x = remark_x + remarkWidth;
    float depre_y = remark_y;
    float depreWidth = remarkWidth;
    float depreHeight = labelHeight;
    _depreciateLabel.frame = CGRectMake(depre_x, depre_y, depreWidth, depreHeight);
    _depreciateLabel.text = [mudic objectForKey:@"depreciate"];
    
    float imageHeight = depre_y + depreHeight - margin;
    _bookImageView.frame = CGRectMake(bookImage_x, margin, bookImageWidth, 105);
    dispatch_async(dispatch_get_main_queue(), ^{
        [_bookImageView sd_setImageWithURL:[NSURL URLWithString:[mudic objectForKey:@"bookImageURL"]] placeholderImage:[UIImage imageNamed:@"icon_default_face@2x"]];

    });
    float viewHeight = imageHeight + 2 * margin;
    return viewHeight;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
