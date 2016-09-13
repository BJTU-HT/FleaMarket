//
//  myConcernedBL.h
//  FleaMarket
//
//  Created by Hou on 9/12/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "myConcernedDAODelegate.h"
#import "myConcernedBLDelegate.h"
#import "myConcernedDAO.h"

@interface myConcernedBL : NSObject<myConcernedDAODelegate>

@property(nonatomic, weak) id<myConcernedBLDelegate> delegate;

+(myConcernedBL *)sharedManager;

-(void)requestMyConcernedConcretedBL:(NSString *)objectId;
@end
