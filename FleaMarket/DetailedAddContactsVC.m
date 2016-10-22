//
//  DetailedAddContactsVC.m
//  FleaMarket
//
//  Created by Hou on 5/16/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "DetailedAddContactsVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <BmobIMSDK/BmobIMUserInfo.h>
#import "AddContactsBL.h"
#import "presentLayerPublicMethod.h"

@interface DetailedAddContactsVC ()

@end

@implementation DetailedAddContactsVC

UIImageView *imageViewHeadDetail;
UILabel *nickNameLabel;
NSString *toUserId;
@synthesize buttonAddFriend;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"点击添加";
    self.view.backgroundColor = grayColorPCH;
    [self drawImageAndUsername];
    [self addImageToNav];
}

#pragma ---------201609251626 add begin --------------------------------
-(void)addImageToNav{
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemClicked:)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

-(void)leftBarItemClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma ---------201609251626 add end ----------------------------------

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)drawImageAndUsername{
    float viewHeight = 70.0;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, navStatusBarHeightPCH, screenWidthPCH, viewHeight)];
    float cellHeight = 70.0;
    float image_x_offset = 0.05 * screenWidthPCH;
    float image_y_offset = 0.1 * cellHeight;
    float image_width = 0.8 * cellHeight;
    float image_Height = image_width;
    
    if(imageViewHeadDetail == nil){
        imageViewHeadDetail = [[UIImageView alloc] init];
    }
    CGRect imageViewHeadFrame =  CGRectMake(image_x_offset, image_y_offset, image_width, image_Height);
    imageViewHeadDetail.frame = imageViewHeadFrame;
    imageViewHeadDetail.image = [UIImage imageNamed:@"icon_default_face@2x"];
    
    float label_x_offset = 2 * image_x_offset + image_width;
    float label_y_offset = image_y_offset;
    float label_width = 0.6 *screenWidthPCH;
    float label_height = 16.0;//默认采用14号字
    if(nickNameLabel == nil){
        nickNameLabel = [[UILabel alloc] init];
    }
    CGRect labelFrame = CGRectMake(label_x_offset, label_y_offset, label_width, label_height);
    nickNameLabel.frame = labelFrame;
    
    float btnXOffset = image_x_offset;
    float btnYOffset = viewHeight + 0.05 * screenHeightPCH + navStatusBarHeightPCH;
    float btnWidth = screenWidthPCH - 2 * btnXOffset;
    float btnHeight = 50.0;
    buttonAddFriend = [[UIButton alloc] initWithFrame:CGRectMake(btnXOffset, btnYOffset, btnWidth, btnHeight)];
    //buttonAddFriend.backgroundColor = [UIColor colorWithRed:0/255.0 green:191/255.0 blue:255/255.0 alpha:1.0];
    buttonAddFriend.backgroundColor = orangColorPCH;
    [buttonAddFriend setTitle:@"加为好友" forState:UIControlStateNormal];
    [buttonAddFriend setTintColor:[UIColor whiteColor]];
    [buttonAddFriend addTarget:self action:@selector(buttonAddClicked:) forControlEvents:UIControlEventTouchDown];
    
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:imageViewHeadDetail];
    [view addSubview: nickNameLabel];
    [self.view addSubview:view];
    [self.view addSubview:buttonAddFriend];
}

-(void)sendRequestAddFriend:(NSString *)toUserId{
    AddContactsBL *addBL = [[AddContactsBL alloc] init];
    addBL.delegate = self;
    [addBL requestAddFriendBL:toUserId];
}
#pragma 实现代理传值函数-------------
-(void)passUserInfo:(NSString *)imageURL nickName:(NSString *)username userId:(NSString *)userId{
    dispatch_async(dispatch_get_main_queue(), ^{
        [imageViewHeadDetail sd_setImageWithURL:[NSURL URLWithString:imageURL]];
        nickNameLabel.text = username;
        toUserId = userId;
    });
}
#pragma 实现代理传值函数 end---------

#pragma @selector 代理方法实现-------------
-(void)buttonAddClicked:(UIButton *)sender{
    [self sendRequestAddFriend: toUserId];
}
#pragma @selector 代理方法实现 end---------

#pragma 添加好友代理方法实现
-(void)requestAddFriendFinishedBL:(BOOL)value{
    if(value){
        presentLayerPublicMethod *publicMethod = [[presentLayerPublicMethod alloc] init];
        [publicMethod notifyView:self.navigationController notifyContent:@"添加好友请求发送成功"];
        [buttonAddFriend setTitle:@"好友请求已发送" forState: UIControlStateNormal];
        buttonAddFriend.userInteractionEnabled = NO;
    }
}
-(void)requestAddFriendFailedBL:(NSString *)error{
    if(error){
        presentLayerPublicMethod *publicMethod = [[presentLayerPublicMethod alloc] init];
        [publicMethod notifyView:self.navigationController notifyContent:@"添加好友请求发送失败"];
    }
}

#pragma 添加好友代理方法实现 end
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
