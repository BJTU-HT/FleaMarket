//
//  PublishSecondhandVC.m
//  FleaMarket
//
//  Created by tom555cat on 16/9/19.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import <BmobSDK/BmobUser.h>
#import <BmobSDK/Bmob.h>
#import "PublishSecondhandVC.h"
#import "UITextField+RYNumberKeyboard.h"
#import "PlaceholderTextView.h"
#import "UploadImageCell.h"
#import "UploadImageModel.h"
#import "ImagePickerVC.h"
#import "CollectionDataModel.h"
#import "NewPriceView.h"
#import "OldPriceView.h"
#import "CategoryChooseView.h"
#import "UserInfoSingleton.h"
#import "SecondhandVO.h"
#import "SecondhandBL.h"
#import "SecondhandBLDelegate.h"
#import "LocationViewController.h"
#import "ItemCategoryViewController.h"
#import "MBProgressHUD.h"


@interface PublishSecondhandVC () <UITableViewDataSource, UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, AddMoreImgDelegate, SecondhandBLDelegate, ChooseLocationDelegate, ChooseCategoryDelegate>
@property (nonatomic, strong) UITextField *titleInputView;
@property (nonatomic, strong) PlaceholderTextView *descriptionInputView;
@property (nonatomic, strong) UICollectionView *uploadImagesCollectionView;
@property (nonatomic, strong) NewPriceView *nowPriceView;
@property (nonatomic, strong) OldPriceView *oldPriceView;
@property (nonatomic, strong) CategoryChooseView *categoryView;
// 保存上传照片后返回的URL array
@property (nonatomic, strong) NSMutableArray *imagesURLArray;
// 当前二手物品的分类
@property (nonatomic, strong) NSString *itemCategory;
@property (nonatomic, strong) NSString *viceCategory;
// 当前学校
@property (nonatomic, strong) NSString *school;
// 业务
@property (nonatomic, strong) SecondhandBL *bl;
// 菊花
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation PublishSecondhandVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.school = @"选择学校";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    [self initSubmitBtn];
    [self setLeftItemBtn];
    
    // 触摸其他位置，收回键盘
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGR.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGR];
}

- (void)initViews
{
    self.navigationItem.title = @"发布";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidthPCH, screenHeightPCH - 50) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)initSubmitBtn
{
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, screenHeightPCH - 50, screenWidthPCH, 50)];
    submitBtn.backgroundColor = [UIColor redColor];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *btnAttributeString = [[NSMutableAttributedString alloc] initWithString:@"确定发布" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FontSize16,NSParagraphStyleAttributeName:paragraphStyle}];
    [submitBtn setAttributedTitle:btnAttributeString forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(publishSecondhand) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}

- (void)setLeftItemBtn
{
    /*
    UINavigationItem *navItem = self.navigationItem;
    UIBarButtonItem *quitBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closePublish)];
    navItem.leftBarButtonItem = quitBtn;
     */
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(closePublish)];
}

- (BOOL)navigationShouldPopOnBackButton
{
    [self closePublish];
    return YES;
}

