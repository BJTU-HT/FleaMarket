//
//  ItemCategoryViewController.h
//  FleaMarket
//
//  Created by tom555cat on 16/6/17.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConditionDoubleTableView.h"

@protocol ChooseCategoryDelegate <NSObject>

@optional

- (void)chooseCategory:(NSString *)mainCategory
              category:(NSString *)category;

@end

@interface ItemCategoryViewController : UIViewController <ConditionDoubleTableViewDelegate>

@property (weak, nonatomic) id <ChooseCategoryDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

@end
