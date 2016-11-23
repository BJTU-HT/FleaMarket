//
//  bookDetailVC.h
//  FleaMarket
//
//  Created by Hou on 8/2/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bookMainToSecondDelegate.h"
#import "publicSearchBL.h"
#import "bookPassDicDelegate.h"
#import "bookSecondPageBottomView.h"
#import <BmobSDK/BmobUser.h>
#import "logInViewController.h"
#import "DetailChatVC.h"
#import "concernBLDelegate.h"
#import "BookDetailTableViewCell.h"
#import "bookDisplayCellViewDelegate.h"

@interface bookDetailVC : UIViewController<UITableViewDelegate, UITableViewDataSource,bookMainToSecondDelegate, publicSearchBLDelegate, bookPassDicDelegate, concernBLDelegate, bookDisplayCellViewDelegate>

@property(nonatomic, strong) UITableView *tableViewBookDetail;
@property(nonatomic, strong) NSMutableDictionary *mudic;
@property(nonatomic, weak) id<bookPassDicDelegate> delegateSecToLM;
@property(nonatomic, strong) bookSecondPageBottomView *bSPBView;
@property(nonatomic, strong) NSString *bookUserObjectId;
@property(nonatomic, strong) BookDetailTableViewCell *bookDetailCell;
@property(nonatomic, strong) UIButton *reportBtn;
@end
