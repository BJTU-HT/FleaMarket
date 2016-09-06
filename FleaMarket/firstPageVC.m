//
//  firstPageVC.m
//  FleaMarket
//
//  Created by Hou on 4/7/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "firstPageVC.h"
#import "SecondhandViewController.h"
#import "BookPublishVC.h"
#import "BookMainPageVC.h"

@interface firstPageVC ()

@end

@implementation firstPageVC

@synthesize scrollViewDisCovery;
float screenWidthDis;
float screenHeightDis;
float detectDistance;
float statusBarHegiht;
float navBarHeight;
float navBarwidth;
UIColor *viewLineColor;
UIColor *viewLineWhiteSmoke;
UIView *navgationView;
float flag;
UILabel *refreshLabel;

-(void)viewDidLoad
{
    [super viewDidLoad];
    scrollViewDisCovery = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    screenWidthDis = self.view.bounds.size.width;
    screenHeightDis = self.view.bounds.size.height;
    statusBarHegiht = [UIApplication sharedApplication].statusBarFrame.size.height;
    scrollViewDisCovery.contentSize = CGSizeMake(self.view.bounds.size.width, 1140);
    scrollViewDisCovery.frame = CGRectMake(0, -20, screenWidthDis, screenHeightDis);
    scrollViewDisCovery.showsVerticalScrollIndicator = NO;
    self.navigationController.navigationBarHidden = YES;
    viewLineColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    viewLineWhiteSmoke = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    scrollViewDisCovery.delegate = self;
    [self.view insertSubview:scrollViewDisCovery atIndex:0];
    navBarHeight = self.navigationController.navigationBar.frame.size.height + statusBarHegiht;
    navBarwidth = screenWidthDis;
    navgationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, navBarwidth, navBarHeight)];
    [self drawDis];
    flag = 1;
    
    //添加刷新效果
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -50, 320, 50)];
    refreshLabel.text  = @"下拉刷新";
    refreshLabel.tag = 0;
    [scrollViewDisCovery addSubview:refreshLabel];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
