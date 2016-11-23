//
//  agreementVC.m
//  FleaMarket
//
//  Created by Hou on 17/11/2016.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "agreementVC.h"
#import "myAgreementBLDelegate.h"
#import "myAgreementBL.h"
#import "presentLayerPublicMethod.h"

@interface agreementVC ()<myAgreementBLDelegate>

@property(nonatomic, strong) UITextView *textViewAgree;

@end

@implementation agreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户注册协议";
    
    [self drawNav];
    [self initProperty];
    [self requestAgreementFromSever];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ----------2016-09-26-11-07 drawNav begin ------------------------------------------
-(void)drawNav{
    //201609251624 modify
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemClicked:)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    leftBarItem.tintColor = orangColorPCH;
}

-(void)leftBarItemClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma ----------2016-09-26-11-07 drawNav end ---------------------------------------------

-(void)initProperty{
    self.textViewAgree.frame = CGRectMake(0, 0, screenWidthPCH, screenHeightPCH);
    self.textViewAgree.font = FontSize14;
    self.textViewAgree.editable = NO;
    [self.view addSubview: self.textViewAgree];
}

-(void)requestAgreementFromSever{
    myAgreementBL *myAgree = [myAgreementBL sharedManager];
    myAgree.delegate = self;
    [myAgree requestAgreementFromSeverBL];
}

-(void)myAgreementDataRequestFinishedBL:(NSMutableDictionary *)mudic{
    NSString *str = [mudic objectForKey:@"agreement"];
    self.textViewAgree.text = str;
}

-(void)myAgreementDataRequestFailedBL:(NSError *)error{
    [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"获取数据失败"];
}

-(void)myAgreementDataRequestNODataBL:(BOOL)value{
    [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"服务器无数据，请重新获取"];
}


-(UITextView *)textViewAgree{
    if(!_textViewAgree){
        _textViewAgree = [[UITextView alloc] init];
    }
    return _textViewAgree;
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
