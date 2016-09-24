//
//  SecondhandFilterView.h
//  FleaMarket
//
//  Created by tom555cat on 16/9/22.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SecondhandFilterDelegate <NSObject>

@optional

/**
 *  点击tableview，过滤id
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withId:(NSNumber *)ID withName:(NSString *)name;

@end

@interface SecondhandFilterView : UIView

@property (nonatomic, strong) UITableView *tableViewOfGroup;
@property (nonatomic, strong) UITableView *tableViewOfDetail;

@property (nonatomic, assign) id <SecondhandFilterDelegate> delegate;

@end