#pragma mark --- action ---
- (void)closePublish
{
    [self.delegate deleteSelectedImgs];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 触摸其他地方，回收键盘
- (void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [self.titleInputView resignFirstResponder];
    [self.descriptionInputView resignFirstResponder];
}

// 添加更多的图片按钮点击事件
- (void)addMoreImgTapAction
{
    // 判断collectionData[0]的image是否为空，如果为空，那么当前的提交是由浏览大图中提交的；
    // 如果不为空，则是由缩略图中提交的。
    
    // 重置collectionData的选中状态
    /*
     for (int i = 0; i < self.collectionData.count; i++) {
     CollectionDataModel *model = self.collectionData[i];
     model.selected = NO;
     }
     */
    
    if ([self.tableData count] == 0 && [self.collectionData count] == 0) {
        [self getPhotoAssetCollections];
    }
    
    // 每次重新选择图片，都重置掉之前的选择
    for (long i = 0; i < self.collectionData.count; i++) {
        CollectionDataModel *model = self.collectionData[i];
        model.selected = NO;
    }
    
    ImagePickerVC *imgPickVC = [[ImagePickerVC alloc] init];
    imgPickVC.tableData = self.tableData;
    imgPickVC.collectionData = self.collectionData;
    imgPickVC.hidesBottomBarWhenPushed = YES;
    imgPickVC.delegate = self;
    //imgPickVC.flag = YES;            // 新增加图片，flag为YES
    //imgPickVC.selectedArray = selectedArray;
    
    [self.navigationController pushViewController:imgPickVC animated:YES];
}

// 获取所有的相册
- (void)getPhotoAssetCollections
{
    // 获得相机胶卷
    PHAssetCollection *assetCollection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    [self.tableData addObject:assetCollection];
    
    // 遍历所有的自定义相簿
    PHFetchResult *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (PHAssetCollection *assetCollection in assetCollections) {
        [self.tableData addObject:assetCollection];
    }
    
    //[self enumerateAssetsInAssetCollection:assetCollection2 original:YES];
    
    if ([self.tableData count]) {
        [self getCollectionData:0];
    }
}

// 获取胶卷相册的所有图片
- (void)getCollectionData:(NSInteger)tag
{
    if (self.collectionData.count) {
        [self.collectionData removeAllObjects];
    }
    
    // 将“拍照”照片添加入collectionData
    CollectionDataModel *dataModel = [[CollectionDataModel alloc] init];
    dataModel.img = [UIImage imageNamed:@"takePicture.png"];
    [self.collectionData addObject:dataModel];
    
    // 将相机胶卷assetCollection的内容加入到collectionData中
    [self enumerateAssetsInAssetCollection:self.tableData[tag] original:YES];
}

- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection
                                original:(BOOL)original
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    
    // 获得某个相册薄中的所有PHAsset对象
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    NSMutableArray *assets = [[NSMutableArray alloc] init];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PHAsset class]]) {
            [assets addObject:obj];
        }
    }];
    
    for (PHAsset *asset in assets) {
        CollectionDataModel *dataModel = [[CollectionDataModel alloc] init];
        dataModel.asset = asset;
        dataModel.selected = NO;
        [self.collectionData addObject:dataModel];
    }
}

- (void)publishSecondhand
{
    UserMO *userMO = [UserInfoSingleton sharedManager].userMO;
    if (userMO == nil) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"发布必须先登陆" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [ac addAction:okAction];
        [self presentViewController:ac animated:YES completion:nil];
        return;
    }
    
    SecondhandVO *model = [[SecondhandVO alloc] init];
    model.productName = self.titleInputView.text;
    model.originalPrice = self.oldPriceView.originalPrice;
    model.nowPrice = self.nowPriceView.nowPrice;
    model.productDescription = self.descriptionInputView.text;
    //20160718 add userID by hou
    model.userID = userMO.user_id;
    model.userName = userMO.user_name;
    model.userIconImage = userMO.head_image_url;
    model.sex = userMO.gender;
    
    // 提取上传图片的url
    NSMutableArray *imageURLArray = [[NSMutableArray alloc] init];
    for (UploadImageModel *model in self.selectedImgArray) {
        [imageURLArray addObject:model.url];
    }
    model.pictureArray = imageURLArray;
    
    if (![self.categoryView.category isEqualToString:@"选择分类:"]) {
        NSLog(@"%@", self.categoryView.category);
        model.mainCategory = self.itemCategory;
        model.viceCategory = self.viceCategory;
    }
    
    if (![self.school isEqualToString:@"选择学校"]) {
        model.location = self.school;
        model.school = self.school;
        NSLog(@"%@", model.location);
    }
    
    if (model.productName == nil || model.productDescription == nil || model.pictureArray.count == 0 ||
        model.location == nil || model.nowPrice == 0 || model.mainCategory == nil || model.viceCategory == nil) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"必须包含标题，描述，至少一张图片，学校，价格以及物品分类" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //code
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self.bl createSecondhand:model];
        
        // 旋转菊花
        self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        self.hud.label.text = NSLocalizedString(@"发布中", @"HUD loading title");
    }
}

// 选择学校
- (void)chooseLocation
{
    LocationViewController *locVC = [[LocationViewController alloc] initWithFrame:self.view.frame];
    locVC.delegate = self;
    [self.navigationController pushViewController:locVC animated:NO];
}

// 选择商品分类
- (void)chooseCategory
{
    ItemCategoryViewController *itemCategoryVC = [[ItemCategoryViewController alloc] initWithFrame:self.view.frame];
    itemCategoryVC.delegate = self;
    [self.navigationController pushViewController:itemCategoryVC animated:NO];
}

#pragma mark --------------- ChooseCategoryDelegate ------------------

