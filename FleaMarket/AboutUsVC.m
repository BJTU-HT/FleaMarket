//
//  aboutUsVC.m
//  FleaMarket
//
//  Created by Hou on 9/13/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "AboutUsVC.h"

@interface AboutUsVC ()

@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect labelFrame = CGRectMake(10, 64, screenWidthPCH - 20, 100);
    self.labelAboutUs.numberOfLines = 0;
    self.labelAboutUs.text = @"欢迎您下载FleaMarket，有问题可以随时向我们反馈。我们会第一时间为您做出解答。谢谢您的使用!";
    self.labelAboutUs.frame = labelFrame;
    [self.view addSubview:self.labelAboutUs];
    self.labelAboutUs.font = FontSize16;
    self.labelAboutUs.textColor = [UIColor grayColor];
    self.title = @"关于我们";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UILabel *)labelAboutUs{
    if(!_labelAboutUs){
        _labelAboutUs = [[UILabel alloc] init];
    }
    return _labelAboutUs;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
