//
//  AddContactsVCDelegate.h
//  FleaMarket
//
//  Created by Hou on 5/16/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef AddContactsVCDelegate_h
#define AddContactsVCDelegate_h

@protocol AddContactsVCDelegate
@optional

-(void)passUserInfo:(NSString *)imageURL nickName:(NSString *)username userId:(NSString *)userId;
@end

#endif /* AddContactsVCDelegate_h */
