//
//  PhotoCollectionViewFlow.m
//  test123
//
//  Created by tom555cat on 16/6/1.
//  Copyright © 2016年 Hello World Corporation. All rights reserved.
//

#import "PhotoCollectionViewFlow.h"

@interface PhotoCollectionViewFlow ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation PhotoCollectionViewFlow

/**
 *   准备好布局时调用
 **/
- (void)prepareLayout
{
    [super prepareLayout];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    // 遍历所有的item，重新布局
    for (NSUInteger idx = 0; idx < count; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [self.array addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 通过indexPath创建一个item属性attr
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    
    // 获取图片次序
    /*
     *
     *
     */
    
    CGFloat itemW = 0;
    CGFloat itemH = 0;
    CGRect frame = CGRectZero;
    NSInteger idx = indexPath.item;
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    switch (idx) {
        case 0:
            // 照相
            itemW = winSize.width / 2.0f;
            itemH = itemW;
            frame.size = CGSizeMake(itemW, itemH);
            frame.origin = CGPointMake(0, 0);
            attr.frame = frame;
            break;
        
        case 1:
            // 相片
            itemW = winSize.width / 4.0f;
            itemH = itemW;
            frame.size = CGSizeMake(itemW, itemH);
            frame.origin = CGPointMake(winSize.width/2.0f, 0);
            attr.frame = frame;
            break;
            
        case 2:
            // 相片
            itemW = winSize.width / 4.0f;
            itemH = itemW;
            frame.size = CGSizeMake(itemW, itemH);
            frame.origin = CGPointMake(winSize.width * 3.0f / 4.0f, 0);
            attr.frame = frame;
            break;
            
        case 3:
            // 相片
            itemW = winSize.width / 4.0f;
            itemH = itemW;
            frame.size = CGSizeMake(itemW, itemH);
            frame.origin = CGPointMake(winSize.width/2.0f, winSize.width/4.0f);
            attr.frame = frame;
            break;
            
        case 4:
            // 相片
            itemW = winSize.width / 4.0f;
            itemH = itemW;
            frame.size = CGSizeMake(itemW, itemH);
            frame.origin = CGPointMake(winSize.width * 3.0f / 4.0f, winSize.width/4.0f);
            attr.frame = frame;
            break;
        
        default:
            // 其他照片
            itemW = winSize.width / 4.0f;
            itemH = itemW;
            frame.size = CGSizeMake(itemW, itemH);
            
            switch (idx % 4) {
                case 1:
                    x = 0.0f;
                    y = ((int)((idx - 1) / 4) - 1) * 0.25f * winSize.width + winSize.width / 2.0f;
                    frame.origin = CGPointMake(x, y);
                    attr.frame = frame;
                    break;
                    
                case 2:
                    x = winSize.width / 4.0f;
                    y = ((int)((idx - 1) / 4) - 1) * 0.25f * winSize.width + winSize.width / 2.0f;
                    frame.origin = CGPointMake(x, y);
                    attr.frame = frame;
                    break;
                    
                case 3:
                    x = winSize.width / 2.0f;
                    y = ((int)((idx - 1) / 4) - 1) * 0.25f * winSize.width + winSize.width / 2.0f;
                    frame.origin = CGPointMake(x, y);
                    attr.frame = frame;
                    break;
                    
                case 0:
                    x = winSize.width * 0.75f;
                    y = ((int)((idx - 1) / 4) - 1) * 0.25f * winSize.width + winSize.width / 2.0f;
                    frame.origin = CGPointMake(x, y);
                    attr.frame = frame;
                    break;
                    
                default:
                    break;
            }
            NSLog(@"x: %f, y: %f, width: %f, height: %f", x, y, itemW, itemH);
            
            break;
    }
    
    //NSLog(@"orgin x: %f, y: %f, width: %f, height: %f", attr.frame.origin.x, attr.frame.origin.y, attr.frame.size.width, attr.frame.size.height);
    return attr;
}

/**
 *    设置可滚动区域范围
 **/
- (CGSize)collectionViewContentSize
{
    CGSize size = self.collectionView.frame.size;
    CGFloat maxHeight = 0;
    for (NSUInteger idx = 0; idx < [_array count]; idx++) {
        CGRect tempFrame = ((UICollectionViewLayoutAttributes *)_array[idx]).frame;
        CGFloat height = tempFrame.origin.y + tempFrame.size.height;
        if (height > maxHeight) {
            maxHeight = height;
        }
    }
    
    size.height = maxHeight;
    return size;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return _array;
}


#pragma mark ------------ getter & setter --------------

- (NSMutableArray *)array
{
    if (!_array) {
        _array = [[NSMutableArray alloc] init];
    }
    
    return _array;
}

@end
