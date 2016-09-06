//
//  pullRefreshView.m
//  FleaMarket
//
//  Created by Hou on 8/30/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "pullRefreshView.h"

@implementation pullRefreshView

-(instancetype)initWithFrame:(CGRect)frame refreshLocation: (BOOL) top{
    self = [super initWithFrame: frame];
    if(self){
        self.atTop = top;
        self.arrowImageView.frame = CGRectMake(0, 0, 20, 20);
        self.stateLabel.textAlignment = NSTextAlignmentCenter;
        self.stateLabel.font = FontSize12;
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.font = FontSize12;
        
        self.arrow.contentsGravity = kCAGravityResizeAspect;
        _arrow.contents = (id)[UIImage imageWithCGImage:[UIImage imageNamed:@"blueArrow.png"].CGImage scale:1 orientation:UIImageOrientationDown].CGImage;
    }
    [self.layer addSublayer: self.arrow];
    [self addSubview: self.stateLabel];
    [self addSubview: self.timeLabel];
    [self addSubview: self.activityView];
    return self;
}

-(void)layout{
    float margin = 10.0f;
    float labelHeight = 20.0f;
    float width = self.frame.size.width;
    //float height = self.frame.size.height;
    
    //if(self.isAtTop){
        //NSLog(@"test");
        float image_x = 2 * margin;
        float image_y = margin;
        float image_w = 40.0f;
        float image_h = 40.0f;
        
        self.arrowImageView.frame = CGRectMake(image_x, image_y, image_w, image_h);
        
        float state_x = image_x + image_w + margin;
        float state_y = image_y;
        float state_w = width - state_x - margin;
        float state_h = labelHeight;
        
        self.stateLabel.frame = CGRectMake(state_x, state_y, state_w, state_h);
        
        float time_x = state_x;
        float time_y = state_y + state_h + margin;
        float time_w = state_w;
        float time_h = state_h;
        
        self.stateLabel.frame = CGRectMake(time_x, time_y, time_w, time_h);
    //}
    if(self.isAtTop){
        self.stateLabel.text = @"下拉刷新";
    }else{
        self.stateLabel.text = @"上拉加载更多";
    }
}

- (void)setState:(PRState)state {
    [self setState:state animated:YES];
}

- (void)setState:(PRState)state animated:(BOOL)animated{
    float duration = animated ? 0.18f : 0.f;
    if (_state != state) {
        _state = state;
        if (_state == kPRStateLoading) {    //Loading
            
            _arrow.hidden = YES;
            _activityView.hidden = NO;
            [_activityView startAnimating];
            
            _loading = YES;
            if (self.isAtTop) {
                _stateLabel.text = @"正在刷新";
            } else {
                _stateLabel.text = @"正在加载";
            }
            
        } else if (_state == kPRStatePulling && !_loading) {    //Scrolling
            
            _arrow.hidden = NO;
            _activityView.hidden = YES;
            [_activityView stopAnimating];
            
            [CATransaction begin];
            [CATransaction setAnimationDuration:duration];
            _arrow.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            [CATransaction commit];
            
            if (self.isAtTop) {
                _stateLabel.text = @"释放刷新";
            } else {
                _stateLabel.text = @"释放加载更多";
            }
            
        } else if (_state == kPRStateNormal && !_loading){    //Reset
            
            _arrow.hidden = NO;
            _activityView.hidden = YES;
            [_activityView stopAnimating];
            
            [CATransaction begin];
            [CATransaction setAnimationDuration:duration];
            _arrow.transform = CATransform3DIdentity;
            [CATransaction commit];
            
            if (self.isAtTop) {
                _stateLabel.text = @"下拉刷新";
            } else {
                _stateLabel.text = @"下拉加载更多";
            }
        } else if (_state == kPRStateHitTheEnd) {
            if (!self.isAtTop) {    //footer
                _arrow.hidden = YES;
                _stateLabel.text = @"没有了哦";
            }
        }
    }
}


#pragma ---getter and setter method for property begin------------
-(UIImageView *)arrowImageView{
    if(!_arrowImageView){
        _arrowImageView = [[UIImageView alloc] init];
    }
    return _arrowImageView;
}

-(UILabel *)stateLabel{
    if(!_stateLabel){
        _stateLabel = [[UILabel alloc] init];
    }
    return _stateLabel;
}

-(UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
    }
    return _timeLabel;
}

-(CALayer *)arrow{
    if(!_arrow){
        _arrow = [CALayer layer];
    }
    return _arrow;
}

-(UIActivityIndicatorView *)activityView{
    if(!_activityView){
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityView;
}
#pragma ---getter and setter method for property end--------------

@end
