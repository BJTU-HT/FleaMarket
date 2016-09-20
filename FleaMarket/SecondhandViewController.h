//
//  SecondhandViewController.h
//  FleaMarket
//
//  Created by tom555cat on 16/3/28.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "firstPageSection0Btn.h"
#import "passValueForVCDelegate.h"

@interface SecondhandViewController : UIViewController

@property (nonatomic, weak) id<passValueForVCDelegate> delegate;

@property (nonatomic, unsafe_unretained) BOOL autoLoadMore;

//20160918 add for modify first page
@property(nonatomic, strong) firstPageSection0Btn *cateBtn;

@property(nonatomic, strong) UIView *viewS0;

@end
