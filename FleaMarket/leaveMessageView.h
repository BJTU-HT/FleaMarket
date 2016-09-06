//
//  leaveMessageView.h
//  FleaMarket
//
//  Created by Hou on 8/10/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface leaveMessageView : UIView

@property(nonatomic, strong) UIImageView *headImageLM;
@property(nonatomic, strong) UILabel *userLabelLM;
@property(nonatomic, strong) UILabel *timeLabelLM;
@property(nonatomic, strong) UILabel *contentLabelLM;

-(CGFloat)layoutSubviews:(NSDictionary *)dic;
@end
