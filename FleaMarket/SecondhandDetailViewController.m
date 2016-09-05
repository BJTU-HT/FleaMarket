//
//  SecondhandDetailViewController.m
//  FleaMarket
//
//  Created by tom555cat on 16/4/10.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "SecondhandDetailViewController.h"
#import "Help.h"
#import "SecondhandMessageBL.h"
#import "SecondhandMessageBLDelegate.h"
#import "SecondhandMessageVO.h"
#import "MessageCell.h"
#import "CommentFooterView.h"
#import "UIImageView+WebCache.h"
#import <BmobSDK/BmobUser.h>
#import "logInViewController.h"
#import "DetailChatVC.h"
#import "UserInfoSingleton.h"
#import "UserService.h"
#import "RecentCommentViewController.h"

#define KscreenWith self.view.frame.size.width
#define Kheght self.view.frame.size.height

static NSString *IDD_MESSAGE = @"DD";

@interface SecondhandDetailViewController () <UIScrollViewDelegate, SecondhandMessageBLDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, FooterViewDelegate>

//
@property (nonatomic, strong) UIScrollView *detailScrollView;

// 商品信息View
@property (nonatomic, strong) UIView *infoView;

// 浏览这个产品的View
@property (nonatomic, strong) UIView *skimView;

//201607181632 add by hou
@property (nonatomic, strong) NSString *userObjectID;
// 头像
@property (nonatomic, strong) UIImageView *iconImageView;
// 名字
@property (nonatomic, strong) UILabel *nameLabel;
// 性别
@property (nonatomic, strong) UIImageView *sexImageView;
// 现在价格
@property (nonatomic, strong) UILabel *nowPriceLabel;
// 原始价格
@property (nonatomic, strong) UILabel *originalPriceLabel;
// 描述
@property (nonatomic, strong) UILabel *descriptionLabel;
// 配图
@property (nonatomic, strong) UIScrollView *pictureImageScrollView;
// 学校
@property (nonatomic, strong) UILabel *schoolLabel;
// 地址
@property (nonatomic, strong) UILabel *locationLabel;
// 发布时间
@property (nonatomic, strong) UILabel *publishTimeLabel;
// 左视图
@property (nonatomic, strong) UIImageView *currentImageView;
// 中视图
@property (nonatomic, strong) UIImageView *leftImageView;
// 右视图
@property (nonatomic, strong) UIImageView *rightImageView;
//
@property (nonatomic, assign) NSInteger currentImageIndex, leftImageIndex, rightImageIndex;
// PageControl
@property (nonatomic, strong) UIPageControl *pageControl;
// 业务逻辑层
@property (nonatomic, strong) SecondhandMessageBL *bl;
// 评论tableView和上面内容的间隔条
@property (nonatomic, strong) UIView *part1Bar;
// 评论tableview
@property (nonatomic, strong) UITableView *tab;
// 加载更多的tab footerView
@property (nonatomic, strong) CommentFooterView *footerView;
// 评论message
@property (nonatomic, strong) NSMutableArray *messageArray;
// 评论message frame
@property (nonatomic, strong) NSMutableArray *frameArray;
// 评论弹出框
@property (nonatomic, strong) UITextField *commentInputField;
// 测试
@property (nonatomic, strong) UITextField *inputFieldTest;
// 输入评论时，显示在键盘上边的view
@property (nonatomic, strong) UITextField *accessoryView;
// 当前评论信息，用来保存当前要发表的评论
@property (nonatomic, strong) SecondhandMessageVO *commentVO;
// 当前键盘是否是弹出的
@property (nonatomic, assign) BOOL isKeyboardPopup;
// 评论是否加载结束
@property (nonatomic, assign) BOOL isAllCommentLoaded;
// activityIndicator
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation SecondhandDetailViewController

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self prefersStatusBarHidden];
    //[self setNeedsStatusBarAppearanceUpdate];
    [self setupFrame];

    // 恢复分页读取偏移
    [self.bl reset];
    
    // 查询评论
    [self.bl findSecondhandMessage:self.model.productID];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    //201606181002 cut by hou
    //self.navigationController.toolbarHidden = YES;
    
    // observe keyboard hide and show notifications to resize the text field
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    //201607181002 modify by hou from YES to NO
    self.navigationController.navigationBarHidden = NO;
    //self.navigationController.toolbarHidden = YES;
    
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark ------------------- private -----------------------

- (NSMutableArray *)messageArray
{
    if (_messageArray == nil) {
        _messageArray = [[NSMutableArray alloc] init];
    }
    
    return _messageArray;
}

