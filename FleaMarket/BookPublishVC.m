//
//  BookPublishVC.m
//  FleaMarket
//
//  Created by Hou on 7/20/16.
//  Copyright © 2016 H-T. All rights reserved.
//

#import "BookPublishVC.h"
#import "presentLayerPublicMethod.h"
#import <BmobSDK/BmobUser.h>

@interface BookPublishVC ()
@property(nonatomic, strong) NSString *imageBtnURL;

@end

@implementation BookPublishVC

float pubView_y;
float clickBtnHeight;
float viewLineHeight;
NSInteger fourBtnTag;

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"书籍发布";
    //用于标记在哪个按钮状态下，上方四个按钮，默认在出售按钮下 一次 0 1 2 3
    fourBtnTag = 0;
    clickBtnHeight = 0.06 * screenHeightPCH;
    viewLineHeight = 0.005 * screenHeightPCH;
    pubView_y = clickBtnHeight + viewLineHeight;
    self.scrollViewPub = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view insertSubview: self.scrollViewPub atIndex:0];
    _scrollViewPub.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    CGRect frame = CGRectMake(0, pubView_y, self.view.frame.size.width, self.view.frame.size.height);
    self.pubView = [[BookPubView alloc] initWithFrame:frame];
    [self.scrollViewPub addSubview: _pubView];
    [_pubView.categoryBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
    [_pubView.depreciateBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
    [_pubView.bookImageBtn addTarget:self action:@selector(bookImageBtnClicked:) forControlEvents:UIControlEventTouchDown];
    [_pubView.publishBtn addTarget:self action:@selector(publishBtnClicked:) forControlEvents:UIControlEventTouchDown];
    //绘制视图顶端四个按钮
    [self initFourBtnAndViewLine];
    //键盘弹出调整视图
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    if(!_muDicBigger){
        _muDicBigger = [[NSMutableDictionary alloc] init];
    }
    _muDicSell = [[NSMutableDictionary alloc] init];
    _muDicBuy = [[NSMutableDictionary alloc] init];
    _muDicBorrow = [[NSMutableDictionary alloc] init];
    _muDicPresent = [[NSMutableDictionary alloc] init];

    // Do any additional setup after loading the view.
}
#pragma 点击发布按钮 begin
//点击发布按钮响应事件
-(void)publishBtnClicked:(UIButton *)sender{
    switch (fourBtnTag) {
        case 0:
            if([_pubView.bookName.text  isEqualToString: @"书名"] || [_pubView.author.text  isEqual: @"作者"] || [_pubView.pressHouse.text  isEqual: @"出版社"] || [_pubView.sellPrice.text  isEqual: @"出售价"] || _pubView.originalPriceField.text  == nil  || _pubView.amountField.text == nil || [_pubView.categoryBtn.titleLabel.text isEqual:@"点击选择分类"] || [_pubView.depreciateBtn.titleLabel.text isEqual:@"点击选择折旧率"]){
                [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"请完整填写出售相关发布信息"];
            }else{
                [self collectDictionaryData:fourBtnTag];
                bookPubUpLoadInfoBL *bookPubBL = [bookPubUpLoadInfoBL sharedManager];
                bookPubBL.delegateBookPubBL = self;
                [bookPubBL uploadInfoBL:_muDicBigger];
            }
            break;
        case 1:
            if([_pubView.bookName.text  isEqualToString: @"书名"] || [_pubView.author.text  isEqual: @"作者"] || [_pubView.pressHouse.text  isEqual: @"出版社"] || [_pubView.sellPrice.text  isEqual: @"求购价"] || _pubView.originalPriceField.text  == nil  || _pubView.amountField.text == nil || [_pubView.categoryBtn.titleLabel.text isEqual:@"点击选择分类"] || [_pubView.depreciateBtn.titleLabel.text isEqual:@"点击选择折旧率"]){
                [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"请完整填写求购相关发布信息"];
            }else{
                [self collectDictionaryData:fourBtnTag];
                bookPubUpLoadInfoBL *bookPubBL = [bookPubUpLoadInfoBL sharedManager];
                bookPubBL.delegateBookPubBL = self;
                [bookPubBL uploadInfoBL:_muDicBigger];
            }
            break;
        case 2:
            if([_pubView.bookName.text  isEqualToString: @"书名"] || [_pubView.author.text  isEqual: @"作者"] || [_pubView.pressHouse.text  isEqual: @"出版社"] || [_pubView.sellPrice.text  isEqual: @"丢失赔付"] || _pubView.originalPriceField.text  == nil  || _pubView.amountField.text == nil || [_pubView.categoryBtn.titleLabel.text isEqual:@"点击选择分类"] || [_pubView.depreciateBtn.titleLabel.text isEqual:@"点击选择折旧率"]){
                [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"请完整填写借阅相关发布信息"];
            }else{
                [self collectDictionaryData:fourBtnTag];
                bookPubUpLoadInfoBL *bookPubBL = [bookPubUpLoadInfoBL sharedManager];
                bookPubBL.delegateBookPubBL = self;
                [bookPubBL uploadInfoBL:_muDicBigger];
            }
            break;
        case 3:
            if([_pubView.bookName.text  isEqualToString: @"书名"] || [_pubView.author.text  isEqual: @"作者"] || [_pubView.pressHouse.text  isEqual: @"出版社"]|| _pubView.originalPriceField.text  == nil  || _pubView.amountField.text == nil || [_pubView.categoryBtn.titleLabel.text isEqual:@"点击选择分类"] || [_pubView.depreciateBtn.titleLabel.text isEqual:@"点击选择折旧率"]){
                [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"请完整填写赠送相关发布信息"];
            }else{
                [self collectDictionaryData:fourBtnTag];
                bookPubUpLoadInfoBL *bookPubBL = [bookPubUpLoadInfoBL sharedManager];
                bookPubBL.delegateBookPubBL = self;
                [bookPubBL uploadInfoBL:_muDicBigger];
            }
            break;
        default:
            break;
    }
}

// 0 1 2 3 分别对应 出售，求购，借阅， 赠送
-(void)collectDictionaryData:(NSInteger)tag{
    NSString *str = [NSString stringWithFormat:@"%ld", (long)tag];
    //出售0
    if(tag == 0){
        _muDicSell = [self pubMutableDic];
    }else if(tag == 1){
        _muDicBuy = [self pubMutableDic];
        [_muDicBuy removeObjectForKey:@"sellPrice"];
        [_muDicBuy removeObjectForKey:@"lostPay"];
        [_muDicBuy setObject:_pubView.sellPrice.text forKey:@"buyPrice"];
    }else if(tag == 2){
        _muDicBorrow = [self pubMutableDic];
        [_muDicBorrow removeObjectForKey:@"sellPrice"];
        [_muDicBorrow removeObjectForKey:@"buyPrice"];
        [_muDicBorrow setObject:_pubView.sellPrice.text forKey:@"lostPay"];
    }else if(tag == 3){
        _muDicPresent = [self pubMutableDic];
        [_muDicPresent removeObjectForKey:@"sellPrice"];
        [_muDicPresent removeObjectForKey:@"buyPrice"];
        [_muDicPresent removeObjectForKey:@"lostPay"];
    }
    [_muDicBigger setObject:str forKey:@"status"];
    [_muDicBigger setObject:_muDicSell forKey:@"sell"];
    [_muDicBigger setObject:_muDicBuy forKey:@"buy"];
    [_muDicBigger setObject:_muDicBorrow forKey:@"borrow"];
    [_muDicBigger setObject:_muDicPresent forKey:@"present"];
}

//对象非空判断在上一级函数
-(NSMutableDictionary *)pubMutableDic{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    BmobUser *curUser = [BmobUser getCurrentUser];
    //添加上传用户的objectId
    [dic setObject:curUser.objectId forKey:@"ownerObjectId"];
    [dic setObject:curUser.username forKey:@"userName"];
    [dic setObject:_pubView.bookName.text forKey:@"bookName"];
    [dic setObject:_pubView.author.text forKey:@"author"];
    [dic setObject:_pubView.pressHouse.text forKey:@"pressHouse"];
    [dic setObject:_pubView.sellPrice.text forKey:@"sellPrice"];
    [dic setObject:_pubView.originalPriceField.text forKey:@"originalPrice"];
    [dic setObject:_pubView.categoryBtn.titleLabel.text forKey:@"category"];
    [dic setObject:_pubView.amountField.text forKey:@"amount"];
    [dic setObject:_pubView.depreciateBtn.titleLabel.text forKey:@"depreciate"];
    [dic setObject:_pubView.remarkField.text forKey:@"remark"];
    //[dic setObject: self.imageBtnURL forKey:@"picURL"];
    [dic setObject:_pubView.bookImageBtn.imageView.image forKey:@"bookImage"];
    return dic;
}
#pragma 点击发布按钮 end
//图书照片
-(void)bookImageBtnClicked:(UIButton *)sender{
    [self bookImageClicked];
}
//分类和折旧这两个按钮的点击事件
-(void)btnClicked:(UIButton *)sender{
    self.cateView1 = [[CategoryView alloc] initWithFrame:[self calculateCateViewFrame:sender.tag] tag:sender.tag];
    self.cateView1.delegate12 = self;
    [self.view insertSubview: self.cateView1 atIndex:1];
    
    [self addTapGesture];
    self.scrollViewPub.userInteractionEnabled = NO;
    self.scrollViewPub.alpha = 0.2;
}

//分类和折旧回传选择的数据 tag 1 分类 tag 2 是折旧
-(void)passStrValue:(NSString *)value tag:(NSInteger)tag{
    [self.cateView1 removeFromSuperview];
    if(tag == 1){
        [_pubView.categoryBtn setTitle:value forState:UIControlStateNormal];
        [_pubView.categoryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else if(tag == 2){
        [_pubView.depreciateBtn setTitle:value forState:UIControlStateNormal];
        [_pubView.depreciateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    self.scrollViewPub.userInteractionEnabled = YES;
    self.scrollViewPub.alpha = 1.0;
}


//视图顶部四个按钮
-(void)initFourBtnAndViewLine{
    float clickBtn_y = 0;
    float clickBtnWidth = screenWidthPCH/4;
    NSArray *arr = @[@"出售", @"求购", @"借阅", @"赠送"];
    for(int i = 0; i < 4; i++){
        UIButton *clickBtn = [[UIButton alloc] init];
        clickBtn.tag = i;
        clickBtn.frame = CGRectMake(i * clickBtnWidth, clickBtn_y, clickBtnWidth, clickBtnHeight);
        [self.scrollViewPub addSubview:clickBtn];
        [clickBtn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        [clickBtn addTarget:self action:@selector(clickBtnClicked:) forControlEvents:UIControlEventTouchDown];
        if(i == 0){
            [clickBtn setTitleColor: orangColorPCH forState:UIControlStateNormal];
        }else{
            [clickBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        clickBtn.titleLabel.font = FontSize14;
        switch (i) {
            case 0:
                self.sellBtn = clickBtn;
                break;
            case 1:
                self.buyBtn = clickBtn;
                break;
            case 2:
                self.borrowBtn = clickBtn;
                break;
            case 3:
                self.donateBtn = clickBtn;
                break;
                
            default:
                break;
        }
    }
    float viewLineWidth = screenWidthPCH/4;
    if(!self.viewLine){
        self.viewLine = [[UIView alloc] init];
        [self.scrollViewPub addSubview:self.viewLine];
        self.viewLine.backgroundColor = orangColorPCH;
        self.viewLine.frame = CGRectMake(0, clickBtnHeight, viewLineWidth, viewLineHeight);
    }
}

//视图顶部四个按钮点击事件
-(void)clickBtnClicked:(UIButton *)sender{
    fourBtnTag = sender.tag;
    switch (sender.tag) {
        case 0:
            self.pubView.sellPrice.text = @" 出售价";
            [self.sellBtn setTitleColor:orangColorPCH forState:UIControlStateNormal];
            [self.borrowBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.donateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.buyBtn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
            break;
        case 1:
            self.pubView.sellPrice.text = @" 求购价";
            [self.sellBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.borrowBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.donateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.buyBtn setTitleColor: orangColorPCH forState:UIControlStateNormal];
            break;
        case 2:
            self.pubView.sellPrice.text = @" 丢失赔付";
            [self.sellBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.borrowBtn setTitleColor:orangColorPCH forState:UIControlStateNormal];
            [self.donateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.buyBtn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
            break;
        case 3:
            self.pubView.sellPrice.text = @"赠送:无需填写";
            [self.sellBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.borrowBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.donateBtn setTitleColor:orangColorPCH forState:UIControlStateNormal];
            [self.buyBtn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    [self.viewLine removeFromSuperview];
    self.viewLine.frame = CGRectMake(sender.tag * screenWidthPCH/4, clickBtnHeight, screenWidthPCH/4, 0.005 * screenHeightPCH);
    [self.scrollViewPub addSubview: self.viewLine];
}

//分类和折旧弹出后添加手势
-(void)addTapGesture{
    if (self.tapGesture == nil) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        self.tapGesture = tapGesture;
        self.tapGesture.delegate = self;
    }
    
    //将手势添加到 window 上
    if ([self.view.window.gestureRecognizers containsObject:self.tapGesture] == NO) {
        [self.view.window addGestureRecognizer:self.tapGesture];
    }
}

//手势关闭视图响应事件
- (void)handleTapGesture:(UITapGestureRecognizer *)gesture
{
    //因为是 TapGesture 的需要点击次数为 1，所以这个判断实际可以不写
    if (gesture.state == UIGestureRecognizerStateEnded) {
        //传 nil，gesture 会返回触碰点在 windiow 上的值
        CGPoint touchPoint = [gesture locationInView:nil];
        //将得到的坐标转换成与 self.view 相对应的坐标
        CGPoint convertPoint = [self.view convertPoint:touchPoint fromView:gesture.view];
        //判断触碰点是否在 self.view。bounse 中，如果在则返回，否则调用 dismiss 方法
        if (CGRectContainsPoint(self.cateView1.frame, convertPoint)) {
            return;
        }
        [self.cateView1 removeFromSuperview];
        //将手势从 window 上移除
        if ([self.view.window.gestureRecognizers containsObject:self.tapGesture]) {
            [self.view.window removeGestureRecognizer:self.tapGesture];
        }
        self.scrollViewPub.userInteractionEnabled = YES;
        self.scrollViewPub.alpha = 1.0;
    }
}

#pragma mark - UIGestureRecognizerDelegate 解决手势截获tableviewcell点击事件问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

-(CGRect)calculateCateViewFrame:(NSInteger)tag{
    CGRect cateFrame;
    float cateViewHeight;
    if(tag == 1){
        cateViewHeight = 12 * 32;
    }else if(tag == 2){
        cateViewHeight = 6 * 32;
    }else{
        cateViewHeight = 0;
    }
    float cateView_x = screenWidthPCH * 0.125;
    float cateView_y = screenHeightPCH/2 - cateViewHeight/2;
    float cateViewWidth = screenWidthPCH * 0.75;
    
    cateFrame = CGRectMake(cateView_x, cateView_y, cateViewWidth, cateViewHeight);
    return cateFrame;
}


#pragma 键盘弹出收起视图变化 begin
-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo//计算键盘的高度
{
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    return keyboardEndingFrame.size.height;
}

-(void)keyboardWillDisappear:(NSNotification *)notification
{
    CGRect currentFrame = self.view.frame;
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    currentFrame.size.height += change;
    _scrollViewPub.frame = currentFrame;
}

-(void)keyboardWillAppear:(NSNotification *)notification
{
    CGRect currentFrame = self.view.frame;
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    currentFrame.size.height = currentFrame.size.height - change;
    _scrollViewPub.frame = currentFrame;
}
#pragma 键盘弹出收起视图变化 end

#pragma 从相册选择照片或者用相机拍摄 begin
//load user image
- (void)bookImageClicked{
    UIAlertAction *takePhotoAction;
    UIAlertAction *choosePhotoAction;
    UIAlertAction *cancelAction;
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"选择图像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self jumpToCameraOrPhotoAlbum:UIImagePickerControllerSourceTypeCamera];
        }];
        choosePhotoAction = [UIAlertAction actionWithTitle:@"选择图像" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self jumpToCameraOrPhotoAlbum: UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler: nil];
        [alertCon addAction:takePhotoAction];
    }
    else {
        choosePhotoAction = [UIAlertAction actionWithTitle:@"选择图像" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self jumpToCameraOrPhotoAlbum: UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler: nil];
    }
    [alertCon addAction:choosePhotoAction];
    [alertCon addAction:cancelAction];
    [self.view.window.rootViewController presentViewController:alertCon animated:NO completion:nil];
}

#pragma mark - action sheet delegte
-(void)jumpToCameraOrPhotoAlbum:(NSUInteger) sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}
#pragma mark - action sheet delegte end

#pragma mark - image picker delegte
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey: UIImagePickerControllerEditedImage];
    [_pubView.bookImageBtn setImage:image forState:UIControlStateNormal];
}
#pragma 从相册选择照片或者用相机拍摄 end

#pragma 数据库回传代理函数 begin
//上传图片失败
-(void)uploadPicFailBL:(NSError *)error{
    if(error){
        [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"图片上传失败"];
    }
}

//上传图书信息成功 失败
-(void)uploadBookInfoFinishedBL:(BOOL)isSuccessful{
    if(isSuccessful){
        [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"发布成功"];
        //[self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)uploadBookInfoFailedBL:(NSError *)error{
    if(error){
        [presentLayerPublicMethod new_notifyView:self.navigationController notifyContent:@"发布图书信息失败，请检查网络"];
    }
}
#pragma 数据库回传代理函数 end
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