-(void)drawDis
{
    //搜索框上方图片相应参数
    float firstPicPer = 0.3;
    detectDistance = screenHeightDis * firstPicPer;
    //logo 和搜索框处参数
    float logo_gap = 0.02;
    float logo_X_offset = 0.02;
    float logo_Y_offset = screenHeightDis * (firstPicPer + logo_gap);
    float logoViewPer = 0.09;
    float logoHeight = screenHeightDis * (logoViewPer - 2 * logo_gap);
    //旅行日记
    float logoName_X_offset = (0.02 + logoHeight/screenWidthDis) * screenWidthDis;
    float logoNmae_Y_offset = logo_Y_offset;
    float labelNamePx = 20;
    float labelNameFont = labelNamePx *3/4;
    float logoNmaeWidth = labelNameFont * 5;
    float logoNmaeHeight = logoHeight;
    //搜索框
    float logoSearch_X_Offset = logoName_X_offset + logoNmaeWidth;
    float logoSearch_Y_Offset = logo_Y_offset;
    float logoSearchWidth = screenWidthDis - logoSearch_X_Offset - screenWidthDis * logo_X_offset;
    float logoSearchHeight = logoNmaeHeight;
    float logoSearchFont = 20 * 3/4;
    float logoSearchImageWidth = logoSearchHeight * 0.8;
    float logoSearchImageHeight = logoSearchHeight * 0.8;
    float logoSearchText_X_offset = logoSearchImageWidth;
    float logoSearchTextWidth = logoSearchWidth - logoSearchImageWidth;
    
    //分割线
    float viewLine_Y_offset = (firstPicPer + logoViewPer) * screenHeightDis;
    float viewLineHeight = 0.0008 * screenHeightDis;
    
    //搜索框上方图片
    UIImageView *imageFirstPag = [[UIImageView alloc] init];
    imageFirstPag.image = [UIImage imageNamed:@"picFirstPag.jpg"];
    imageFirstPag.frame = CGRectMake(0, 0, screenWidthDis, screenHeightDis * firstPicPer);
    [scrollViewDisCovery addSubview:imageFirstPag];
    
    //logo和搜索框
    UIImageView *imageLogo = [[UIImageView alloc] init];
    imageLogo.image = [UIImage imageNamed:@"Icon-76@2x.png"];
    imageLogo.frame = CGRectMake(screenWidthDis * logo_X_offset, logo_Y_offset, logoHeight, logoHeight);
    [scrollViewDisCovery addSubview:imageLogo];
    
    //logo 文字 采用24px字
    UILabel *labelName = [[UILabel alloc] init];
    labelName.text = @"书香人家";
    labelName.frame = CGRectMake(logoName_X_offset, logoNmae_Y_offset, logoNmaeWidth, logoNmaeHeight);
    labelName.font = [UIFont systemFontOfSize:labelNameFont];
    labelName.textAlignment = NSTextAlignmentCenter;
    [scrollViewDisCovery addSubview:labelName];
    
    //搜索框
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(logoSearch_X_Offset, logoSearch_Y_Offset, logoSearchWidth, logoSearchHeight)];
    searchButton.layer.borderWidth = 1.0;
    searchButton.layer.borderColor = [UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0].CGColor;
    
    UIImageView *imageViewSearch = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, logoSearchImageWidth, logoSearchImageHeight)];
    imageViewSearch.image = [UIImage imageNamed:@"search@2x.png"];
    [searchButton addSubview:imageViewSearch];
    
    UILabel *labelContent = [[UILabel alloc] initWithFrame:CGRectMake(logoSearchText_X_offset, 0, logoSearchTextWidth, logoSearchHeight)];
    labelContent.text = @"搜索目的地/书籍等";
    labelContent.textAlignment = NSTextAlignmentCenter;
    labelContent.textColor = [UIColor lightGrayColor];
    labelContent.font = [UIFont systemFontOfSize:logoSearchFont];
    [searchButton addSubview:labelContent];
    [scrollViewDisCovery addSubview:searchButton];
    
    UIView *viewLineLogo = [[UIView alloc] initWithFrame:CGRectMake(0, viewLine_Y_offset, screenWidthDis, viewLineHeight)];
    viewLineLogo.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    [scrollViewDisCovery addSubview:viewLineLogo];
    
    float buttonWidth_Height = 48.0;
    float vertical_gap = 20.0;
    float button_left_right_gap = (screenWidthDis -buttonWidth_Height * 4)/5;
    float button_Y_offset = viewLine_Y_offset + vertical_gap;
    
    float button_label_gap = 10.0;
    float label_y_offset = button_Y_offset + buttonWidth_Height + button_label_gap;
    float labelPX = 18;
    float labelFont = labelPX * 3/4;
    float label_height = labelPX * 3/4;
    float label_width = label_height * 5;
    
    float line2_button_y_gap = vertical_gap + buttonWidth_Height + button_label_gap + label_height;
    float line2_label_y_gap = label_height + vertical_gap + buttonWidth_Height + button_label_gap;
    
    //分割线
    float view2Line_y_offset = label_y_offset + line2_label_y_gap + label_height + vertical_gap;
    float imageTagCount = 0;//用于标记按钮tag
    for(int i = 0; i < 2; i++)
    {
        for(int j = 0; j < 4; j++)
        {
            float imageButton_x_offset = button_left_right_gap * (j + 1) + j * buttonWidth_Height;
            float label_x_offset = imageButton_x_offset + buttonWidth_Height/2 - label_width/2;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(label_x_offset, label_y_offset + i * line2_label_y_gap, label_width, label_height)];
            UIImageView *imageButton = [[UIImageView alloc] initWithFrame:CGRectMake(imageButton_x_offset, button_Y_offset + i * line2_button_y_gap, buttonWidth_Height, buttonWidth_Height)];
            //添加点击手势
            UITapGestureRecognizer *imageBtnGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageBtnTouchUpInside:)];
            [imageButton addGestureRecognizer:imageBtnGestureRecognizer];
            imageButton.userInteractionEnabled = YES;
            imageButton.tag = imageTagCount++;
            label.font = [UIFont systemFontOfSize: labelFont];
            label.textAlignment = NSTextAlignmentCenter;
            switch (j) {
                case 0:
                    if(i == 0)
                    {
                        label.text = @"二手市场";
                        imageButton.image = [UIImage imageNamed:@"1@2x.png"];
                    }
                    else
                    {
                        label.text = @"赠送专区";
                        imageButton.image = [UIImage imageNamed:@"5@2x.png"];
                    }
                    break;
                case 1:
                    if(i == 0)
                    {
                        label.text = @"书籍推荐";
                        imageButton.image = [UIImage imageNamed:@"2@2x.png"];
                    }
                    else
                    {
                        label.text = @"精品展示";
                        imageButton.image = [UIImage imageNamed:@"6@2x.png"];
                    }
                    break;
                case 2:
                    if(i == 0)
                    {
                        label.text = @"聊天记录";
                        imageButton.image = [UIImage imageNamed:@"3@2x.png"];
                    }
                    else
                    {
                        label.text = @"问达人";
                        imageButton.image = [UIImage imageNamed:@"7@2x.png"];
                    }
                    break;
                case 3:
                    if(i == 0)
                    {
                        label.text = @"灌水专区";
                        imageButton.image = [UIImage imageNamed:@"4@2x.png"];
                    }
                    else
                    {
                        label.text = @"书籍借阅";
                        imageButton.image = [UIImage imageNamed:@"8@2x.png"];
                    }
                    break;
                default:
                    break;
            }
            [scrollViewDisCovery addSubview:label];
            [scrollViewDisCovery addSubview:imageButton];
        }
        
        
    }
    UIView *viewLine2 = [[UIView alloc] init];
    viewLine2.frame = CGRectMake(0, view2Line_y_offset, screenWidthDis, viewLineHeight);
    viewLine2.backgroundColor = viewLineColor;
    [scrollViewDisCovery addSubview: viewLine2];
    
    //今日top1 采用字号 20 18 14 px
    float labelTopFont = 20 * 3/4;
    float borderGap = screenWidthDis * 0.03;
    float vertical_borderGap = labelTopFont;
    float imageTopHeight = labelTopFont;
    float imageTop_x_offset = borderGap;
    float imageTopWidth = 0.01 * screenWidthDis;
    float labelTop_y_offset = view2Line_y_offset + labelTopFont;
    float labelTop_x_offset = imageTop_x_offset + imageTopWidth + borderGap;
    float labelTop_width = labelTopFont * 5;
    float labelTop_Height = labelTopFont;
    
    float lastTermFont = 14 * 3/4;
    float topRightImageWidth = lastTermFont * 1.5;
    float topRightImageHeight = topRightImageWidth;
    float topRightImage_x_offset = screenWidthDis - borderGap - topRightImageWidth;
    float topRIghtImage_y_offset = labelTop_y_offset + labelTop_Height/2 - topRightImageHeight/2;
    //5个字
    float topRightLabel_width = lastTermFont * 5;
    float topRightLabel_height = lastTermFont;
    float topRightLabel_x_offset = screenWidthDis - borderGap - topRightLabel_width - topRightImageWidth;
    float topRightLabel_y_offset = labelTop_y_offset + labelTop_Height/2 - topRightLabel_height/2;
    
    // 按钮添加图片
    float top_whole_height = 300;
    float buttonTop_y_offset = labelTop_y_offset + vertical_borderGap + labelTop_Height;
    float buttonTop_x_offset = borderGap;
    float buttonTop_width = screenWidthDis - 2 * borderGap;
    float buttonTop_height = top_whole_height - labelTop_Height - 3 * vertical_borderGap;
    //分割线
    float viewLineTopBottom_y_offset = view2Line_y_offset + top_whole_height + 10;
    
    //针对按钮内图文编排
    float buttonImageHeight = 0.7 * buttonTop_height;
    float buttonHead_width = 0.2 * buttonTop_height;
    float buttonHead_height = buttonHead_width;
    float buttonHead_x_offset = buttonTop_width/2 - buttonHead_width/2;
    float buttonHead_y_offset = buttonImageHeight - buttonHead_height/2;
    
    float buttonNameLabelFont = 18 * 3/4;
    //20
    float buttonNameLabelWidth = buttonNameLabelFont * 20;
    float buttonNameLabelHeight = buttonNameLabelFont;
    float buttonNameLabel_x_offset = buttonTop_width/2 - buttonNameLabelWidth/2;
    float buttonNameLabel_y_offset = buttonHead_y_offset + buttonHead_height + 0.05 * buttonTop_height;
    
    float buttonLabelSignatureFont = 20 * 3/4;
    float buttonLabelSignatureWidth = buttonLabelSignatureFont * 25;
    float buttonLabelSignatureHeight = buttonLabelSignatureFont;
    float buttonLabelSignature_x_offset = screenWidthDis/2 - buttonLabelSignatureWidth/2;
    float buttonLabelSignature_y_offset = buttonNameLabel_y_offset + buttonNameLabelHeight + 0.05 * buttonTop_height;
    
    UIImageView *imageViewImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageTop_x_offset, labelTop_y_offset, imageTopWidth, imageTopHeight)];
    imageViewImage.image = [UIImage imageNamed:@"titBar@2x.png"];
    
    UILabel *labelTop = [[UILabel alloc] initWithFrame:CGRectMake(labelTop_x_offset, labelTop_y_offset, labelTop_width, labelTop_Height)];
    labelTop.text = @"今日Top1";
    labelTop.font = [UIFont systemFontOfSize:labelTopFont];
    
    UIImageView *imageViewRightImage = [[UIImageView alloc] initWithFrame:CGRectMake(topRightImage_x_offset, topRIghtImage_y_offset, topRightImageWidth, topRightImageHeight)];
    imageViewRightImage.image = [UIImage imageNamed:@"topRightImage@2x.png"];
    
    UILabel *labelRight = [[UILabel alloc] initWithFrame:CGRectMake(topRightLabel_x_offset, topRightLabel_y_offset, topRightLabel_width, topRightLabel_height)];
    labelRight.text = @"往期Top1";
    labelRight.font = [UIFont systemFontOfSize:lastTermFont];
    labelRight.textColor = [UIColor lightGrayColor];
    
    UIButton *buttonTop = [[UIButton alloc] initWithFrame:CGRectMake(buttonTop_x_offset, buttonTop_y_offset, buttonTop_width, buttonTop_height)];
    
    UIImageView *imageViewButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, buttonTop_width, buttonImageHeight)];
    imageViewButton.image = [UIImage imageNamed:@"pic3.jpg"];
    
    UIImageView *imageHeadBtn = [[UIImageView alloc] initWithFrame:CGRectMake(buttonHead_x_offset, buttonHead_y_offset, buttonHead_width, buttonHead_height)];
    imageHeadBtn.image = [UIImage imageNamed:@"headImage.png"];
    
    UILabel *labelNameBtn = [[UILabel alloc] initWithFrame:CGRectMake(buttonNameLabel_x_offset, buttonNameLabel_y_offset, buttonNameLabelWidth, buttonNameLabelHeight)];
    labelNameBtn.text = @"爱旅行的小妞 在 纽约";
    labelNameBtn.textColor = [UIColor lightGrayColor];
    labelNameBtn.textAlignment = NSTextAlignmentCenter;
    labelNameBtn.font = [UIFont systemFontOfSize:buttonNameLabelFont];
    
    UILabel *labelSigBtn = [[UILabel alloc] initWithFrame: CGRectMake(buttonLabelSignature_x_offset, buttonLabelSignature_y_offset, buttonLabelSignatureWidth, buttonLabelSignatureHeight)];
    labelSigBtn.text = @"我就是爱旅游，你来打我呀...";
    labelSigBtn.font = [UIFont systemFontOfSize:buttonLabelSignatureFont];
    labelSigBtn.textAlignment = NSTextAlignmentCenter;
    
    [buttonTop insertSubview:imageViewButton atIndex:0];
    [buttonTop insertSubview:imageHeadBtn atIndex:1];
    [buttonTop insertSubview:labelNameBtn atIndex:0];
    [buttonTop insertSubview:labelSigBtn atIndex:0];
    
    UIView *viewLineTopBottom = [[UIView alloc] initWithFrame:CGRectMake(0, viewLineTopBottom_y_offset, screenWidthDis, viewLineHeight * 20)];
    viewLineTopBottom.backgroundColor = viewLineWhiteSmoke;
    
    [scrollViewDisCovery addSubview:viewLineTopBottom];
    [scrollViewDisCovery addSubview:buttonTop];
    [scrollViewDisCovery addSubview:labelRight];
    [scrollViewDisCovery addSubview:imageViewRightImage];
    [scrollViewDisCovery addSubview:imageViewImage];
    [scrollViewDisCovery addSubview:labelTop];
    
    //目的地推荐部分  desRec destination recommend
    float labelDesRecFont = labelTopFont;
    float imageDesRecHeight = labelDesRecFont;
    float imageDesRecWidth = imageTopWidth;
    float imageDesRec_x_offset = borderGap;
    float imageDesRec_y_offset = viewLineTopBottom_y_offset + viewLineHeight * 20 + labelTopFont;
    float labelDesRecHeight = imageDesRecHeight;
    float labelDesRecWidth = labelDesRecFont * 5;
    float labelDesRec_x_offset = imageDesRec_x_offset + imageDesRecWidth + borderGap;
    float labelDesRec_y_offset = imageDesRec_y_offset;
    
    // 六个按钮
    float desRecBtn_gap =  screenWidthDis * 0.05;
    float desRecButton_width = (screenWidthDis - 2 * borderGap - 2 * desRecBtn_gap)/3;
    float desRecButton_height = desRecButton_width * 1.5;
    float desRecBtn_x_offset = imageDesRec_x_offset;
    float desRecBtn_y_offset = labelDesRec_y_offset + 2 * labelDesRecHeight;
    float desRecBtn_vertical_gap = labelDesRecFont;
    
    //button 内部内容参数
    float desRecBtn_image_height = desRecButton_height * 0.6;
    float desRecBtn_image_width = desRecButton_width;
    
    float desRecBtn_labelMonth_font = 18 * 3/4;
    float desRecBtn_labelMonth_width = 2 * desRecBtn_labelMonth_font;
    float desRecBtn_labelMonth_height = desRecBtn_labelMonth_font;
    float desRecBtn_labelMonth_x_offset = desRecButton_width/2 - desRecBtn_labelMonth_width/2;
    float desRecBtn_labelMonth_y_offset = desRecBtn_image_height + desRecButton_height * 0.05;
    
    float desRecBtn_label_tag_font = 14 * 3/4;
    float desRecBtn_label_tag_width = desRecButton_width;
    float desRecBtn_label_tag_y_offset = desRecBtn_labelMonth_y_offset + desRecBtn_labelMonth_height + desRecButton_height * 0.05;
    float desRecBtn_label_tag_height = 3 * desRecBtn_label_tag_font;
    
    //查看更多按钮
    float findMoreBtn_font = 20 * 3/4;
    float findMoreBtn_width = findMoreBtn_font * 12;
    float findMoreBtn_height = findMoreBtn_font * 2;
    float findMoreBtn_x_offset = screenWidthDis/2 - findMoreBtn_width/2;
    float findMOreBtn_y_offset = desRecBtn_y_offset + 2 * desRecButton_height + desRecBtn_label_tag_height + desRecBtn_vertical_gap;
    
    
    UIImageView *imageDesRec = [[UIImageView alloc] initWithFrame:CGRectMake(imageDesRec_x_offset, imageDesRec_y_offset, imageDesRecWidth, imageDesRecHeight)];
    imageDesRec.image = [UIImage imageNamed:@"titBar@2x.png"];
    
    UILabel *labelDesRec = [[UILabel alloc] initWithFrame:CGRectMake(labelDesRec_x_offset, labelDesRec_y_offset, labelDesRecWidth, labelDesRecHeight)];
    labelDesRec.text = @"今日六大";
    labelDesRec.font = [UIFont systemFontOfSize:labelDesRecFont];
    
    for(int i = 0; i < 2; i++)
    {
        for(int j = 0; j < 3; j++)
        {
            UIButton *desRecBtn =[[UIButton alloc] initWithFrame:CGRectMake(desRecBtn_x_offset + j * (desRecButton_width + desRecBtn_gap), desRecBtn_y_offset + i * (desRecButton_height + desRecBtn_vertical_gap), desRecButton_width, desRecButton_height)];
            UIImageView *imageDesRecBtn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, desRecBtn_image_width, desRecBtn_image_height)];
            UILabel *labelMonth = [[UILabel alloc] initWithFrame:CGRectMake(desRecBtn_labelMonth_x_offset, desRecBtn_labelMonth_y_offset, desRecBtn_labelMonth_width, desRecBtn_labelMonth_height)];
            labelMonth.font = [UIFont systemFontOfSize:desRecBtn_labelMonth_font];
            UILabel *labelDesRec = [[UILabel alloc] initWithFrame:CGRectMake(0, desRecBtn_label_tag_y_offset, desRecBtn_label_tag_width, desRecBtn_label_tag_height)];
            labelDesRec.textColor = [UIColor lightGrayColor];
            labelDesRec.font = [UIFont systemFontOfSize: desRecBtn_label_tag_font];
            labelDesRec.numberOfLines = 2;
            labelDesRec.textAlignment = NSTextAlignmentCenter;
            [desRecBtn addSubview:imageDesRecBtn];
            [desRecBtn addSubview:labelDesRec];
            [desRecBtn addSubview:labelMonth];
            switch (j) {
                case 0:
                    if(i == 0)
                    {
                        imageDesRecBtn.image = [UIImage imageNamed:@"scene2.jpg"];
                        labelMonth.text = @"4月";
                        labelDesRec.text = @"走在春末的季节里";
                    }
                    else
                    {
                        imageDesRecBtn.image = [UIImage imageNamed:@"scene3.jpg"];
                        labelMonth.text = @"5月";
                        labelDesRec.text = @"伸手接住五月的阳光";
                    }
                    break;
                case 1:
                    if(i == 0)
                    {
                        imageDesRecBtn.image = [UIImage imageNamed:@"scene4.jpg"];
                        labelMonth.text = @"6月";
                        labelDesRec.text = @"骄阳下的流光溢彩编织膨胀的景色";
                    }
                    else
                    {
                        imageDesRecBtn.image = [UIImage imageNamed:@"scene5.jpg"];
                        labelMonth.text = @"7月";
                        labelDesRec.text = @"炎夏如烈焰，旅途也疯狂";
                    }
                    break;
                case 2:
                    if(i == 0)
                    {
                        imageDesRecBtn.image = [UIImage imageNamed:@"scene7.jpg"];
                        labelMonth.text = @"8月";
                        labelDesRec.text = @"剩下的盛夏";
                    }
                    else
                    {
                        imageDesRecBtn.image = [UIImage imageNamed:@"scene8.jpg"];
                        labelMonth.text = @"9月";
                        labelDesRec.text = @"残云收夏署，新雨带秋岚";
                    }
                    break;
                    
                default:
                    break;
            }
            [scrollViewDisCovery addSubview:desRecBtn];
        }
    }
    UIButton *findMoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(findMoreBtn_x_offset, findMOreBtn_y_offset, findMoreBtn_width, findMoreBtn_height)];
    [findMoreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    [findMoreBtn setTitleColor:[UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0] forState:UIControlStateNormal];
    findMoreBtn.layer.borderWidth = 1.0;
    findMoreBtn.titleLabel.font = [UIFont systemFontOfSize:findMoreBtn_font];
    findMoreBtn.layer.borderColor = [UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0].CGColor;
    [findMoreBtn addTarget:self action:@selector(buttonTitleDestinationRecommendedClicked:) forControlEvents:UIControlEventTouchDown];
    [scrollViewDisCovery addSubview:findMoreBtn];
    [scrollViewDisCovery addSubview:imageDesRec];
    [scrollViewDisCovery addSubview:labelDesRec];
    scrollViewDisCovery.contentSize = CGSizeMake(self.view.bounds.size.width, findMOreBtn_y_offset + findMoreBtn_height + 10);
}

