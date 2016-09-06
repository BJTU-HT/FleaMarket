//
//  BookPublishVC.h
//  FleaMarket
//
//  Created by Hou on 7/20/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookPubView.h"
#import "CategoryView.h"
#import "BookPublishDelegate.h"
#import "bookPubUpLoadInfoBL.h"

@interface BookPublishVC : UIViewController<UIGestureRecognizerDelegate, BookPublishDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, bookPubUpLoadInfoBLDelegate>

@property (strong, nonatomic) CategoryView *cateView1;
@property (strong, nonatomic) BookPubView *pubView;
@property (strong, nonatomic) UIScrollView *scrollViewPub;
@property (strong, nonatomic) UIView *view1;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) UIView *viewLine;
@property (strong, nonatomic) UIButton *sellBtn;
@property (strong, nonatomic) UIButton *buyBtn;
@property (strong, nonatomic) UIButton *donateBtn;
@property (strong, nonatomic) UIButton *borrowBtn;
@property (strong, nonatomic) NSMutableDictionary *muDicBigger;
@property (strong, nonatomic) NSMutableDictionary *muDicSell;
@property (strong, nonatomic) NSMutableDictionary *muDicBuy;
@property (strong, nonatomic) NSMutableDictionary *muDicBorrow;
@property (strong, nonatomic) NSMutableDictionary *muDicPresent;
@end
