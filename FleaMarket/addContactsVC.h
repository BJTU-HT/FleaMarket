//
//  addContactsVC.h
//  FleaMarket
//
//  Created by Hou on 5/9/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddContactsBLDelegate.h"
#import "AddContactsVCDelegate.h"

@interface addContactsVC : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, AddContactsBLDelegate>

@property (nonatomic, weak) id<AddContactsVCDelegate> delegate;

@property (strong, nonatomic)UITableView *tableViewAddContact;

@end
