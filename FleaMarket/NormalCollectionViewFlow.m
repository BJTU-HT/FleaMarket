//
//  NormalCollectionViewFlow.m
//  FleaMarket
//
//  Created by tom555cat on 16/8/10.
//  Copyright © 2016年 H-T. All rights reserved.
//

#import "NormalCollectionViewFlow.h"

@interface NormalCollectionViewFlow ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation NormalCollectionViewFlow

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
    
    CGFloat itemW = 0;
    CGFloat itemH = 0;
    CGRect frame = CGRectZero;
    NSInteger idx = indexPath.item;
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    
    itemW = winSize.width / 4.0f;
    itemH = itemW;
    frame.size = CGSizeMake(itemW, itemH);
    
    switch (idx % 4) {
        case 0:
            x = 0.0f;
            y = (int)(idx/4) * 0.25f * winSize.width;
            frame.origin = CGPointMake(x, y);
            attr.frame = frame;
            break;
            
        case 1:
            x = winSize.width / 4.0f;
            y = (int)(idx/4) * 0.25f * winSize.width;
            frame.origin = CGPointMake(x, y);
            attr.frame = frame;
            break;
            
        case 2:
            x = winSize.width / 2.0f;
            y = (int)(idx/4) * 0.25f * winSize.width;
            frame.origin = CGPointMake(x, y);
            attr.frame = frame;
            break;
            
        case 3:
            x = winSize.width * 0.75f;
            y = (int)(idx/4) * 0.25f * winSize.width;
            frame.origin = CGPointMake(x, y);
            attr.frame = frame;
            break;
            
        default:
            break;
    }
    
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