- (void)chooseCategory:(NSString *)mainCategory category:(NSString *)category
{
    self.itemCategory = mainCategory;
    self.viceCategory = category;
    self.categoryView.category = category;
}

#pragma mark --------------- ChooseLocationDelegate ------------------

- (void)chooseLocation:(NSString *)locationStr
{
    self.school = locationStr;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    cell.textLabel.text = locationStr;
}

#pragma mark ------------------- SecondhandBL delegate -------------------

- (void)publishSecondhandFinished
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 发布时的菊花停止
        [self.hud hideAnimated:YES];
        
        // 发布成功提示
        self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        self.hud.mode = MBProgressHUDModeCustomView;
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.hud.customView = [[UIImageView alloc] initWithImage:image];
        // Looks a bit nicer if we make it square.
        self.hud.square = YES;
        self.hud.label.text = NSLocalizedString(@"发布成功", @"HUD done title");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.hud hideAnimated:YES];
            self.tabBarController.selectedIndex = 0;
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    });
}

- (void)publishSecondhandFailed
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 发布时的菊花停止
        [self.hud hideAnimated:YES];
        
        // 发布成功提示
        self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        self.hud.mode = MBProgressHUDModeCustomView;
        self.hud.square = YES;
        self.hud.label.text = NSLocalizedString(@"发布失败", @"HUD done title");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.hud hideAnimated:YES];
            self.tabBarController.selectedIndex = 0;
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    });
}

#pragma mark ------------------- AddMoreImgDelegate --------------------
- (void)addMoreImg:(NSMutableArray *)selectedArray
{
    if ([selectedArray count] == 0) {
        return;
    }
    
    for (NSInteger idx = 0; idx < selectedArray.count; idx++) {
        CollectionDataModel *model = selectedArray[idx];
        UploadImageModel *uploadModel = [[UploadImageModel alloc] init];
        
        if (model.asset) {
            // 获取照片资源
            PHImageManager *imageManager = [PHImageManager defaultManager];
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.synchronous = YES;
            [imageManager requestImageForAsset:model.asset
                                    targetSize:PHImageManagerMaximumSize
                                   contentMode:PHImageContentModeDefault
                                       options:options
                                 resultHandler:^(UIImage *result, NSDictionary *info) {
                                     uploadModel.img = result;
                                     uploadModel.isUploaded = NO;
                                     [self.selectedImgArray addObject:uploadModel];
                                 }];
        } else if (model.img) {
            uploadModel.img = model.img;
            uploadModel.isUploaded = NO;
            [self.selectedImgArray addObject:uploadModel];
        }
    }
    
    [self.uploadImagesCollectionView reloadData];
}

// 选中增加更多图片的按钮时，当选了更多的图片时，更新当前的collectionData
/*
- (void)addMoreImg:(NSMutableArray *)collectionData
{
    // 如果参数collectionData和当前的collectionData的数目一致，那么是从ImagePickerVC返回的
    // collectionData数据，需要从1开始，避开相机图片；
    // 否则是从PreViewController返回的,collectionData数据，没有相机图片，需要从1开始。
    
    if ([collectionData count] == 0) {
        return;
    }
    
    CollectionDataModel *model = collectionData[0];
    // 如果第一张图片是个“拍照”图标，则不需要上传
    int i = (model.img == nil) ? 0 : 1;
    for ( ; i < collectionData.count; i++) {
        CollectionDataModel *model = collectionData[i];
        if (model.selected) {
            UploadImageModel *uploadModel = [[UploadImageModel alloc] init];
            
            // 获取照片资源
            PHImageManager *imageManager = [PHImageManager defaultManager];
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.synchronous = YES;
            [imageManager requestImageForAsset:model.asset
                                    targetSize:PHImageManagerMaximumSize
                                   contentMode:PHImageContentModeDefault
                                       options:options
                                 resultHandler:^(UIImage *result, NSDictionary *info) {
                                     uploadModel.img = result;
                                     uploadModel.isUploaded = NO;
                                     [self.selectedImgArray addObject:uploadModel];
                                 }];
            //uploadModel.img = model.img;
            //uploadModel.isUploaded = NO;
            //[self.selectedImgArray addObject:uploadModel];
        }
    }
    [self.uploadImagesCollectionView reloadData];
    
}
 */


