//
//  bookDisplayCellView.h
//  FleaMarket
//
//  Created by Hou on 7/28/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bookDisplayCellView : UIView

//@property(nonatomic, strong) UIImageView *headImageViewBook;
//@property(nonatomic, strong) UILabel *bookUserNameLabel;
//@property(nonatomic, strong) UILabel *bookSchoolLabel;
@property(nonatomic, strong) UIImageView *bookImageView;
@property(nonatomic, strong) UILabel *bookNameLabel;
@property(nonatomic, strong) UILabel *bookAuthorLabel;
@property(nonatomic, strong) UILabel *bookPressLabel;
@property(nonatomic, strong) UILabel *oriPriceLabel;
@property(nonatomic, strong) UILabel *sellPriceLabel;
@property(nonatomic, strong) UILabel *pubTimeLabel;
@property(nonatomic, strong) UILabel *remarkLabel;
@property(nonatomic, strong) UILabel *depreciateLabel;
@property(nonatomic, strong) UIView *viewLine1;
-(CGFloat)layoutViewSelf:(NSMutableDictionary *)mudic;
@end
