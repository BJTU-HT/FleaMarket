//
//  PreViewController.m
//  test123
//
//  Created by tom555cat on 16/5/24.
//  Copyright © 2016年 Hello World Corporation. All rights reserved.
//

#import "PreViewController.h"
#import "PreViewCell.h"
#import "ShowIMGModel.h"
#import "BackBtn.h"
#import "CollectionDataModel.h"
#import "SelectedPhotoCollectionViewLayout.h"
#import "ThumbnailCollectionViewCell.h"
#import "UploadImageModel.h"
//#import "PublishDetailVC.h"
#import "PublishSecondhandVC.h"

#define WIDTH_PIC       self.view.frame.size.width
#define HEIGHT_PIC      self.view.frame.size.height

@interface PreViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DeleteSelectedImgDelegate>

@property (nonatomic, assign) NSInteger nowNum;

@property (nonatomic, strong) UICollectionView *collectionView;

// ToolBar背景UIView
@property (nonatomic, strong) UIView *toolBarBGView;
// 提交选择图片按钮
@property (nonatomic, strong) UIButton *toolBarRightBtn;
// NavigationItem的是否选中按钮
@property (nonatomic, strong) UIButton *rightItemBtn;
// 选中图片的缩略图
@property (nonatomic, strong) UICollectionView *thumbnailCollectionView;


@end

@implementation PreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nowNum = 0;
    
    [self createNav];
    [self createCollectionView];
    [self setupToolBar];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.pageNum-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------------ private -------------

- (void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing      = 0;
    flowLayout.itemSize                = CGSizeMake(WIDTH_PIC, HEIGHT_PIC);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_PIC, HEIGHT_PIC) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.contentSize = CGSizeMake(WIDTH_PIC, HEIGHT_PIC);
    [self.collectionView registerClass:[PreViewCell class] forCellWithReuseIdentifier:@"preView"];
    [self.view addSubview:self.collectionView];
}

- (void)createNav
{
    self.title = [NSString stringWithFormat:@"%ld/%lu",self.pageNum,(unsigned long)self.collectionData.count];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    /*
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 23, 23);
    [leftBtn setImage:[UIImage imageNamed:@"back_03.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    */
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_03.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    
    self.rightItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightItemBtn.frame = CGRectMake(0, 0, 23, 23);
    [self.rightItemBtn setImage:[UIImage imageNamed:@"PicNull"] forState:UIControlStateNormal];
    [self.rightItemBtn setImage:[UIImage imageNamed:@"selected_orange"] forState:UIControlStateSelected];
    [self.rightItemBtn addTarget:self action:@selector(rightItemBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightItemBtn];

    //NSLog(@"current Page num: %ld", self.pageNum);
    CollectionDataModel *model = self.collectionData[self.pageNum - 1];
    if (model.selected) {
        self.rightItemBtn.selected = YES;
    }
    
    /*
     ShowIMGModel *model = self.imgModelArray[self.pageNum];
     if (model.selected) {
     self.rightItemBtn.selected = YES;
     }
     */
    
}

- (void)setupToolBar
{
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    
    // toolbar主界面
    self.toolBarBGView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT_PIC-64, WIDTH_PIC, 64)];
    self.toolBarBGView.backgroundColor = [UIColor colorWithRed:0.97 green:0.98 blue:1 alpha:1];
    [self.view addSubview:self.toolBarBGView];
    
    // 选中图片缩略图
    SelectedPhotoCollectionViewLayout *collectionLayout = [[SelectedPhotoCollectionViewLayout alloc] init];
    UICollectionView *thumbnailCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
    thumbnailCollectionView.frame = CGRectMake(10, 0, winSize.width * 0.6f, 64);
    thumbnailCollectionView.delegate = self;
    thumbnailCollectionView.dataSource = self;
    [thumbnailCollectionView registerNib:[UINib nibWithNibName:@"ThumbnailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"thumbnailcollectioncell"];
    self.thumbnailCollectionView = thumbnailCollectionView;
    self.thumbnailCollectionView.backgroundColor = self.toolBarBGView.backgroundColor;
    [self.toolBarBGView addSubview:self.thumbnailCollectionView];
    
    // 右功能按钮
    CGFloat btnH = 30;
    CGFloat btnW = 60;
    CGFloat btnX = WIDTH_PIC - 70;
    CGFloat btnY = self.toolBarBGView.frame.size.height / 2.0f - btnH / 2.0f;
    self.toolBarRightBtn = [BackBtn createBtnWithFram:CGRectMake(btnX, btnY, btnW, btnH) WithTitle:@"确定" andSelectTitle:@"确定" andIMG:nil andSelectIMG:nil andTitleColor:[UIColor whiteColor] andSelectColor:[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] andTarget:self andAction:@selector(toolBarRightBtnClick)];
    
    self.toolBarRightBtn.layer.cornerRadius     = 3;
    self.toolBarRightBtn.layer.masksToBounds    = YES;
    self.toolBarRightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.toolBarRightBtn.selected = YES;
    self.toolBarRightBtn.backgroundColor = [UIColor colorWithRed:0.91 green:0.93 blue:0.94 alpha:1];
    [self.toolBarBGView addSubview:self.toolBarRightBtn];
    
    // 设置按钮的显示
    if (self.selectedArray.count) {
        self.toolBarRightBtn.selected = NO;
        [self.toolBarRightBtn setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.selectedArray.count] forState:UIControlStateNormal];
        self.toolBarRightBtn.backgroundColor = [UIColor colorWithRed:225/255.0 green:33/255.0 blue:64/255.0 alpha:1];
    }
}