- (void)setup
{
    // 整个scrollView
    UIScrollView *detailScrollView = [[UIScrollView alloc] init];
    self.detailScrollView = detailScrollView;
    
    // page control
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    self.pageControl = pageControl;
    
    // infoView
    UIView *infoView = [[UIView alloc] init];
    self.infoView = infoView;
    
    // 头像
    UIImageView *iconImageView = [[UIImageView alloc] init];
    self.iconImageView = iconImageView;
    
    // 名字
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = HTNameFont;
    self.nameLabel = nameLabel;
    
    // 性别
    UIImageView *sexImageView = [[UIImageView alloc] init];
    self.sexImageView = sexImageView;
    
    // 发布日期
    UILabel *publishTimeLabel = [[UILabel alloc] init];
    publishTimeLabel.font = HTNameFont;
    self.publishTimeLabel = publishTimeLabel;
    
    // 学校
    UILabel *schoolLabel = [[UILabel alloc] init];
    schoolLabel.font = HTNameFont;
    self.schoolLabel = schoolLabel;
    
    // 现在价格
    UILabel *nowPriceLabel = [[UILabel alloc] init];
    nowPriceLabel.font = HTTextFont;
    self.nowPriceLabel = nowPriceLabel;
    
    // 原始价格
    UILabel *originalPriceLabel = [[UILabel alloc] init];
    originalPriceLabel.font = HTTextFontLess;
    self.originalPriceLabel = originalPriceLabel;
    
    // 描述
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.font = HTTextFont;
    self.descriptionLabel = descriptionLabel;
    
    // 地址
    UILabel *locationLabel = [[UILabel alloc] init];
    locationLabel.font = HTTextFont;
    self.locationLabel = locationLabel;
    
    // 创建BL
    self.bl = [[SecondhandMessageBL alloc] init];
    self.bl.delegate = self;
    
    // 创建评论输入文本框
    UITextField *commentInputField = [[UITextField alloc] init];
    commentInputField.delegate = self;
    self.commentInputField = commentInputField;
}

