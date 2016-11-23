//
//  bookDetailView.h
//  FleaMarket
//
//  Created by Hou on 8/2/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "concernBLDelegate.h"
#import "concernBL.h"
#import <BmobSDK/BmobUser.h>
#import "bookDetailS1View.h"

@interface bookDetailView : UIView<UIScrollViewDelegate, concernBLDelegate>

@property(nonatomic, weak) id<concernBLDelegate> delegate;
@property(nonatomic, strong) NSMutableDictionary *recMudicBD;
#pragma section 0 property begin
@property(nonatomic, strong) UIView *viewS0;
@property(nonatomic, strong) UIImageView *headImageViewS0;
@property(nonatomic, strong) UILabel *userNameS0;
@property(nonatomic, strong) UILabel *schoolS0;
@property(nonatomic, strong) UIButton *btnConcernS0;
#pragma section 0 property end

#pragma section 1 property begin
@property(nonatomic, strong) bookDetailS1View *bookDisViewS1;
@property(nonatomic, strong) UILabel *labelS1;
#pragma section 1 property end

#pragma section 2 property begin
@property(nonatomic, strong) UIView *viewLineS2;
@property(nonatomic, strong) UILabel *labelS2;
@property(nonatomic, strong) UIScrollView *scrollViewS2;
#pragma section 2 property end

#pragma section 3 property begin
@property(nonatomic, strong) UIView *viewLineS3;
@property(nonatomic, strong) UILabel *labelS3;
#pragma section 3 property end

@property(strong, nonatomic) NSString *nameStr;

-(instancetype)initWithFrame:(CGRect)frame index:(NSIndexPath *)indexPath;
-(CGFloat)layoutSubviews:(NSIndexPath *)indexPath data:(NSMutableDictionary *)mudic;

@end