#pragma mark --- CollectionViewDelegate ---
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    /*
    if ((self.selectedImgArray.count + 1 >= 1) && (self.selectedImgArray.count + 1 <= 4) ) {
        self.uploadImagesCollectionView.frame = CGRectMake(collectionX, collectionY, collectionW, itemH);
    } else if ((self.selectedImgArray.count + 1 > 4) && (self.selectedImgArray.count + 1 <=8 ) ) {
        self.uploadImagesCollectionView.frame = CGRectMake(collectionX, collectionY, collectionW, 2 * itemH);
    }
     */
    
    //[self relayoutSubviews];
    return self.selectedImgArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UploadImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"uploadcollectioncell" forIndexPath:indexPath];
    
    // 最后一个, 是新添加相片的一个按钮
    if (indexPath.item == self.selectedImgArray.count) {
        cell.contentImg = [UIImage imageNamed:@"square_add"];
        [cell.dropImageBtn setHidden:YES];
        [cell.circleProgress setHidden:YES];
        //[cell.circleProgress removeFromSuperview];
        
        UITapGestureRecognizer *addMoreImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addMoreImgTapAction)];
        [cell addGestureRecognizer:addMoreImgTap];
        
    } else {
        UploadImageModel *model = self.selectedImgArray[indexPath.item];
        
        __weak UploadImageCell *weakCell = cell;
        //__weak PublishDetailVC *weakSelf = self;
        __weak PublishSecondhandVC *weakSelf = self;
        cell.contentImg = model.img;
        [cell.dropImageBtn setHidden:NO];
        cell.dropCurrentChooseImg = ^(){
            [weakSelf.selectedImgArray removeObjectAtIndex:indexPath.item];
            [weakSelf.uploadImagesCollectionView reloadData];
            //[weakSelf.imagesURLArray removeObjectAtIndex:indexPath.item];
            // 删除上传的图片
        };
        
        // 如果已经上传，则返回
        if (model.isUploaded) {
            return cell;
        }
        
        // 上传
        NSData *imgData = UIImageJPEGRepresentation(model.img, 0.5);
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"上传测试.png", @"filename", imgData, @"data", nil];
        NSArray *array = @[dic];
        
        [BmobFile filesUploadBatchWithDataArray:array progressBlock:^(int index, float progress) {
            weakCell.circleProgress.progressValue = progress;
        } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
            if (error) {
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"上传失败" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:ac animated:NO completion:nil];
                [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(createAlert:) userInfo:ac repeats:NO];
            } else {
                // 上传成功
                if (!weakSelf) {
                    return;
                }
                
                model.isUploaded = YES;
                [weakCell.circleProgress setHidden:YES];
                
                for (int i = 0; i < array.count; i++) {
                    BmobFile *file = array[i];
                    [self.imagesURLArray addObject:file.url];
                    model.url = file.url;
                    //NSLog(@"%@", self.imagesURLArray[i]);
                }
            }
        }];
    }
    
    return cell;
}

- (void)createAlert:(NSTimer *)timer{
    UIAlertController *alert = [timer userInfo];
    [alert dismissViewControllerAnimated:YES completion:nil];
    alert = nil;
}

#pragma mark --- UITableViewDelegate ---

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    } else {
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:      // 二手商品标题
                height = 50;
                break;
            case 1:      // 文字描述
                height = 150;
                break;
            case 2:      // 上传图片区域
                height = (screenWidthPCH - Margin * 2.0f) / 4.0f + Margin * 2;
                break;
            case 3:      // 选择学校
                height = 50;
                break;
            default:
                break;
        }
    } else {
        height = 50;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidthPCH, 0)];
    //headerView.backgroundColor = RGB(239, 239, 244);
    //headerView.backgroundColor = [UIColor redColor];
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidthPCH, 0)];
    //footerView.backgroundColor = RGB(239, 239, 244);
    //footerView.backgroundColor = [UIColor yellowColor];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 商品标题输入
            static NSString *cellIdentifier = @"titleinputcell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            [cell.contentView addSubview:self.titleInputView];
            return cell;
            
        } else if (indexPath.row == 1) {
            // 商品描述输入
            static NSString *cellIdentifier = @"secondhanddescriptioncell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            [cell.contentView addSubview:self.descriptionInputView];
            return cell;
            
        } else if (indexPath.row == 2) {
            // 上传照片的collectionView
            static NSString *cellIdentifier = @"uploadpicturescell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            [cell.contentView addSubview:self.uploadImagesCollectionView];
            return cell;
            
        } else {
            // 选择学校
            static NSString *cellIdentifier = @"schoolchoosecell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            [cell.imageView setImage:[UIImage imageNamed:@"location"]];
            cell.textLabel.font = FontSize14;
            cell.textLabel.text = self.school;
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }

    } else {
        if (indexPath.row == 0) {
            // 价格标注
            static NSString *cellIdentifier = @"nowpricecell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.nowPriceView];
            
            return cell;
            
        } else if (indexPath.row == 1) {
            // 价格标注
            static NSString *cellIdentifier = @"oldpricecell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.oldPriceView];
            
            return cell;

        } else {
            // 二手商品分类
            static NSString *cellIdentifier = @"secondhandcategorycell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.contentView addSubview:self.categoryView];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 选择学校
        if (indexPath.row == 3) {
            [self chooseLocation];
        }
    } else {
        // 选择分类
        if (indexPath.row == 2) {
            [self chooseCategory];
        }
    }
}

