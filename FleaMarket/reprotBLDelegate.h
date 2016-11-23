//
//  reprotBLDelegate.h
//  FleaMarket
//
//  Created by Hou on 21/11/2016.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef reprotBLDelegate_h
#define reprotBLDelegate_h

@protocol reprotBLDelegate
@optional

-(void)reportBLFinished:(BOOL)isSuccessful;

-(void)reportBLFailed:(NSError *)error;

@end
#endif /* reprotBLDelegate_h */