- (void)setupFrame
{
    CGFloat margin = 10;
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    CGFloat navigationBarH = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    // 整个scrollView 20160618 modify by hou; -20 to deal with statusBar can not be hidden
    //self.detailScrollView.frame = self.view.frame;
    self.detailScrollView.frame = CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height);
    //self.detailScrollView.showsVerticalScrollIndicator = NO;
    self.detailScrollView.contentSize = CGSizeMake(0, winSize.height+20);
    [self.view addSubview:self.detailScrollView];
    self.detailScrollView.backgroundColor = grayColorPCH;
    
    // 图片轮播
    [self setUpScrollView];
    
    // 返回按钮
    CGFloat returnBtnX = margin;
    CGFloat returnBtnY = margin*2;
    CGFloat returnBtnWH = 35;
    UIButton *returnBtn = [[UIButton alloc] init];
    returnBtn.frame = CGRectMake(returnBtnX, returnBtnY, returnBtnWH, returnBtnWH);
    [returnBtn setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnToMain) forControlEvents:UIControlEventTouchUpInside];
    [self.detailScrollView addSubview:returnBtn];
    
    // 右边按钮
    CGFloat moreBtnX = winSize.width - margin - returnBtnWH;
    CGFloat moreBtnY = margin * 2;
    UIButton *moreBtn = [[UIButton alloc] init];
    moreBtn.frame = CGRectMake(moreBtnX, moreBtnY, returnBtnWH, returnBtnWH);
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.detailScrollView addSubview:moreBtn];
    
    // 设置pageControl
    CGFloat spaceForOne = winSize.width / 10.0f;   // 最多上传10张图片
    CGFloat pageControlW = spaceForOne * self.model.pictureArray.count;
    CGFloat pageControlH = spaceForOne;
    CGFloat pageControlX = winSize.width / 2.0f - pageControlW / 2.0f;
    CGFloat pageControlY = navigationBarH + statusBarH + winSize.height * 0.3f * 0.7f;
    self.pageControl.frame = CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH);
    self.pageControl.numberOfPages = self.model.pictureArray.count;
    self.pageControl.currentPage = 0;
    [self.detailScrollView addSubview:self.pageControl];
    
    // 商品信息面板
    CGFloat infoViewX = 0;
    CGFloat infoViewY = CGRectGetMaxY(self.pictureImageScrollView.frame);
    CGFloat infoViewW = winSize.width;
    CGFloat infoViewH = 100;
    self.infoView.frame = CGRectMake(infoViewX, infoViewY, infoViewW, infoViewH);
    self.infoView.backgroundColor = [UIColor whiteColor];
    [self.detailScrollView addSubview:self.infoView];
    
    // 头像
    CGFloat iconX = margin;
    //CGFloat iconY = margin + CGRectGetMaxY(self.pictureImageScrollView.frame);
    CGFloat iconY = margin;
    CGFloat iconWH = 30;
    self.iconImageView.frame = CGRectMake(iconX, iconY, iconWH, iconWH);
    [self.infoView addSubview:self.iconImageView];
    
    // 姓名
    CGFloat nameY = iconY;
    CGFloat nameX = CGRectGetMaxX(self.iconImageView.frame) + margin;
    NSDictionary *nameAttrs = @{NSFontAttributeName : HTNameFont};
    CGSize nameSize = [self.model.userName sizeWithAttributes:nameAttrs];
    self.nameLabel.frame = (CGRect){{nameX, nameY}, nameSize};
    [self.infoView addSubview:self.nameLabel];
    
    // 性别
    CGFloat sexY = iconY;
    CGFloat sexX = CGRectGetMaxX(self.nameLabel.frame) + margin/2.0f;
    CGFloat sexWH = nameSize.height;
    self.sexImageView.frame = CGRectMake(sexX, sexY, sexWH, sexWH);
    [self.infoView addSubview:self.sexImageView];
    
    // 发布时间
    NSDictionary *publishAttrs = @{NSFontAttributeName : HTNameFont};
    CGSize publishSize = [self.model.publishTime sizeWithAttributes:publishAttrs];
    CGFloat publishY = CGRectGetMaxY(self.iconImageView.frame) - publishSize.height;
    CGFloat publishX = CGRectGetMaxX(self.iconImageView.frame) + margin;
    self.publishTimeLabel.frame = (CGRect){{publishX, publishY}, publishSize};
    [self.infoView addSubview:self.publishTimeLabel];
    
    // 学校
    NSDictionary *schoolAttrs = @{NSFontAttributeName : HTNameFont};
    CGSize schoolSize = [self.model.school sizeWithAttributes:schoolAttrs];
    CGFloat schoolY = iconY + iconWH/2.0f - schoolSize.height/2.0f;
    CGFloat schoolX = winSize.width - schoolSize.width - margin;
    self.schoolLabel.frame = (CGRect){{schoolX, schoolY}, schoolSize};
    [self.infoView addSubview:self.schoolLabel];
    
    // 现在价格
    CGFloat nowPriceX = margin;
    CGFloat nowPriceY = CGRectGetMaxY(self.iconImageView.frame) + margin/2.0f;
    NSDictionary *nowPriceAttr = @{NSFontAttributeName : HTTextFont};
    CGSize nowPriceSize = [[NSString stringWithFormat:@"￥%.1f", self.model.nowPrice] sizeWithAttributes:nowPriceAttr];
    self.nowPriceLabel.frame = (CGRect){{nowPriceX, nowPriceY}, nowPriceSize};
    [self.infoView addSubview:self.nowPriceLabel];
    
    // 原始价格
    NSDictionary *originalPriceAttr = @{NSFontAttributeName : HTTextFontLess};
    CGSize originalPriceSize = [[NSString stringWithFormat:@"￥%.1f", self.model.originalPrice] sizeWithAttributes:originalPriceAttr];
    CGFloat originalPriceX = CGRectGetMaxX(self.nowPriceLabel.frame);
    CGFloat originalPriceY = CGRectGetMaxY(self.nowPriceLabel.frame) - originalPriceSize.height;
    self.originalPriceLabel.frame = (CGRect){{originalPriceX, originalPriceY}, originalPriceSize};
    [self.infoView addSubview:self.originalPriceLabel];
    
    // 描述
    NSLog(@"%@", self.model.productDescription);
    
    CGFloat descriptionX = margin;
    CGFloat descriptionY = CGRectGetMaxY(self.nowPriceLabel.frame) + margin;
    CGFloat descriptionW = winSize.width - 2 * margin;
    self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
    self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.frame = CGRectMake(descriptionX, descriptionY, descriptionW, 0);    // 暂时
    CGRect txtFrame = self.descriptionLabel.frame;
    self.descriptionLabel.frame = CGRectMake(descriptionX, descriptionY, descriptionW, txtFrame.size.height = [self.model.productDescription boundingRectWithSize:CGSizeMake(txtFrame.size.width, 1000000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.descriptionLabel.font, NSFontAttributeName, nil] context:nil].size.height);
    self.descriptionLabel.frame = CGRectMake(descriptionX, descriptionY, descriptionW, txtFrame.size.height);
    [self.infoView addSubview:self.descriptionLabel];
    
    // 分隔线
    CGFloat barX = margin;
    CGFloat barY = CGRectGetMaxY(self.descriptionLabel.frame) + margin/2.0f;
    CGFloat barW = winSize.width - margin * 2.0f;
    CGFloat barH = 0.5f;
    UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(barX, barY, barW, barH)];
    bar.backgroundColor = grayColorPCH;
    [self.infoView addSubview:bar];
    
    //地址
    CGFloat locationX = margin;
    CGFloat locationY = CGRectGetMaxY(bar.frame) + margin/2.0f;
    NSDictionary *locationAttr = @{NSFontAttributeName : HTTextFont};
    CGSize locationSize = [self.model.location sizeWithAttributes:locationAttr];
    self.locationLabel.frame = (CGRect){{locationX, locationY}, locationSize};
    [self.infoView addSubview:self.locationLabel];
    
    //重新设置infoView的frame
    infoViewX = 0;
    infoViewY = CGRectGetMaxY(self.pictureImageScrollView.frame);
    infoViewW = winSize.width;
    infoViewH = CGRectGetMaxY(self.locationLabel.frame) + margin/2.0f;
    self.infoView.frame = CGRectMake(infoViewX, infoViewY, infoViewW, infoViewH);
    
    // 间隔
    CGFloat partX = 0;
    CGFloat partY = CGRectGetMaxY(self.locationLabel.frame) + margin;
    CGFloat partH = HTPartBar;
    UIView *partBar = [[UIView alloc] initWithFrame:CGRectMake(partX, partY, winSize.width, partH)];
    partBar.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0f];
    //[self.detailScrollView addSubview:partBar];
    
    // 浏览记录View
    UIView *skimView = [[UIView alloc] initWithFrame:CGRectZero];
    self.skimView = skimView;
    [self.detailScrollView addSubview:self.skimView];
    
    // 浏览过此商品的人
    CGFloat viewTimesLabelX = margin;
    //CGFloat viewTimesLabelY = CGRectGetMaxY(partBar.frame) + margin / 2.0f;
    CGFloat viewTimesLabelY = margin / 2.0f;
    NSDictionary *viewTimesAttr = @{NSFontAttributeName : HTTextFont};
    CGSize viewTimesSize = [[NSString stringWithFormat:@"最近%d人来访", self.model.skimTimes] sizeWithAttributes:viewTimesAttr];
    UILabel *skimTimesLabel = [[UILabel alloc] init];
    skimTimesLabel.font = HTTextFont;
    skimTimesLabel.frame = (CGRect){{viewTimesLabelX, viewTimesLabelY}, viewTimesSize};
    //skimTimesLabel.backgroundColor = [UIColor greenColor];
    skimTimesLabel.text = [NSString stringWithFormat:@"最近%d人来访", self.model.skimTimes];
    [self.skimView addSubview:skimTimesLabel];
    
    // 浏览的人
    CGFloat skimIconX = margin;
    CGFloat skimIconY = CGRectGetMaxY(skimTimesLabel.frame) + margin / 2.0f;
    CGFloat skimIconW = winSize.width - 2 * margin;
    UIView *skimIcons = [[UIView alloc] initWithFrame:CGRectMake(skimIconX, skimIconY, skimIconW, iconWH)];
    //skimIcons.backgroundColor = [UIColor grayColor];
    [self.skimView addSubview:skimIcons];
    
    // 设置浏览过的人的头像
    CGFloat gap = (winSize.width - 2 * margin - iconWH * MaxVisitorURLsKeep) / (MaxVisitorURLsKeep - 1);
    for (int i = 0; i < [self.model.visitorURLArray count]; i++) {
        CGFloat x = margin + iconWH * i + gap * i;
        CGFloat y = CGRectGetMaxY(skimTimesLabel.frame) + margin / 2.0f;
        UIImageView *visitorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, iconWH, iconWH)];
        [visitorImageView sd_setImageWithURL:[NSURL URLWithString:self.model.visitorURLArray[i]]];
        [self.skimView addSubview:visitorImageView];
    }
    
    // 重新设置skimView的frame
    CGFloat skimViewX = 0;
    CGFloat skimViewY = CGRectGetMaxY(self.infoView.frame) + HTPartBar;
    CGFloat skimViewW = winSize.width;
    CGFloat skimViewH = CGRectGetMaxY(skimIcons.frame) + margin / 2.0f;
    self.skimView.backgroundColor = [UIColor whiteColor];
    self.skimView.frame = CGRectMake(skimViewX, skimViewY, skimViewW, skimViewH);
    
    // 间隔
    CGFloat part1X = 0;
    CGFloat part1Y = CGRectGetMaxY(skimIcons.frame) + margin / 2.0f;
    CGFloat part1H = HTPartBar;
    UIView *part1Bar = [[UIView alloc] initWithFrame:CGRectMake(part1X, part1Y, winSize.width, part1H)];
    part1Bar.backgroundColor = [UIColor lightGrayColor];
    self.part1Bar = part1Bar;
    //[self.detailScrollView addSubview:part1Bar];
    
    // 留言
    CGFloat messageX = 0;
    CGFloat messageY = CGRectGetMaxY(skimView.frame) + HTPartBar;
    UITableView *vi = [[UITableView alloc] initWithFrame:CGRectMake(messageX, messageY, winSize.width, 0) style:UITableViewStylePlain];
    vi.delegate = self;
    vi.dataSource = self;
    vi.backgroundColor = [UIColor grayColor];
    [self.detailScrollView addSubview:vi];
    [vi registerClass:[MessageCell class] forCellReuseIdentifier:IDD_MESSAGE];
    self.tab = vi;
    self.tab.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];    //不显示空cell
    self.tab.scrollEnabled = NO;
    self.isAllCommentLoaded = NO;
    
    // 整个detailScrollView的高度
    self.detailScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.skimView.frame) + HTPartBar + self.tab.contentSize.height + screenHeightPCH *0.08f);
    NSLog(@"detailScrollView, y %f", self.detailScrollView.contentSize.height);
    
    // 设置评论输入框
    CGFloat commentWidth = winSize.width;
    CGFloat commentHeight = screenHeightPCH * 0.08f;       // 评论条的高度和工具条的高度一致，并被工具条挡住
    CGFloat commentInputX = 0;
    CGFloat commentInputY = winSize.height - commentHeight;
    self.commentInputField.frame = CGRectMake(commentInputX, commentInputY, commentWidth, commentHeight);
    self.commentInputField.backgroundColor = [UIColor orangeColor];
    self.commentInputField.placeholder = @"输入评论";
    [self.view addSubview:self.commentInputField];
    //[self.view bringSubviewToFront:self.commentInputField];
    
    // 设置页脚工具条
    CGFloat toolBarH = screenHeightPCH * 0.08f;
    CGFloat toolBarW = screenWidthPCH;
    CGFloat toolBarX = 0;
    CGFloat toolBarY = screenHeightPCH - toolBarH;
    UIView *toolBarView = [[UIView alloc] init];
    toolBarView.frame = CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);
    toolBarView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:toolBarView];
    //[self.view bringSubviewToFront:toolBarView];
    
    // toolbar， 赞按钮
    /*
    CGFloat praiseX = 0;
    CGFloat praiseY = 0;
    CGFloat praiseBtnW = screenWidthPCH * 0.2f;
    CGFloat praiseBtnH = toolBarH;
    UIButton *praiseBtn = [[UIButton alloc] init];
    praiseBtn.frame = CGRectMake(praiseX, praiseY, praiseBtnW, praiseBtnH);
    [praiseBtn setTitle:@"赞" forState:UIControlStateNormal];
    [toolBarView addSubview:praiseBtn];
     */
    
    // toolbar， 评论按钮
    CGFloat commentX = 0;
    CGFloat commentY = 0;
    CGFloat commentBtnW = screenWidthPCH / 4.0f;
    CGFloat commentBtnH = toolBarH;
    UIButton *commentBtn = [[UIButton alloc] init];
    commentBtn.frame = CGRectMake(commentX, commentY, commentBtnW, commentBtnH);
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentProduct:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarView addSubview:commentBtn];
    
    // toolbar,  分享按钮
    CGFloat shareX = commentBtnW;
    CGFloat shareY = 0;
    CGFloat shareBtnW = screenWidthPCH / 4.0f;
    CGFloat shareBtnH = toolBarH;
    UIButton *shareBtn = [[UIButton alloc] init];
    shareBtn.frame = CGRectMake(shareX, shareY, shareBtnH, shareBtnH);
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [toolBarView addSubview:shareBtn];
    
    // toolbar， 我想要
    CGFloat wantX = commentBtnW + shareBtnW;
    CGFloat wantY = 0;
    CGFloat wantBtnW = screenWidthPCH / 2.0f;
    CGFloat wantBtnH = toolBarH;
    UIButton *wantBtn = [[UIButton alloc] init];
    wantBtn.frame = CGRectMake(wantX, wantY, wantBtnW, wantBtnH);
    [wantBtn setTitle:@"我想要" forState:UIControlStateNormal];
    //添加回话跳转页面，跳转到用户之间聊天 20160613-1353
    [wantBtn addTarget:self action:@selector(wantBtnClicked:) forControlEvents:UIControlEventTouchDown];
    wantBtn.backgroundColor = [UIColor redColor];
    [toolBarView addSubview:wantBtn];
    // 创建触摸收回评论触摸事件
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGR.cancelsTouchesInView = NO;
    [self.detailScrollView addGestureRecognizer:tapGR];
}