#pragma mark --- getter && setter ---

- (NSMutableArray *)imagesURLArray
{
    if (!_imagesURLArray) {
        _imagesURLArray = [[NSMutableArray alloc] init];
    }
    
    return _imagesURLArray;
}

- (NSMutableArray *)selectedImgArray
{
    if (!_selectedImgArray) {
        _selectedImgArray = [[NSMutableArray alloc] init];
    }
    
    return _selectedImgArray;
}

- (NSMutableArray *)tableData
{
    if (!_tableData) {
        _tableData = [[NSMutableArray alloc] init];
    }
    
    return _tableData;
}

- (NSMutableArray *)collectionData
{
    if (!_collectionData) {
        _collectionData = [[NSMutableArray alloc] init];
    }
    
    return _collectionData;
}

- (CategoryChooseView *)categoryView
{
    if (!_categoryView) {
        _categoryView = [[CategoryChooseView alloc] initWithFrame:CGRectMake(Margin, Margin/2.0f, screenWidthPCH - Margin*2, 40)];
    }
    
    return _categoryView;
}

- (NewPriceView *)nowPriceView
{
    if (!_nowPriceView) {
        _nowPriceView = [[NewPriceView alloc] initWithFrame:CGRectMake(Margin, Margin/2.0f, screenWidthPCH - Margin*2, 40)];
    }
    
    return _nowPriceView;
}

- (OldPriceView *)oldPriceView
{
    if (!_oldPriceView) {
        _oldPriceView = [[OldPriceView alloc] initWithFrame:CGRectMake(Margin, Margin/2.0f, screenWidthPCH - Margin*2, 40)];
    }
    
    return _oldPriceView;
}

- (UITextField *)titleInputView
{
    if (!_titleInputView) {
        _titleInputView = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, screenWidthPCH-30, 40)];
        [_titleInputView setFont:FontSize14];
        _titleInputView.placeholder = @"输入商品标题";
    }
    
    return _titleInputView;
}

- (PlaceholderTextView *)descriptionInputView
{
    if (!_descriptionInputView) {
        _descriptionInputView = [[PlaceholderTextView alloc] initWithFrame:CGRectMake(5, 5, screenWidthPCH-10, 140)];
        [_descriptionInputView setFont:FontSize14];
        _descriptionInputView.myPlaceholder = @"请输入描述文字";
        _descriptionInputView.myPlaceholderColor = [UIColor lightGrayColor];
    }
    
    return _descriptionInputView;
}

- (UICollectionView *)uploadImagesCollectionView
{
    if (!_uploadImagesCollectionView) {
        CGFloat margin = 10.0f;
        CGFloat itemW = (screenWidthPCH - margin * 2.0f) / 4.0f;
        CGFloat itemH = itemW;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        
        _uploadImagesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(Margin, Margin/2.0f, screenWidthPCH-2*Margin, itemH) collectionViewLayout:flowLayout];
        _uploadImagesCollectionView.dataSource = self;
        _uploadImagesCollectionView.delegate = self;
        _uploadImagesCollectionView.backgroundColor = [UIColor whiteColor];
        [_uploadImagesCollectionView registerClass:[UploadImageCell class] forCellWithReuseIdentifier:@"uploadcollectioncell"];
    }
    
    return _uploadImagesCollectionView;
}

- (SecondhandBL *)bl
{
    if (!_bl) {
        _bl = [SecondhandBL new];
        _bl.delegate = self;
    }
    
    return _bl;
}

@end
