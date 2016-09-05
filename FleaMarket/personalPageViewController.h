//
//  personalPageViewController.h
//  TestDemo1
//
//  Created by Hou on 3/4/16.
//  Copyright © 2016 Hou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogInAndRegistLogicDelegate.h"
#import "passValueForVCDelegate.h"

@interface personalPageViewController : UIViewController<LogInAndRegistLogicDelegate, passValueForVCDelegate>

@end
