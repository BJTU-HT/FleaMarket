//
//  logInViewController.h
//  TestDemo1
//
//  Created by Hou on 2/17/16.
//  Copyright © 2016 Hou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "passValueForVCDelegate.h"
#import "LogInAndRegistLogicDelegate.h"
#import <BmobIMSDK/BmobIMSDK.h>

@interface logInViewController : UIViewController<UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate, LogInAndRegistLogicDelegate, passValueForVCDelegate>

@property (weak, nonatomic) id<LogInAndRegistLogicDelegate> delegate;
@property (weak, nonatomic) id<passValueForVCDelegate> delegateForVC;
@property (nonatomic, retain) UIView *underlineView;
@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) UIView *accountLoginView;
@property (nonatomic, retain) UIView *phoneNumberLoginView;
@property (nonatomic, retain) UIButton *accountButton;
@property (nonatomic, retain) UIButton *phoneNumberButton;
@property (nonatomic, strong) NSString *currentUserName;
@property (strong, nonatomic) BmobIM *sharedIM;
@property (copy  , nonatomic) NSString *userId;
@property (copy  , nonatomic) NSString *token;
@end
