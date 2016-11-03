//
//  passValueForVCDelegate.h
//  FleaMarket
//
//  Created by Hou on 4/20/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#ifndef passValueForVCDelegate_h
#define passValueForVCDelegate_h
#import <BmobIMSDK/BmobIMConversation.h>

@protocol passValueForVCDelegate

@optional

-(void)passValueForVC:(NSDictionary *)dic;
-(void)passValue:(int)value;
-(void)passStrValue:(NSString *)value;
//传递会话
-(void)passConversationValue:(BmobIMConversation *)value;

@end

#endif /* passValueForVCDelegate_h */
