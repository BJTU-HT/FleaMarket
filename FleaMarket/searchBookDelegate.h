
//
//  searchBookDelegate.h
//  FleaMarket
//
//  Created by Hou on 8/16/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef searchBookDelegate_h
#define searchBookDelegate_h

@protocol searchBookDelegate
@optional

-(void)searchPagePassValue:(NSMutableDictionary *)mudic;

-(void)passSearchBookName:(NSString *)searchBookName;

@end

#endif /* searchBookDelegate_h */
