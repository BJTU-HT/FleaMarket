//
//  CommentFooterView.h
//  FleaMarket
//
//  Created by tom555cat on 16/5/9.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FooterViewDelegate

@optional
- (NSMutableArray *)loadMoreComment;

@end

@interface CommentFooterView : UIView

@property (weak, nonatomic) id <FooterViewDelegate> delegate;

@property (strong, nonatomic) UIButton *loadBtn;

@end
