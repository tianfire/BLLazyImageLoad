//
//  UICollectionView+lazyImage.m
//  Universities
//
//  Created by T9 on 16/6/5.
//  Copyright © 2016年 Th9999. All rights reserved.
//

#import "UIScrollView+lazyImage.h"
#import "NSObject+lazyImageModel.h"
#import "BLImageDownloader.h"
#import <objc/runtime.h>
#include <stdio.h>

#define MAXIMGNUM 5

static char dataKey;
static char imgviewKey;
static char urlKey;
static char placeholderKey;

NSArray *imgKeys;
NSArray *isDownLoadKeys;

@implementation UIScrollView (lazyImage)

- (void)setImageSourceBlocks:(DataForIndexPathBlock)datablock
                    imgBlock:(IMGViewSELForIndexPathBlock)imgBlock
                    urlblock:(URLSELForIndexPathBlock)urlBlock
            placeholderBlock:(PlaceHolderForIndexPathBlock)placeholderBlock {

    self.dataForIndexPathBlock          = datablock;
    self.imgSELForIndexPathBlock        = imgBlock;
    self.urlSELForIndexPathBlock        = urlBlock;
    self.placeHolderForIndexPathBlock   = placeholderBlock;
    
    [[self class] setLazyKey];
//    imgKeys = @[@"0",@"1",@"2",@"3"];
//    isDownLoadKeys = @[@"101",@"102",@"103",@"104"];
    
}

+ (void)setLazyKey {
    imgKeys = [NSMutableArray arrayWithCapacity:9];
    isDownLoadKeys = [NSMutableArray arrayWithCapacity:9];
    for (int i= 0; i < MAXIMGNUM; i++) {
        [((NSMutableArray *)imgKeys) addObject:[NSString stringWithFormat:@"%d", i + 1]];
        [((NSMutableArray *)isDownLoadKeys) addObject:[NSString stringWithFormat:@"%d", i + 101]];
    }
}

- (void)setLazyImageForCell:(id)cell indexPath:(NSIndexPath *)indexPath {
    [self setLazyImageForCell:cell indexPath:indexPath isDs:NO];
}

- (void)setLazyImageForCell:(id)cell indexPath:(NSIndexPath *)indexPath isDs:(BOOL)isDs {
    
    NSObject    *model;
    
    
    // data
    if (!self.dataForIndexPathBlock) {
        NSLog(@"lazyImageError:not found images data source.（图片懒加载错误：没有找到图片数据源）");
        return;
    } else {
        model = self.dataForIndexPathBlock(indexPath);
        
    }
    
    // placeholder
    UIImage     *placeholder;
    if (!self.placeHolderForIndexPathBlock) {
        placeholder = nil;
    } else {
        placeholder = self.placeHolderForIndexPathBlock(indexPath);
        
    }
    
    
    NSArray *imgSelStrings = self.imgSELForIndexPathBlock(indexPath);
    NSArray *urlSelStrings = self.urlSELForIndexPathBlock(indexPath);
    
    if ([imgSelStrings isKindOfClass:[NSArray class]] && [urlSelStrings isKindOfClass:[NSArray class]] && imgSelStrings.count <= urlSelStrings.count) {
        for (int i = 0; i < imgSelStrings.count; i ++) {
            SEL imgSel = NSSelectorFromString(imgSelStrings[i]);
            
            NSString *urlString = urlSelStrings[i];

            [self setLazyImageForCell:cell indexPath:indexPath imgSel:imgSel urlString:urlString model:model placeHolder:placeholder idx:i iDs:isDs];
        }
    } else {
        SEL imgSel = NSSelectorFromString((NSString *)imgSelStrings);
        
        NSString *urlString = (NSString *)urlSelStrings;
        [self setLazyImageForCell:cell indexPath:indexPath imgSel:imgSel urlString:urlString model:model placeHolder:placeholder idx:0 iDs:isDs];
    }
}

