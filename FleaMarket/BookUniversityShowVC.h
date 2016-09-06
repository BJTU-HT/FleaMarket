//
//  BookUniversityShowVC.h
//  FleaMarket
//
//  Created by Hou on 7/28/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookPublishDelegate.h"

@interface BookUniversityShowVC : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableViewLeft;
@property(nonatomic, strong) UITableView *tableViewRight;
@property(nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic, strong) NSMutableDictionary *tableData;
@property(nonatomic, strong) NSArray *arrSchool;
@property(nonatomic, weak) id<BookPublishDelegate> delegateUniversity;
@end
