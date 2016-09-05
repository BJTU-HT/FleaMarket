//
//  CommentFooterView.m
//  FleaMarket
//
//  Created by tom555cat on 16/5/9.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "CommentFooterView.h"

@interface CommentFooterView  ()

@property (strong, nonatomic) UIActivityIndicatorView *loadingView;


@end

@implementation CommentFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor yellowColor];
        
        // 按钮
        NSMutableAttributedString *btnAttributeString = [[NSMutableAttributedString alloc] initWithString:@"点击加载更多评论" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:@"Verdana-Bold" size:25]}];
        
        UIButton *loadBtn = [[UIButton alloc] init];
        [loadBtn addTarget:self action:@selector(loadBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        loadBtn.hidden = NO;
        [loadBtn setAttributedTitle:btnAttributeString forState:UIControlStateNormal];
        [self addSubview:loadBtn];
        self.loadBtn = loadBtn;
        
        // 显示菊花
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.tintColor = [UIColor blackColor];
        loadingView.hidden = YES;
        loadingView.hidesWhenStopped = YES;
        [self addSubview:loadingView];
        self.loadingView = loadingView;
    }
    
    return self;
}

- (void)loadBtnClicked
{
    [self bringSubviewToFront:self.loadingView];
    self.loadBtn.hidden = YES;
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 加载更多操作
        [self.delegate loadMoreComment];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [self.loadingView stopAnimating];
            self.loadingView.hidden = YES;
            self.loadBtn.hidden = NO;
        });
    });
    
    /*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //
        
        
        // 隐藏菊花
        [self.loadingView stopAnimating];
        self.loadingView.hidden = YES;
        // 显示按钮
        self.loadBtn.hidden = NO;
    });
     */
}

- (void)layoutSubviews
{
    // 按钮frame
    CGFloat loadBtnX = 0;
    CGFloat loadBtnY = 0;
    CGFloat loadBtnWidth = self.frame.size.width;
    CGFloat loadBtnHight = self.frame.size.height;
    self.loadBtn.frame = CGRectMake(loadBtnX, loadBtnY, loadBtnWidth, loadBtnHight);
    
    // 菊花
    CGFloat loadingViewHeight = self.frame.size.height / 2.0f;
    CGFloat loadingViewWidth = loadingViewHeight;
    CGFloat loadingViewX = self.frame.size.width / 2.0f - loadingViewWidth / 2.0f;
    CGFloat loadingViewY = self.frame.size.height / 2.0f - loadingViewHeight / 2.0f;
    self.loadingView.frame = CGRectMake(loadingViewX, loadingViewY, loadingViewWidth, loadingViewHeight);
}


@end
