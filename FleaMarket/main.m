//
//  main.m
//  FleaMarket
//
//  Created by tom555cat on 16/4/13.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <BmobSDK/Bmob.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSString *appKey = @"22b77d5878214e8e2bc388d056b58254";
        [Bmob registerWithAppKey:appKey];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