- (void)setLazyImageForCell:(id)cell
                  indexPath:(NSIndexPath *)indexPath
                     imgSel:(SEL)imgSel
                     urlString:(id)urlString
                      model:(NSObject *)model
                placeHolder:(UIImage *)placeHolder
                        idx:(int)idx
                        iDs:(BOOL)isDs{
    
    UIImageView *lazyImgView;
    
    // imageView
    if (!imgSel) {
        NSLog(@"lazyImageError:image view SEL not set.（图片懒加载错误：没有设置图片视图方法名）");
        return;
    } else {
        if (![cell respondsToSelector:imgSel]) {
            NSString *errorString = [NSString stringWithFormat:@"lazyImageError:image view SEL(%@) not found.（图片懒加载错误：设置的图片视图方法名（%@）没有找到）",NSStringFromSelector(imgSel), NSStringFromSelector(imgSel)];
            NSLog(@"%@", errorString);
            
        } else {
            lazyImgView = [cell performSelector:imgSel];
        }
    }
    
    // url
    if (!urlString) {
        NSLog(@"lazyImageError:image url not SEL.（图片懒加载错误：没有设置url方法名）");
        return;
    } else {
        
    }
    
    const char *imgKey = [imgKeys[idx] UTF8String];
    const char *downLoadKey = [isDownLoadKeys[idx] UTF8String];
    printf("%s", imgKey);
    
    UIImage *sImg = objc_getAssociatedObject(model, imgKey);
    
    // 1,数据源中有图片 直接显示
    if (sImg != nil) {
        lazyImgView.image = sImg;
        return;
    }
    
    // 2,设置空的站位图
    lazyImgView.image = nil;
    
    // 3,每行绘制并且有减速或拖拽时不加载
    if (!isDs && (self.decelerating == YES || self.dragging == YES)) {
        return;
    }
    
    /* 停止减速/停止拖拽/tableView第一页 */
    // 4,如果已经在下载队列中 无需再次下载
    NSNumber *isDownLoad = objc_getAssociatedObject(model, downLoadKey);
    if ([isDownLoad boolValue] == YES) {
        return;
    }
    
    // 5,标记已经加入下载队列
    objc_setAssociatedObject(model, downLoadKey, @(YES), OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    __weak __typeof(self)weakSelf = self;
    [BLImageDownloader imageWithURL:urlString placeholder:placeHolder completionHandler:^(UIImage *img) {
        
        static int i = 0;
        i++;
        NSLog(@"共%d个",i);
        
        // 6,下载完给数据源赋值
        objc_setAssociatedObject(model, imgKey, img, OBJC_ASSOCIATION_COPY_NONATOMIC);
       
      
        // 7, 获取下载完时cell的indexPath（可能跟开始下载时的indexPath不一样，不一样说明下载过程中cell已经被划出了屏幕）
        NSIndexPath *finishIndexPath = [weakSelf bl_indexPathForCell:cell];
        if (indexPath.row != finishIndexPath.row || indexPath.section != finishIndexPath.section) {
            NSLog(@"此行（%ld-%ld）在图片加载出来前已经滑出屏幕", indexPath.section, indexPath.row);
            return;
            
        } else {
            // 8,将下载完的图片加载到视图上
            dispatch_async(dispatch_get_main_queue(), ^{
                lazyImgView.image = img;
//                lazyImgView.alpha = 0;
                [UIView transitionWithView:lazyImgView duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    lazyImgView.alpha = 1;
                    
                } completion:NULL];
                
            });
            
        }
        
    }];
}

- (void)loadImageForForVisibleItems {
    NSArray *indexPaths = [self bl_indexPathsForVisibleCells];
    if (!indexPaths.count) {
        return;
    }
    static long firstCellIndex = 1;
    static long firstCellSection = 0;
    static long lastCellIndex = 1;
    
    NSIndexPath *index = indexPaths[0];
    NSIndexPath *indexL = indexPaths[indexPaths.count - 1];
    NSLog(@"%ld-%ld, %ld",index.section, index.row, indexL.row);
    if (index.row == firstCellIndex && indexL.row - lastCellIndex && index.section == firstCellSection) {
        return;
    }
    firstCellIndex = index.row;
    firstCellSection = index.section;
    lastCellIndex  = indexL.row;
    
    
    for (NSIndexPath * indexPath in indexPaths) {
        id cell = [self bl_cellForIndexPath:indexPath];
        
        [self setLazyImageForCell:cell indexPath:indexPath isDs:YES];
    }
}

#pragma mark - indexPath / cell
- (NSArray *)bl_indexPathsForVisibleCells {
    NSArray *indexPaths;
    if ([self isKindOfClass:[UITableView class]]) {
        indexPaths = [(UITableView *)self indexPathsForVisibleRows];
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        indexPaths = [(UICollectionView *)self indexPathsForVisibleItems];
    }
    return indexPaths;
}

- (id)bl_cellForIndexPath:(NSIndexPath *)indexPath {
    id cell;
    if ([self isKindOfClass:[UITableView class]]) {
        cell = [(UITableView *)self cellForRowAtIndexPath:indexPath];
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        cell = [(UICollectionView *)self cellForItemAtIndexPath:indexPath];
    }
    return cell;
}

- (NSIndexPath *)bl_indexPathForCell:(id)cell {
    NSIndexPath *indexPath;
    if ([self isKindOfClass:[UITableView class]]) {
        indexPath = [(UITableView *)self indexPathForCell:cell];
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        indexPath = [(UICollectionView *)self indexPathForCell:cell];
    }
    return indexPath;
}

#pragma mark - runtime
- (void)setDataForIndexPathBlock:(DataForIndexPathBlock)dataForIndexPathBlock {
    objc_setAssociatedObject(self, &dataKey, dataForIndexPathBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (DataForIndexPathBlock)dataForIndexPathBlock {
    return objc_getAssociatedObject(self, &dataKey);
}

- (void)setImgSELForIndexPathBlock:(IMGViewSELForIndexPathBlock)imgSELForIndexPathBlock {
    objc_setAssociatedObject(self, &imgviewKey, imgSELForIndexPathBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (IMGViewSELForIndexPathBlock)imgSELForIndexPathBlock {
    return objc_getAssociatedObject(self, &imgviewKey);
}

- (void)setUrlSELForIndexPathBlock:(URLSELForIndexPathBlock)urlSELForIndexPathBlock {
    objc_setAssociatedObject(self, &urlKey, urlSELForIndexPathBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (URLSELForIndexPathBlock)urlSELForIndexPathBlock {
    return objc_getAssociatedObject(self, &urlKey);
}

- (void)setPlaceHolderForIndexPathBlock:(PlaceHolderForIndexPathBlock)placeHolderForIndexPathBlock {
    objc_setAssociatedObject(self, &placeholderKey, placeHolderForIndexPathBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (PlaceHolderForIndexPathBlock)placeHolderForIndexPathBlock {
    return objc_getAssociatedObject(self, &placeholderKey);
}

@end