//响应wantBtn点击事件,用于跳转到聊天界面，首先检测是否登录 add by hou
-(void)wantBtnClicked:(UIButton *)sender{
    BmobUser *currentUser = [BmobUser getCurrentUser];
    if(currentUser == nil){
        self.hidesBottomBarWhenPushed = YES;
        logInViewController *logIn = [[logInViewController alloc] init];
        [self.navigationController pushViewController:logIn animated:NO];
        //self.hidesBottomBarWhenPushed = NO;
    }else{
        DetailChatVC *privacyChat = [[DetailChatVC alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        privacyChat.conversation = [self findConversation];
        [self.navigationController pushViewController: privacyChat animated:NO];
    }
}

-(BmobIMConversation *)findConversation{
    NSArray *array = [[BmobIM sharedBmobIM] queryRecentConversation];
    if(array && array.count > 0){
        for(int i = 0; i < array.count; i++){
            BmobIMConversation *conversation = array[i];
            if(conversation.conversationId == self.userObjectID){
                return conversation;
            }
        }
    }
    BmobIMConversation *conversation = [BmobIMConversation conversationWithId:self.userObjectID conversationType:BmobIMConversationTypeSingle];
    conversation.conversationTitle = self.nameLabel.text;
    return conversation;
}

// 点击屏幕其他地方收回键盘
- (void)keyboardHide:(UITapGestureRecognizer *)tap
{
    [self.commentInputField resignFirstResponder];
}

-(void)returnToMain
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpScrollView {
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    CGFloat scrollViewH =  winSize.height * 0.3f;
    CGFloat scrollViewW = winSize.width;
    
    self.pictureImageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollViewW, scrollViewH)];
    self.pictureImageScrollView.showsHorizontalScrollIndicator = NO;
    self.pictureImageScrollView.showsVerticalScrollIndicator = NO;
    self.pictureImageScrollView.pagingEnabled = YES;
    self.pictureImageScrollView.backgroundColor = [UIColor grayColor];
    
    // 给scrollview设置偏移量
    [self.pictureImageScrollView setContentOffset:CGPointMake(KscreenWith, 0) animated:NO];
    // 给scrollview赋初值
    _currentImageIndex = 0;
    self.leftImageIndex = self.model.pictureArray.count - 1;
    if (self.model.pictureArray.count == 1) {
        self.rightImageIndex = 0;
    } else {
        self.rightImageIndex = 1;
    }
    // 创建ImageView
    self.pictureImageScrollView.contentSize = CGSizeMake(3 * KscreenWith , 0);
    self.currentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(KscreenWith, 0, KscreenWith, scrollViewH)];
    self.leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,KscreenWith, scrollViewH)];
    self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(2 * KscreenWith, 0, KscreenWith, scrollViewH)];
    
    // 给ImageView赋值
    /*
     self.currentImageView.image = [UIImage imageNamed:self.model.pictureArray[self.currentImageIndex]];
     self.leftImageView.image = [UIImage imageNamed:self.model.pictureArray[self.leftImageIndex]];
     self.rightImageView.image = [UIImage imageNamed:self.model.pictureArray[self.rightImageIndex]];
     */
    [self.currentImageView sd_setImageWithURL:self.model.pictureArray[self.currentImageIndex]];
    [self.leftImageView sd_setImageWithURL:self.model.pictureArray[self.leftImageIndex]];
    [self.rightImageView sd_setImageWithURL:self.model.pictureArray[self.rightImageIndex]];
    
    // 设置代理
    self.pictureImageScrollView.delegate = self;
    [self.pictureImageScrollView addSubview:self.currentImageView];
    [self.pictureImageScrollView addSubview:self.leftImageView];
    [self.pictureImageScrollView addSubview:self.rightImageView];
    self.pictureImageScrollView.backgroundColor = [UIColor blackColor];
    [self.detailScrollView addSubview:self.pictureImageScrollView];
}


