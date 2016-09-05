//
//  passValueDelegate.h
//  TestDemo1
//
//  Created by Hou on 11/4/15.
//  Copyright (c) 2015 Hou. All rights reserved.
//

@class searchFromBmob;

@protocol pagePassValueDelegate <NSObject>

-(void)passValue:(NSString *)value;

-(void)passDicValue:(NSDictionary *)dictionary;
@end

