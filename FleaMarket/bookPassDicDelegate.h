
//
//  bookPassDicDelegate.h
//  FleaMarket
//
//  Created by Hou on 8/11/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef bookPassDicDelegate_h
#define bookPassDicDelegate_h

@protocol bookPassDicDelegate

@optional

-(void)passMudicValue:(NSMutableDictionary *)muDictionary;

-(void)passDicFromSecondToLM:(NSMutableDictionary *)mudic;

-(void)passMudicValueLMToSecond:(NSMutableDictionary *)mudicLM;

@end
#endif /* bookPassDicDelegate_h */
