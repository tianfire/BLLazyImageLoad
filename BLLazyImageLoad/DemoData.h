//
//  DemoData.h
//  BLLazyImageLoad
//
//  Created by T9 on 2016/10/11.
//  Copyright © 2016年 T9. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemoData : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *imgURLs;

+ (NSArray *)demoDatas;

@end
