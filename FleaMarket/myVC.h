//
//  myVC.h
//  FleaMarket
//
//  Created by Hou on 4/7/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "passValueForVCDelegate.h"
#import "LogInAndRegistLogicDelegate.h"
#import "myConcernedVC.h"
#import "modifyBackMyVCDelegate.h"

@interface myVC : UIViewController<UITableViewDelegate, UITableViewDataSource, passValueForVCDelegate,LogInAndRegistLogicDelegate, modifyBackMyVCDelegate>
{
    UITableView *myTableView;
}
@property (nonatomic,assign) NSInteger logInStatus;// logIn 1, logOut 0

//@property(weak, nonatomic) id<passValueForVCDelegate> delegate;

@end
