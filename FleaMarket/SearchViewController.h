//
//  SearchViewController.h
//  FleaMarket
//
//  Created by tom555cat on 16/6/30.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondhandBL.h"

@protocol SearchProductDelegate <NSObject>

- (void)searchSecondhandByKey:(NSString *)keyString;

@end

@interface SearchViewController : UIViewController <SecondhandBLDelegate>

@property (nonatomic, weak) id <SearchProductDelegate> delegate;

@end
