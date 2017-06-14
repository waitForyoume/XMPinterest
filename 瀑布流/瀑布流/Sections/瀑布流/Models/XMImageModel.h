//
//  XMImageModel.h
//  瀑布流
//
//  Created by 街路口等你 on 17/6/14.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMImageModel : NSObject

@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, strong) NSNumber *image_height;
@property (nonatomic, strong) NSNumber *image_width;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (id)imgageModelWithDictionary:(NSDictionary *)dictionary;

@end
