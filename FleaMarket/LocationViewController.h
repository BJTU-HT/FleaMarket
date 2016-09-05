//
//  LocationViewController.h
//  RW_DropdownMenu
//
//  Created by tom555cat on 16/5/19.
//  Copyright © 2016年 RyanWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConditionDoubleTableView.h"

@protocol ChooseLocationDelegate <NSObject>

@optional

- (void)chooseLocation:(NSString *)locationStr;

@end


@interface LocationViewController : UIViewController <ConditionDoubleTableViewDelegate>

@property (weak, nonatomic) id <ChooseLocationDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

@end
