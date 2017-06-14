//
//  XMCollectionViewFlowLayout.h
//  瀑布流
//
//  Created by 街路口等你 on 17/6/14.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import <UIKit/UIKit.h>



@class XMCollectionViewFlowLayout;
@protocol XMFlowLayoutDelegate <NSObject>

// 获取高度
- (CGFloat)waterFlowLayout:(XMCollectionViewFlowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface XMCollectionViewFlowLayout : UICollectionViewLayout

// item 大小
@property (nonatomic, assign) CGSize itemSize;

// 列数
@property (nonatomic, assign) NSInteger numberOfColumns;

// 间距
@property (nonatomic, assign) UIEdgeInsets sectionInsets;

// item 之间的间距
@property (nonatomic, assign) CGFloat itemSpacing;

// 代理的属性
@property (nonatomic, weak) id<XMFlowLayoutDelegate> delegate;


@end
