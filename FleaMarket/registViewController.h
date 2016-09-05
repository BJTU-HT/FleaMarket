//
//  registViewController.h
//  TestDemo1
//
//  Created by Hou on 2/23/16.
//  Copyright © 2016 Hou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogInAndRegistLogicDelegate.h"

@interface registViewController : UIViewController<UITextFieldDelegate, LogInAndRegistLogicDelegate>

@property (weak, nonatomic) id<LogInAndRegistLogicDelegate> delegate;
@end