- (void)reloadImages
{
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    CGPoint point = [self.pictureImageScrollView contentOffset];
    NSLog(@"point.x ----%f", point.x);
    // 求_currentImageIndex的值
    if (point.x == 2 * winSize.width) {
        
        if ((_currentImageIndex + 1)  == self.model.pictureArray.count){
            _currentImageIndex = 0;
        }else {
            _currentImageIndex = (_currentImageIndex + 1);
        }
        
    }else if (point.x == 0) {
        if (_currentImageIndex - 1 < 0) {
            _currentImageIndex = self.model.pictureArray.count - 1;
            
        }else {
            _currentImageIndex = _currentImageIndex - 1;
        }
    }
    self.pageControl.currentPage = _currentImageIndex;
    
    // 求self.letfImageIdex的值
    if (_currentImageIndex - 1 < 0) {
        self.leftImageIndex = self.model.pictureArray.count - 1;
    }else {
        self.leftImageIndex = _currentImageIndex - 1;
    }
    
    // 求self.rightImageIndex的值
    if (self.currentImageIndex + 1 == self.model.pictureArray.count) {
        self.rightImageIndex = 0;
    }else {
        self.rightImageIndex = self.currentImageIndex + 1;
    }
    
    [self.currentImageView sd_setImageWithURL:self.model.pictureArray[self.currentImageIndex]];
    [self.leftImageView sd_setImageWithURL:self.model.pictureArray[self.leftImageIndex]];
    [self.rightImageView sd_setImageWithURL:self.model.pictureArray[self.rightImageIndex]];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    [self reloadImages];
    [self.pictureImageScrollView setContentOffset:CGPointMake(winSize.width, 0) animated:NO];
}

