//
//  TextChatView.h
//  FleaMarket
//
//  Created by Hou on 5/23/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "ChatView.h"

@interface TextChatView : ChatView

@property(nonatomic, strong) UILabel *contentLabel;

-(void)setMessage:(BmobIMMessage *)msg user:(BmobIMUserInfo *)userInfo;
@end
