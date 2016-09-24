//
//  SortView.h
//  FleaMarket
//
//  Created by tom555cat on 16/9/22.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SortDelegate <NSObject>

@optional

- (void)sortTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withId:(NSNumber *)ID withName:(NSString *)name;

@end

@interface SortView : UIView

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) id<SortDelegate> delegate;

@end
