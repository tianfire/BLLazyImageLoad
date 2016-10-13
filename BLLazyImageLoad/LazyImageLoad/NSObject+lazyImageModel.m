//
//  NSObject+lazyImageModel.m
//  Universities
//
//  Created by T9 on 16/6/5.
//  Copyright © 2016年 Th9999. All rights reserved.
//

#import "NSObject+lazyImageModel.h"
#import <objc/runtime.h>

static char imageKey;
static char boolKey;

@implementation NSObject (lazyImageModel)

- (void)setBl_lazyImages:(NSMutableArray *)bl_lazyImages {
    objc_setAssociatedObject(self, &imageKey, bl_lazyImages, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableArray *)bl_lazyImages {
    return objc_getAssociatedObject(self, &imageKey);
}

- (void)setBl_isDownLoad:(NSNumber *)bl_isDownLoad {
    objc_setAssociatedObject(self, &boolKey, bl_isDownLoad, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber *)bl_isDownLoad {
    return objc_getAssociatedObject(self, &boolKey);
}

@end