-(void)buttonTitleDestinationRecommendedClicked:(UIButton *)sender{
    
}
-(void)imageBtnTouchUpInside:(UITapGestureRecognizer *)recognizer
{
    switch ([recognizer view].tag) {
        case 0:
            [self firstVCJumpToSecondHandVC];
            break;
        case 1:
            NSLog(@"2");
            [self firstVCJumpToBookExchange];
            break;
        case 2:
            NSLog(@"3");
            [self firstVCJumpToBookDisplay];
            break;
        case 3:
            NSLog(@"3");
            
            break;
        case 4:
            //[self seeTravelNote];
            break;
        case 5:
            NSLog(@"3");
            
            break;
        case 6:
            NSLog(@"3");
            
            break;
        case 7:
            NSLog(@"3");
            
            break;
        default:
            break;
    }
}


//点击二手市场的界面跳转函数
-(void)firstVCJumpToSecondHandVC
{
    self.hidesBottomBarWhenPushed = YES;
    SecondhandViewController *secondHandVC = [[SecondhandViewController alloc] init];
    [self.navigationController pushViewController:secondHandVC animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}

//点击书籍交流跳转
-(void)firstVCJumpToBookExchange{
    self.hidesBottomBarWhenPushed = YES;
    BookPublishVC *bookPub = [[BookPublishVC alloc] init];
    [self.navigationController pushViewController:bookPub animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}
//点击进入书籍展示页面
-(void)firstVCJumpToBookDisplay{
    self.hidesBottomBarWhenPushed = YES;
    BookMainPageVC *bookMainPage = [[BookMainPageVC alloc] init];
    [self.navigationController pushViewController:bookMainPage animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}
// 检测滑动距离
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f", scrollView.contentOffset.y);
    if(scrollView.contentOffset.y > detectDistance)
    {
        if(flag == 1)
        {
            navgationView.backgroundColor = viewLineWhiteSmoke;
            float logo_gap = 0.02;
            float logo_X_offset = 0.02;
            float logo_Y_offset = navBarHeight * 0.05 + statusBarHegiht;
            float logoViewPer = 0.09;
            float logoHeight = screenHeightDis * (logoViewPer - 2 * logo_gap);
            //旅行日记
            float logoName_X_offset = (0.02 + logoHeight/screenWidthDis) * screenWidthDis;
            float logoNmae_Y_offset = logo_Y_offset;
            float labelNamePx = 20;
            float labelNameFont = labelNamePx *3/4;
            float logoNmaeWidth = labelNameFont * 5;
            float logoNmaeHeight = logoHeight;
            //搜索框
            float logoSearch_X_Offset = logoName_X_offset + logoNmaeWidth;
            float logoSearch_Y_Offset = logo_Y_offset;
            float logoSearchWidth = screenWidthDis - logoSearch_X_Offset - screenWidthDis * logo_X_offset;
            float logoSearchHeight = logoNmaeHeight;
            float logoSearchFont = 20 * 3/4;
            float logoSearchImageWidth = logoSearchHeight * 0.8;
            float logoSearchImageHeight = logoSearchHeight * 0.8;
            float logoSearchText_X_offset = logoSearchImageWidth;
            float logoSearchTextWidth = logoSearchWidth - logoSearchImageWidth;
            
            UIImageView *imageLogo = [[UIImageView alloc] init];
            imageLogo.image = [UIImage imageNamed:@"Icon-76@2x.png"];
            imageLogo.frame = CGRectMake(screenWidthDis * logo_X_offset, logo_Y_offset, logoHeight, logoHeight);
            [navgationView addSubview:imageLogo];
            //logo 文字 采用24px字
            UILabel *labelName = [[UILabel alloc] init];
            labelName.text = @"书香人家";
            labelName.frame = CGRectMake(logoName_X_offset, logoNmae_Y_offset, logoNmaeWidth, logoNmaeHeight);
            labelName.font = [UIFont systemFontOfSize:labelNameFont];
            labelName.textAlignment = NSTextAlignmentCenter;
            [navgationView addSubview:labelName];
            //搜索框
            UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(logoSearch_X_Offset, logoSearch_Y_Offset, logoSearchWidth, logoSearchHeight)];
            searchButton.layer.borderWidth = 1.0;
            searchButton.layer.borderColor = [UIColor colorWithRed:235/255.0 green:147/255.0 blue:33/255 alpha:1.0].CGColor;
            
            UIImageView *imageViewSearch = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, logoSearchImageWidth, logoSearchImageHeight)];
            imageViewSearch.image = [UIImage imageNamed:@"search@2x.png"];
            [searchButton addSubview:imageViewSearch];
            
            UILabel *labelContent = [[UILabel alloc] initWithFrame:CGRectMake(logoSearchText_X_offset, 0, logoSearchTextWidth, logoSearchHeight)];
            labelContent.text = @"搜索目的地/景点/酒店等";
            labelContent.textAlignment = NSTextAlignmentCenter;
            labelContent.textColor = [UIColor lightGrayColor];
            labelContent.font = [UIFont systemFontOfSize:logoSearchFont];
            [searchButton addSubview:labelContent];
            [navgationView addSubview:searchButton];
            
            flag = 0;
        }
        [self.view insertSubview:navgationView atIndex:1];
    }
    else
    {
        [navgationView removeFromSuperview];
    }
//    if (scrollView.contentOffset.y <= -50) {
//        
//        if (refreshLabel.tag == 0) {
//            
//            refreshLabel.text = @"松开刷新";
//            
//        }
//        
//        refreshLabel.tag = 1;
//        
//    }else{
//        
//        //防止用户在下拉到contentOffset.y <= -50后不松手，然后又往回滑动，需要将值设为默认状态
//        
//        refreshLabel.tag = 0;
//        
//        refreshLabel.text = @"下拉刷新";
//        
//    }
    
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
