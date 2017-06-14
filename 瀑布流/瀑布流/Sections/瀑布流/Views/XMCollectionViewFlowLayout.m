//
//  XMCollectionViewFlowLayout.m
//  瀑布流
//
//  Created by 街路口等你 on 17/6/14.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "XMCollectionViewFlowLayout.h"


@interface XMCollectionViewFlowLayout ()

// 记录Item的总个数
@property (nonatomic, assign) NSInteger numberOfItems;

// 记录每一列的高度
@property (nonatomic, strong) NSMutableArray *columnOfHeights;

// 记录所有Item属性
@property (nonatomic, strong) NSMutableArray *attributes;

/***
 * 获取最长列的下标
 */
- (NSInteger)getLongestIndex;

/***
 * 获取最短列的下标
 */
- (NSInteger)getShortesIndex;

/***
 * 布局每一个Item
 */
- (void)calculatePositionOfItems;


@end

@implementation XMCollectionViewFlowLayout

#pragma mark - 懒加载

- (NSMutableArray *)columnOfHeights {
    if (!_columnOfHeights) {
        self.columnOfHeights = [NSMutableArray array];
    }
    return _columnOfHeights;
}

- (NSMutableArray *)attributes {
    if (!_attributes) {
        self.attributes = [NSMutableArray array];
    }
    return _attributes;
}

#pragma mark - 获取最长列的下标

- (NSInteger)getLongestIndex {
    CGFloat height = 0;
    NSInteger index = 0;  //记录最长列下标
    
    //遍历高度数组
    for (int i = 0; i < self.columnOfHeights.count; i++) {
        CGFloat currentHeight = [_columnOfHeights[i] floatValue];
        if (currentHeight > height) {
            //记录高度和下标
            height = currentHeight;
            index = i;
        }
    }
    return index;
}

#pragma mark - 获取最短列的下标

- (NSInteger)getShortesIndex {
    CGFloat height = MAXFLOAT;
    NSInteger index = 0; // 记录最短列下标
    
    // 遍历高度数组
    for (int i = 0; i < self.columnOfHeights.count; i++) {
        CGFloat currentHeight = [_columnOfHeights[i] floatValue];
        if (currentHeight < height) {
            // 记录高度和下标
            height = currentHeight;
            index = i;
        }
    }
    return index;
}

#pragma mark - 布局每一个item

- (void)calculatePositionOfItems {
    // 获取item的总个数
    self.numberOfItems = [self.collectionView numberOfItemsInSection:0];
    
    // 计算有效宽度
    CGFloat width = self.collectionView.frame.size.width - self.sectionInsets.left - self.sectionInsets.right;
    
    // 计算缝隙
    self.itemSpacing = (width - self.itemSize.width * self.numberOfColumns) / (self.numberOfColumns - 1);
    
    // 初始每一列的高度
    for (int i = 0; i < self.numberOfColumns; i++) {
        self.columnOfHeights[i] = @(self.sectionInsets.top);
    }
    
    // 计算每一个item的位置属性
    for (int i = 0; i < self.numberOfItems; i++) {
        // 设置indexPath
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        // 获取每一个item的高度
        CGFloat height = 0;
        
        if ([self.delegate respondsToSelector:@selector(waterFlowLayout:heightForItemAtIndexPath:)]) {
            height = [self.delegate waterFlowLayout:self heightForItemAtIndexPath:indexPath];
        }
        
        // 获取最短列索引
        NSInteger index = [self getShortesIndex];
        
        // 计算 x, y
        CGFloat x = self.sectionInsets.left + (self.itemSize.width + self.itemSpacing) * index;
        CGFloat y = [self.columnOfHeights[index] floatValue];
        
        // 计算item的属性
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        // 计算frame
        attribute.frame = CGRectMake(x, y, self.itemSize.width, height);
        
        // 放入数组
        [self.attributes addObject:attribute];
        
        // 更新高度
        self.columnOfHeights[index] = @(y + self.itemSpacing + height);
    }
}

#pragma mark - 重写系统方法

- (void)prepareLayout {
    [super prepareLayout];
    
    // 计算 item
    [self calculatePositionOfItems];
}

/***
 * 计算 contentSize
 */
- (CGSize)collectionViewContentSize {
    // 获取之前的内容的大小
    CGSize contentSize = self.collectionView.contentSize;
    
    // 获取最长列下标
    NSInteger index = [self getLongestIndex];
    
    // 获取最长列高度
    CGFloat height = [self.columnOfHeights[index] floatValue];
    
    // 更新高度
    contentSize.height = height;
    return contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributes;
}



@end
