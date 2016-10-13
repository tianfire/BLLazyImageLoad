//
//  BLImageDownloader.h
//  Universities
//
//  Created by xintian on 16/5/30.
//  Copyright © 2016年 Th9999. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^completionHandler) (UIImage *img);

@interface BLImageDownloader : NSObject

/**
 *  缓存图片到本地
 */
+ (void)imageWithURL:(NSString *)imageUrl placeholder:(UIImage *)placeholder completionHandler:(completionHandler)completionHandler;

/**
 *  获取SDWebImage缓存图片
 */
+ (UIImage *)getImageThroughUrl:(NSString *)url;

/**
 *  缓存大小
 */
+ (float)cacheImageSize;

/**
 *  友好化缓存大小
 */
+ (NSString *)friendlyCacheImageSize;

/**
 *  清除缓存
 */
+ (void)clearImageCache;

@end
