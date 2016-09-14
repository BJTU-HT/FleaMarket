//
//  BookPubView.h
//  FleaMarket
//
//  Created by Hou on 7/20/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookPubView : UIView <UITextFieldDelegate>

@property(nonatomic, strong) UITextField *bookName;
@property(nonatomic, strong) UITextField *author;
@property(nonatomic, strong) UITextField *pressHouse;
@property(nonatomic, strong) UITextField *sellPrice;
@property(nonatomic, strong) UILabel *originalPrice;
@property(nonatomic, strong) UITextField *originalPriceField;
@property(nonatomic, strong) UILabel *amount;
@property(nonatomic, strong) UITextField *amountField;
@property(nonatomic, strong) UILabel *category;
@property(nonatomic, strong) UIButton * categoryBtn;
@property(nonatomic, strong) UILabel *depreciate;
@property(nonatomic, strong) UIButton *depreciateBtn;
@property(nonatomic, strong) UILabel *remark;
@property(nonatomic, strong) UITextField *remarkField;
@property(nonatomic, strong) UILabel *ISBN;
@property(nonatomic, strong) UITextField *ISBNField;
@property(nonatomic, strong) UIButton *bookImageBtn;
@property(nonatomic, strong) UIButton *publishBtn;
@property(nonatomic, strong) UIView *viewLine1;
@property(nonatomic, strong) UIView *viewLine2;
@property(nonatomic, strong) UIView *viewLine3;
@property(nonatomic, strong) UIView *viewLine4;
@property(nonatomic, strong) UIView *viewLine5;
@property(nonatomic, strong) UIView *viewLine6;
@property(nonatomic, strong) UIButton *ISBNClickBtn;
@property(nonatomic, strong) UIView *viewLineOrange;
@property(nonatomic, strong) NSString *fieldStr;

@end
