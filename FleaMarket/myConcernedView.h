//
//  myConcernedView.h
//  FleaMarket
//
//  Created by Hou on 9/12/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myConcernedView : UIView

@property(nonatomic, strong) UIImageView *headImageViewMC;
@property(nonatomic, strong) UILabel *labelNameMC;
@property(nonatomic, strong) UILabel *labelSchoolMC;
@property(nonatomic, strong) UIButton *btnSendMessageMC;

-(instancetype)initWithFrame:(CGRect)frame para: (NSMutableDictionary *)mudic;
@end