#pragma mark ------------ action ---------------

// 提交选择的图片
- (void)toolBarRightBtnClick
{
    if (self.moreImgdelegate) {
        //[self.moreImgdelegate addMoreImg:self.collectionData];
        [self.moreImgdelegate addMoreImg:self.selectedArray];
        long index= [[self.navigationController viewControllers] indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2] animated:YES];
    } else {
        // 调用代理获取图片
        // ...根据ImagePickerVC中的toolBarightBtnClick方法去写
        // 获取选中的图片
        NSMutableArray *choosedImageArray = [[NSMutableArray alloc] init];
        /*
        for (int i = 0; i < self.collectionData.count; i++) {
            CollectionDataModel *model = self.collectionData[i];
            if (model.selected == YES) {
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
                                         [choosedImageArray addObject:uploadModel];
                                     }];
            }
        }
        */
        
        for (NSInteger idx = 0; idx < self.selectedArray.count; idx++) {
            CollectionDataModel *model = self.selectedArray[idx];
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
                                         [choosedImageArray addObject:uploadModel];
                                     }];
            } else if (model.img) {
                uploadModel.img = model.img;
                uploadModel.isUploaded = NO;
                [choosedImageArray addObject:uploadModel];
            }
        }
        /*
        PublishDetailVC *publishDetailVC = [[PublishDetailVC alloc] init];
        publishDetailVC.selectedImgArray = choosedImageArray;
        publishDetailVC.delegate = self;
         */
        
        PublishSecondhandVC *publishDetailVC = [[PublishSecondhandVC alloc] init];
        publishDetailVC.selectedImgArray = choosedImageArray;
        publishDetailVC.delegate = self;
        
        [self.navigationController pushViewController:publishDetailVC animated:YES];
    }
}

- (void)backBtnClick
{
    [self.delegate updateSelectedArray:self.selectedArray];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemBtnClick
{
    if (self.rightItemBtn.selected) {
        self.rightItemBtn.selected = NO;
        NSLog(@"current now num is %ld", self.nowNum);
        CollectionDataModel *model = self.collectionData[self.nowNum];
        //PHAsset *img = model.img;
        PHAsset *asset = model.asset;
        //UIImage *img = self.collectionData[self.nowNum];
        //[self.selectedArray removeObject:asset];
        [self.selectedArray removeObject:model];
        // 设置collectionData对应的selected为NO
        /*
        for (int i = 0; i < self.collectionData.count; i++) {
            CollectionDataModel *model = self.collectionData[i];
            if (asset == model.asset) {
                model.selected = NO;
                break;
            }
        }
         */
        model.selected = NO;
        
        // self.selectBlock(self.selectedArray,model,NO);
        [self.thumbnailCollectionView reloadData];
        
        if (self.selectedArray.count) {
            self.toolBarRightBtn.selected = NO;
            self.toolBarRightBtn.backgroundColor = [UIColor colorWithRed:225/255.0 green:33/255.0 blue:64/255.0 alpha:1];
        } else {
            self.toolBarRightBtn.selected = YES;
            self.toolBarRightBtn.backgroundColor = [UIColor colorWithRed:0.91 green:0.93 blue:0.94 alpha:1];
        }
        [self.toolBarRightBtn setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.selectedArray.count] forState:UIControlStateNormal];
        
    } else {
        self.rightItemBtn.selected = YES;
        //UIImage *img = self.collectionData[self.nowNum];
        CollectionDataModel *model = self.collectionData[self.nowNum];
        //UIImage *img = model.img;
        PHAsset *asset = model.asset;
        //[self.selectedArray addObject:asset];
        [self.selectedArray addObject:model];
        // 设置collectionData对应的selected为YES
        /*
        for (int i = 0; i < self.collectionData.count; i++) {
            CollectionDataModel *model = self.collectionData[i];
            if (asset == model.asset) {
                model.selected = YES;
                break;
            }
        }
         */
        model.selected = YES;
        
        self.toolBarRightBtn.selected = NO;
        
        [self.thumbnailCollectionView reloadData];
        
        [self.toolBarRightBtn setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.selectedArray.count] forState:UIControlStateNormal];
        //self.toolBarRightBtn.titleLabel.text = [NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.selectedArray.count];
        self.toolBarRightBtn.backgroundColor = [UIColor colorWithRed:225/255.0 green:33/255.0 blue:64/255.0 alpha:1];
    }
}

