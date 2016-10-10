//
//  bookSecondPageBottomView.m
//  FleaMarket
//
//  Created by Hou on 8/12/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "bookSecondPageBottomView.h"

@implementation bookSecondPageBottomView

-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        if(!_remarkBtnBS){
            _remarkBtnBS = [[UIButton alloc] init];
            [_remarkBtnBS setTitle:@"评论" forState:UIControlStateNormal];
            [_remarkBtnBS setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_remarkBtnBS setBackgroundColor:[UIColor orangeColor]];
            _remarkBtnBS.titleLabel.font = FontSize18;
            [self addSubview:_remarkBtnBS];
        }
        if(!_shareBtnBS){
            _shareBtnBS = [[UIButton alloc] init];
            [_shareBtnBS setTitle:@"分享" forState:UIControlStateNormal];
            [_shareBtnBS setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _shareBtnBS.titleLabel.font = FontSize18;
            //[self addSubview:_shareBtnBS];
        }
        if(!_wantedBtnBS){
            _wantedBtnBS = [[UIButton alloc] init];
            [_wantedBtnBS setTitle:@"我想要" forState:UIControlStateNormal];
            [_wantedBtnBS setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_wantedBtnBS setBackgroundColor:[UIColor redColor]];
            _wantedBtnBS.titleLabel.font = FontSize18;
            [self addSubview:_wantedBtnBS];
        }
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)layoutSubviews{
    
    float btnWidth = self.frame.size.width/2.0;
    float btnHeight = self.frame.size.height;
    
    self.remarkBtnBS.frame = CGRectMake(0, 0, btnWidth, btnHeight);
    //self.shareBtnBS.frame = CGRectMake(btnWidth, 0, btnWidth, btnHeight);
    self.wantedBtnBS.frame = CGRectMake(btnWidth, 0, btnWidth, btnHeight);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