- (void)setModel:(SecondhandVO *)model
{
    _model = model;
    
    self.userObjectID = model.userID;
    //self.iconImageView.image = [UIImage imageNamed:model.userIconImage];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.userIconImage]];
    self.nameLabel.text = model.userName;
    self.sexImageView.image = [UIImage imageNamed:model.sex];
    self.publishTimeLabel.text = model.publishTime;
    self.schoolLabel.text = model.school;
    self.nowPriceLabel.text = [NSString stringWithFormat:@"￥%.1f", model.nowPrice];
    self.originalPriceLabel.text = [NSString stringWithFormat:@"￥%.1f", model.originalPrice];
    self.descriptionLabel.text = model.productDescription;
    self.locationLabel.text = model.location;
}

#pragma mark ---------- action --------------

- (void)commentProduct:(id)selector
{
    SecondhandMessageVO *commentVO = [[SecondhandMessageVO alloc] init];
    
    UserMO *userMO = [UserInfoSingleton sharedManager].userMO;
    if (userMO == nil) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"评论必须登陆" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [ac addAction:okAction];
        [self presentViewController:ac animated:YES completion:nil];
    }
    
    commentVO.userID = userMO.user_id;
    commentVO.userName = userMO.user_name;
    NSLog(@"%@", commentVO.userName);
    commentVO.userIconImage = userMO.head_image_url;
    commentVO.productID = self.model.productID;
    commentVO.toUserID = self.model.userID;
    commentVO.toUserName = self.model.userName;
    
    self.commentVO = commentVO;
    
    [self.commentInputField becomeFirstResponder];
}

