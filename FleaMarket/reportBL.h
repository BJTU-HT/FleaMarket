//
//  reportBL.h
//  FleaMarket
//
//  Created by Hou on 21/11/2016.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "reprotBLDelegate.h"
#import "reportDelegateDAO.h"

@interface reportBL : NSObject<reportDelegateDAO>

@property(nonatomic, weak) id<reprotBLDelegate> delegate;

+ (reportBL *)sharedManager;

-(void)uploadReportInfoBL:(NSDictionary *)dic;

@end
