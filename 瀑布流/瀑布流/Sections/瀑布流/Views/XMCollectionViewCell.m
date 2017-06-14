//
//  XMCollectionViewCell.m
//  瀑布流
//
//  Created by 街路口等你 on 17/6/14.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "XMCollectionViewCell.h"
#import "UIView+XMAdd.h"

@implementation XMCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgView];
    }
    return self;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        self.imgView = [[UIImageView alloc] init];
        
        _imgView.left = 0;
        _imgView.top = 0;
        _imgView.size = self.size;
    }
    return _imgView;
}

@end
