//
//  ZHWeakProxy.h
//  TextScrollView
//
//  Created by zhihuili on 2018/12/22.
//  Copyright © 2018 智慧  李. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 *中间对象
 */
@interface ZHWeakProxy : NSProxy

@property (nullable, nonatomic, weak, readonly) id target;

- (instancetype)initWithTarget:(id)target;

+ (instancetype)proxyWithTarget:(id)target;

@end
