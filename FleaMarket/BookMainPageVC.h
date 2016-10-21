//
//  BookMainPageVC.h
//  FleaMarket
//
//  Created by Hou on 7/28/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryView.h"
#import "findBookInfoBLDelegate.h"
#import "findBookInfoBL.h"
#import "bookDetailVC.h"
#import "bookMainToSecondDelegate.h"
#import "BookPublishDelegate.h"
#import "WJRefresh.h"
#import "searchBookDelegate.h"
#import "MJRefresh.h"
#import "dataDic.h"

@interface BookMainPageVC : UIViewController<UISearchBarDelegate, findBookInfoBLDelegate, UITableViewDelegate, UITableViewDataSource, BookPublishDelegate, searchBookDelegate>

@property(nonatomic, strong)NSMutableDictionary *mudicBM;
@property(nonatomic, weak) id<bookMainToSecondDelegate> delegateM2S;
@property(nonatomic, strong) findBookInfoBL *findBookBL;
@property(strong, nonatomic) CategoryView *cateViewBookMain;
@property(strong, nonatomic) NSMutableArray *recMuDic;
@property(strong, nonatomic) UITableView *tableViewBook;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property(nonatomic, strong) UIButton *btnSchool;
@property(nonatomic, strong) UIButton *btnExchangeCate;
@property(nonatomic, strong) UIButton *btnBookCate;
@property(nonatomic, strong) UISearchBar *searchBarBook;
@property(nonatomic, assign) float tableViewHeight;

//20160816 add
@property(strong, nonatomic) NSMutableDictionary *recSearchMudic;
@property(nonatomic, strong) NSMutableArray *muArrTest;
@property(nonatomic, strong) NSString *strTest;

// 刷新view
@property (nonatomic, strong) WJRefresh *refresh;
@end
