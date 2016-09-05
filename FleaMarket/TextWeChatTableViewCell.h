//
//  TextWeChatTableViewCell.h
//  FleaMarket
//
//  Created by Hou on 6/14/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "weChatView.h"

@interface TextWeChatTableViewCell : UITableViewCell

-(CGFloat)cellConfigMsg:(BmobIMMessage *)msg userInfo: (BmobIMUserInfo *)userInfo;
@end