#pragma mark --------------- DeleteSelectedImgDelegate ---------------
// 当发布二手商品后或撤销二手商品发布，重置图片选中状态
- (void)deleteSelectedImgs
{
    for (long i = 0; i < self.collectionData.count; i++) {
        CollectionDataModel *model = self.collectionData[i];
        model.selected = NO;
    }
}

#pragma mark ------------ ScrollDelegate ----------------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.nowNum = scrollView.contentOffset.x / self.view.bounds.size.width;
    self.title = [NSString stringWithFormat:@"%ld/%lu",self.nowNum + 1,(unsigned long)self.collectionData.count];
    
    CollectionDataModel *model = self.collectionData[self.nowNum];
    if (model.selected) {
        self.rightItemBtn.selected = YES;
    } else {
        self.rightItemBtn.selected = NO;
    }
    
    /*
     UIImage *img = self.collectionData[self.nowNum];
     if ([self.selectedArray containsObject:img]) {
     self.rightItemBtn.selected = YES;
     } else {
     self.rightItemBtn.selected = NO;
     }
     */
}

#pragma mark ------------ CollectionViewDelegate ---------------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.collectionView) {
        return self.collectionData.count;
    } else if (collectionView == self.thumbnailCollectionView) {
        return self.selectedArray.count;
    } else {
        return 0;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView) {
        PreViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"preView" forIndexPath:indexPath];
        CollectionDataModel *model = self.collectionData[indexPath.row];
        //cell.asset = model.asset;
        cell.model = model;
        return cell;
    } else if (collectionView == self.thumbnailCollectionView) {
        ThumbnailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"thumbnailcollectioncell" forIndexPath:indexPath];
        __weak PreViewController *weakSelf = self;
        __weak ThumbnailCollectionViewCell *weakCell = cell;
        //PHAsset *asset = [self.selectedArray objectAtIndex:indexPath.item];
        CollectionDataModel *model = [self.selectedArray objectAtIndex:indexPath.item];
        //cell.asset = asset;
        cell.model = model;
        cell.dropSelectedBlock = ^(void) {
            //PHAsset *currentAsset = weakCell.asset;
            //[weakSelf.selectedArray removeObject:asset];
            [weakSelf.selectedArray removeObject:model];
            
            /*
            for (int i = 0; i < self.collectionData.count; i++) {
                CollectionDataModel *data = self.collectionData[i];
                if (asset == data.asset) {
                    data.selected = NO;
                    break;
                }
            }
             */
            model.selected = NO;
            
            // 更新按钮状态
            //[weakSelf.toolBarRightBtn setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)weakSelf.selectedArray.count] forState:UIControlStateNormal];
            weakSelf.toolBarRightBtn.titleLabel.text = [NSString stringWithFormat:@"确定(%lu)",(unsigned long)weakSelf.selectedArray.count];
            // 如果是删除的这个cell与当前collectionView展示的cell是一样的，则将当前rightItemBtn设置为没有选中
            CollectionDataModel *model = self.collectionData[self.nowNum];
            //NSLog(@"nowNum is %@", model.img);
            //NSLog(@"cell tag is %@", weakCell.contentImg);
            /*************************************************************/
            /*
            if (weakCell.asset == model.asset) {
                weakSelf.rightItemBtn.selected = NO;
            }
             */
            
            // 更新collectionView
            [weakSelf.collectionView reloadData];
            [weakSelf.thumbnailCollectionView reloadData];
        };
        
        return cell;
        
    } else {
        return nil;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize collectionSize = {WIDTH_PIC, HEIGHT_PIC};
    return collectionSize;
}

#pragma mark ------------ getter & setter -------------

- (NSMutableArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [[NSMutableArray alloc] init];
    }
    
    return _selectedArray;
}

- (NSMutableArray *)imgModelArray
{
    if (!_imgModelArray) {
        _imgModelArray = [[NSMutableArray alloc] init];
    }
    
    return _imgModelArray;
}

- (NSMutableArray *)collectionData
{
    if (!_collectionData) {
        _collectionData = [[NSMutableArray alloc] init];
    }
    
    return _collectionData;
}

@end
