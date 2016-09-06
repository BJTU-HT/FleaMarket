//
//  SearchBookVC.h
//  FleaMarket
//
//  Created by Hou on 8/12/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bookMainToSecondDelegate.h"
#import "findBookInfoBL.h"
#import "BookMainPageVC.h"
#import "findBookInfoBLDelegate.h"
#import "searchBookDelegate.h"

@interface SearchBookVC : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource, findBookInfoBLDelegate, bookMainToSecondDelegate>

//transfer value to main page
@property(nonatomic, weak) id<searchBookDelegate> delegateBD;
@property(nonatomic, strong) UISearchBar *searchBarForBook;
@property(nonatomic, strong) UITableView *tableViewBookSearch;
//search record store in native iPhone storage
@property(nonatomic, strong) NSUserDefaults *userDefaultBS;
@property(nonatomic, strong) NSMutableDictionary *readStorageMuDic;
@property(nonatomic, strong) NSMutableDictionary *writeStorageMuDic;
@property(nonatomic, strong) NSMutableArray *muArrBS;
@property(nonatomic, strong) NSMutableDictionary *mudicBS;
@property(nonatomic, strong)findBookInfoBL *findBook;
@property(nonatomic, strong)BookMainPageVC *bookMain;

@end

