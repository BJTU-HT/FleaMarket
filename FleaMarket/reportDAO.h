//
//  reportDAO.h
//  FleaMarket
//
//  Created by Hou on 21/11/2016.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "reportDelegateDAO.h"

@interface reportDAO : NSObject

@property(nonatomic, weak) id<reportDelegateDAO> delegate;

+ (reportDAO *)sharedManager;

-(void)uploadReportInfoDAO:(NSDictionary *)dic;

@end
