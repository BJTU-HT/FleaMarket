//
//  DetailedAddContactsVC.h
//  FleaMarket
//
//  Created by Hou on 5/16/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddContactsVCDelegate.h"
#import "AddContactsBLDelegate.h"

@interface DetailedAddContactsVC : UIViewController<AddContactsVCDelegate, AddContactsBLDelegate>

@property (nonatomic, strong) id<AddContactsVCDelegate> delegate;
@end
