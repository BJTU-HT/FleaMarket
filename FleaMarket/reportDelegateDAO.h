//
//  reportDelegateDAO.h
//  FleaMarket
//
//  Created by Hou on 21/11/2016.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef reportDelegateDAO_h
#define reportDelegateDAO_h
@protocol reportDelegateDAO
@optional

-(void)reportDAOFinished:(BOOL)isSuccessful;
-(void)reportDAOFailed:(NSError *)error;

@end

#endif /* reportDelegateDAO_h */