- (void)moreBtnAction
{
    
}

#pragma --mark --------------------Responding to keyboard events-----------------------

- (void)adjustTextViewByKeyboardState:(BOOL)showKeyboard keyboardInfo:(NSDictionary *)info
{
    UIViewAnimationCurve animationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    UIViewAnimationOptions animationOptions = UIViewAnimationOptionBeginFromCurrentState;
    if (animationCurve == UIViewAnimationCurveEaseIn) {
        animationOptions |= UIViewAnimationOptionCurveEaseIn;
    }
    else if (animationCurve == UIViewAnimationCurveEaseInOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseInOut;
    }
    else if (animationCurve == UIViewAnimationCurveEaseOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseOut;
    }
    else if (animationCurve == UIViewAnimationCurveLinear) {
        animationOptions |= UIViewAnimationOptionCurveLinear;
    }
    
    CGFloat height = 0;
    
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (showKeyboard) {
        NSValue *keyboardFrameVal = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = [keyboardFrameVal CGRectValue];
        height = keyboardFrame.size.height;
        
        // 设置评论框的弹出
        [UIView animateWithDuration:animationDuration delay:0 options:animationOptions animations:^{
            self.commentInputField.frame = CGRectMake(0, screenHeightPCH - screenHeightPCH * 0.08f - height, screenWidthPCH, screenHeightPCH * 0.08f);
        } completion:^(BOOL finished){
            
        }];
    } else {
        // 隐藏评论框
        [UIView animateWithDuration:animationDuration delay:0 options:animationOptions animations:^{
            self.commentInputField.frame = CGRectMake(0, screenHeightPCH - screenHeightPCH * 0.08f, screenWidthPCH, screenHeightPCH * 0.08f);
        } completion:^(BOOL finished){
            
        }];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    self.isKeyboardPopup = YES;
    [self adjustTextViewByKeyboardState:YES keyboardInfo:userInfo];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    self.isKeyboardPopup = NO;
    [self adjustTextViewByKeyboardState:NO keyboardInfo:userInfo];
}

#pragma mark --------------------UITextFieldDelegate----------------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.commentInputField.text = @"";
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //self.commentVO.content = textField.text;
    [textField resignFirstResponder];
    if ([textField.text length] > 0) {
        [self.activityIndicatorView startAnimating];
        self.commentVO.content = textField.text;
        [self.bl createComment:self.commentVO];
    }
    return YES;
}

