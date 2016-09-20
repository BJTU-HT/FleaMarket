//
//  SecondCateDisplayVC.h
//  FleaMarket
//
//  Created by Hou on 9/19/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondhandBL.h"
#import "SecondhandFrameModel.h"
#import "UserMO.h"
#import "SecondhandCell.h"
#import "UserInfoSingleton.h"
#import "SecondhandDetailVC.h"
#import "SecondhandBLDelegate.h"
#import "passValueForVCDelegate.h"
#import "WJRefresh.h"

@interface SecondCateDisplayVC : UIViewController<passValueForVCDelegate, UITableViewDelegate, UITableViewDataSource, SecondhandBLDelegate>

@property(nonatomic, strong) UITableView *tableViewCateDisplay;
@property(nonatomic, strong) NSMutableDictionary *filterDic;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSMutableArray *frameArray;
@property(nonatomic, strong) SecondhandBL *bl;
// 刷新view
@property (nonatomic, strong) WJRefresh *refresh;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
// 当前选中的商品分类
@property (nonatomic, strong) NSString *currentCate;
// 当前选中的学校
@property (nonatomic, strong) NSString *currentSchool;
@end
