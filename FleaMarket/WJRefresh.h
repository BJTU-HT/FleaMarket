//
//  WJRefresh.h
//  WJRefresh
//
//  Created by 吴计强 on 16/4/6.
//  Copyright © 2016年 com.firsttruck. All rights reserved.
//
typedef void(^refreshBlock)();
#import <UIKit/UIKit.h>

@interface WJRefresh : UIView

/** 添加WJRefresh控件到tableview上面 */
- (void)addHeardRefreshTo:(UIScrollView *)tableView heardBlock:(refreshBlock)heardBlock footBlok:(refreshBlock)footBlock;

/** 开始头部刷新 */
- (void)beginHeardRefresh;

/** 结束头部刷新 */
- (void)endRefresh;

/** 下拉刷新对应的block */
@property (nonatomic,copy)   refreshBlock heardRefresh;

/** 上拉加载对应的block*/
@property (nonatomic,copy)   refreshBlock footRefresh;

@end
