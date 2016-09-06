//
//  pullRefreshView.h
//  FleaMarket
//
//  Created by Hou on 8/30/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pullRefreshView : UIView

typedef enum {
    kPRStateNormal = 0,
    kPRStatePulling = 1,
    kPRStateLoading = 2,
    kPRStateHitTheEnd = 3
} PRState;

@property(nonatomic, strong) UIImageView *arrowImageView;
@property(nonatomic, strong) UILabel *stateLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) CALayer *arrow;
@property(nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic,getter = isLoading) BOOL loading;
@property (nonatomic,getter = isAtTop) BOOL atTop;
@property (nonatomic) PRState state;
- (void)setState:(PRState)state;
@end