#pragma mark --------------------tableViewDelegate-----------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:IDD_MESSAGE];
    cell.model = [self.messageArray objectAtIndex:indexPath.row];
    cell.frameModel = [self.frameArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageFrameModel *frameModel = self.frameArray[indexPath.row];
    return frameModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取留言的对象
    SecondhandMessageVO *commentTo = self.messageArray[indexPath.row];
    SecondhandMessageVO *commentVO = [[SecondhandMessageVO alloc] init];
    
    UserMO *userMO = [UserInfoSingleton sharedManager].userMO;
    if (userMO == nil) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"评论必须登陆" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [ac addAction:okAction];
        [self presentViewController:ac animated:YES completion:nil];
    }
    
    commentVO.userID = userMO.user_id;
    commentVO.userName = userMO.user_name;
    commentVO.userIconImage = userMO.head_image_url;
    commentVO.productID = self.model.productID;
    commentVO.toUserName = commentTo.userName;
    commentVO.toUserID = commentTo.userID;
    self.commentVO = commentVO;
    
    [self.commentInputField becomeFirstResponder];
}

// tableViewFooter点击加载更多
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.isAllCommentLoaded) {
        return 0;
    } else {
        return HTRefreshViewHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    CommentFooterView *footerView = [[CommentFooterView alloc] initWithFrame:CGRectMake(0, 0, winSize.width, HTRefreshViewHeight)];
    footerView.delegate = self;
    self.footerView = footerView;
    
    return footerView;
}

#pragma --mark --------------------加载更多FooterView的Delegate-----------------------

- (NSMutableArray *)loadMoreComment
{
    NSLog(@"读取更多评论");
    // 查询评论
    [self.bl findSecondhandMessage:self.model.productID];
    return nil;
}

#pragma --mark --------------------SecondhandMessageBLDelegate-----------------------

- (void)findSecondhandMessageFinished:(NSMutableArray *)list
{
    //self.messageArray = list;
    
    for (SecondhandMessageVO *obj in list) {
        [self.messageArray addObject:obj];
    }
    self.frameArray = [MessageFrameModel frameModelWithArray:self.messageArray];
    [self.tab reloadData];
    
    // 加载了评论数据后，需要调整高度
    self.detailScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.skimView.frame) + HTPartBar+ self.tab.contentSize.height + screenHeightPCH *0.08f);
    
    NSLog(@"content height is %f", self.tab.contentSize.height);
    NSLog(@"frame height is %f", self.tab.frame.size.height);
    
    // 为什么这样可以
    if (self.tab.contentSize.height > self.tab.frame.size.height) {
        CGPoint oldOrigin = self.tab.frame.origin;
        self.tab.frame = CGRectMake(oldOrigin.x, oldOrigin.y, self.tab.frame.size.width, self.tab.contentSize.height);
    }
    
    // 如果这次加载的评论数量少于每次固定加载的评论，则说明更多的评论已经加载完了
    if ([list count] < CommentLimit) {
        self.isAllCommentLoaded = YES;
        // 需要主动更新界面
        self.tab.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        // 【因为我们设置过footer的高度，tableview的contentsize在计算时会把footer的高度计算进来】,
        //  所以这里最后要减去一个footer高度
        //  亡羊补牢，最后frame总会高出一个FOOTER高度，所以这里减去
        CGRect finalBounds = CGRectMake(self.tab.frame.origin.x, self.tab.frame.origin.y, self.tab.frame.size.width, self.tab.frame.size.height - HTRefreshViewHeight);
        [self.tab reloadData];
        self.tab.frame = finalBounds;
        [self.view setNeedsDisplay];
    }
    
    [self.activityIndicatorView stopAnimating];
}

- (void)findSecondhandMessageFailed:(NSError *)error
{
    
}

- (void)insertCommentFinished:(SecondhandMessageVO *)model
{
    //[self.messageArray addObject:model];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    model.publishTime = dateStr;
    
    [self.messageArray insertObject:model atIndex:0];
    //[self.frameArray addObject:[MessageFrameModel frameModelWithModel:model]];
    [self.frameArray insertObject:[MessageFrameModel frameModelWithModel:model] atIndex:0];
    
    [self.tab reloadData];
    
    // 需要更新整个ScrollView的contentSize
    self.detailScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.skimView.frame) + HTPartBar+ self.tab.contentSize.height + screenHeightPCH *0.08f);
    
    NSLog(@"message tableview height is: %f", self.tab.frame.size.height);
    NSLog(@"message tableview contentSize height is: %f", self.tab.contentSize.height);
    
    // 为什么这样可以
    if (self.tab.contentSize.height > self.tab.frame.size.height) {
        CGPoint oldOrigin = self.tab.frame.origin;
        self.tab.frame = CGRectMake(oldOrigin.x, oldOrigin.y, self.tab.frame.size.width, self.tab.contentSize.height);
    }
    
    [self.activityIndicatorView stopAnimating];
}

#pragma mark --------------- getter & setter -----------------

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [_activityIndicatorView setBackgroundColor:[UIColor blackColor]];
        _activityIndicatorView.center = self.view.center;
        [self.view addSubview:_activityIndicatorView];
    }
    
    return _activityIndicatorView;
}

@end
