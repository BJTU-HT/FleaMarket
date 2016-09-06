//
//  ModifyPersonalPageVC.h
//  TestDemo1
//
//  Created by Hou on 3/28/16.
//  Copyright © 2016 Hou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogInAndRegistLogicDelegate.h"
#import "passValueForVCDelegate.h"

@interface ModifyPersonalPageVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, LogInAndRegistLogicDelegate, passValueForVCDelegate>

@property (nonatomic, retain) UITableView *tableVieMP;
@property (nonatomic, retain) UIAlertController *sheetAlert;
@property (nonatomic, retain) UILabel *labelAddr;
@property (weak, nonatomic) id<passValueForVCDelegate> delegateVC;
@property (strong, nonatomic) UILabel *labelTagName;
@property (strong, nonatomic) UILabel *labelTagGender;
@property (strong, nonatomic) UILabel *labelTagCity;
@property (strong, nonatomic) UILabel *labelTagPersonalName;
@end
