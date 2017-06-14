//
//  XMCollectionViewController.m
//  瀑布流
//
//  Created by 街路口等你 on 17/6/14.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "XMCollectionViewController.h"
#import "XMCollectionViewCell.h"
#import "XMCollectionViewFlowLayout.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "XMImageModel.h"

#define kURL @"http://chanyouji.com/api/attractions/photos/%@.json?page=%ld"

@interface XMCollectionViewController ()<XMFlowLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

{
    NSInteger _page;
    BOOL _isRefresh;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *pictureArray;

@end

@implementation XMCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    
    _isRefresh = YES;
    
    [self pictureWithRequestSource];
    [self layoutWithCollectionView];
    [self layoutWithViewRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && !self.view.window) {
        self.view = nil;
    }
}

- (NSMutableArray *)pictureArray {
    if (!_pictureArray) {
        self.pictureArray = [NSMutableArray array];
    }
    return _pictureArray;
}

#pragma mark - collection view

- (void)layoutWithCollectionView {
    XMCollectionViewFlowLayout *flowLayout = [[XMCollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 15) / 2, 0);
    flowLayout.numberOfColumns = 2;
    flowLayout.delegate = self;
    flowLayout.sectionInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor colorWithRed:141 / 255.0f green:191 / 255.0f blue:209 / 255.0f alpha:1];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [self.collectionView registerClass:[XMCollectionViewCell class] forCellWithReuseIdentifier:@"街路口等你"];
}

#pragma mark - 请求 图片数据

- (void)pictureWithRequestSource {
    NSString *dataURL = [NSString stringWithFormat:kURL, _location, _page];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:dataURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self encapsulate:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)encapsulate:(NSArray *)resonesObject {
    
    if (_isRefresh) {
        [self.pictureArray removeAllObjects];
    }
    
    for (NSDictionary *dic in resonesObject) {
        XMImageModel *model = [XMImageModel imgageModelWithDictionary:dic];
        [self.pictureArray addObject:model];
    }
    
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView reloadData];
}

#pragma mark -

- (void)layoutWithViewRefresh {
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pictureViewRefresh)];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pictureViewLoadMore)];
}

// MARK: -
- (void)pictureViewRefresh {
    _page = 1;
    _isRefresh = YES;
    [self pictureWithRequestSource];
}

// MARK: -
- (void)pictureViewLoadMore {
    ++_page;
    _isRefresh = NO;
    [self pictureWithRequestSource];
}

#pragma mark - XLWaterFlowLayoutDelegate

- (CGFloat)waterFlowLayout:(XMCollectionViewFlowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 获取对应 的 对象
    XMImageModel *model = self.pictureArray[indexPath.row];
    
    // 计算比例
    CGFloat rate = [model.image_width floatValue] / [model.image_height floatValue];
    
    // 计算对应高度
    CGFloat height = layout.itemSize.width / rate;
    
    return height;
}

// MARK: - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pictureArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"街路口等你" forIndexPath:indexPath];
    
    XMImageModel *model = self.pictureArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.image_url] placeholderImage:[UIImage imageNamed:@"Normal"]];
    
    return cell;
}

// MARK: - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XMCollectionViewCell *cell = (XMCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存到相册" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancleAction];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 保存图片
        UIImageWriteToSavedPhotosAlbum(cell.imgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
    [alertVC addAction:confirmAction];
}

#pragma mark -

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *str = nil;
    if (error != nil) {
        str = @"保存图片失败!";
    } else {
        str = @"保存图片成功!";
    }
}


@end
