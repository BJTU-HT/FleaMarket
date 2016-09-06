//
//  LeaveMessageVC.h
//  FleaMarket
//
//  Created by Hou on 8/9/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "publicSearchBLDelegate.h"
#import "bookPassDicDelegate.h"
#import "bookDetailVC.h"

@interface LeaveMessageVC : UIViewController<UITextViewDelegate, publicSearchBLDelegate, bookPassDicDelegate>

@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) UILabel *labelText;
@property(nonatomic, strong) UIButton *pubMesBtn;
@property(nonatomic, strong) NSMutableDictionary *mudicLM;
@property(nonatomic, strong) NSMutableArray *contentArrMu;
@property(nonatomic, strong) NSMutableDictionary *mudicContentTemp;
@property(nonatomic, strong) NSMutableDictionary *mudicNative;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorViewLM;
@property (nonatomic, weak) id<bookPassDicDelegate> delegateBPDD;

@end
