//
//  BLImageDownloader.m
//  Universities
//
//  Created by xintian on 16/5/30.
//  Copyright © 2016年 Th9999. All rights reserved.
//

#import "BLImageDownloader.h"
#import <SDWebImage/SDWebImageManager.h>


@implementation BLImageDownloader


+ (void)imageWithURL:(NSString *)imageUrl placeholder:(UIImage *)placeholder completionHandler:(completionHandler)completionHandler {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage * img = [BLImageDownloader getImageThroughUrl:imageUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (img == nil) {
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                     
                 } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                     if (image) {
                         completionHandler(image);
                     } else {
                         completionHandler(placeholder);
                     }
                     
                 }];
                
            } else {
                completionHandler (img);
            }
        });
        
    });
    
    
}

/**
 *  获取SDWebImage缓存图片
 */
+ (UIImage *)getImageThroughUrl:(NSString *)url;
{
    UIImage *_cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url];
    if (_cacheImage)
    {
        return _cacheImage;
    }
    return nil;
}

/**
 *  缓存大小
 */
+ (float)cacheImageSize {
    float tmpSize = [[SDImageCache sharedImageCache] getSize];
    return tmpSize;
}

/**
 *  友好化缓存大小
 */
+ (NSString *)friendlyCacheImageSize {
    NSString *fCS;
    fCS = [self cacheImageSize] >= 1024*1024 ? [NSString stringWithFormat:@"%.1fM",[self cacheImageSize] / 1024 / 1024] : [NSString stringWithFormat:@"%.1fK",[self cacheImageSize] / 1024];
    return fCS;
}

/**
 *  清除缓存
 */
+ (void)clearImageCache {
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
}

@end
