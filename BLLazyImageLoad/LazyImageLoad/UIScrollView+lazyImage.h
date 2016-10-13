//
//  UICollectionView+lazyImage.h
//  Universities
//
//  Created by T9 on 16/6/5.
//  Copyright © 2016年 Th9999. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSObject *(^DataForIndexPathBlock)(NSIndexPath *indexPath);
typedef id (^IMGViewSELForIndexPathBlock)(NSIndexPath *indexPath);
typedef id (^URLSELForIndexPathBlock)(NSIndexPath *indexPath);
typedef id (^PlaceHolderForIndexPathBlock)(NSIndexPath *indexPath);

@interface UIScrollView (lazyImage) <UIScrollViewDelegate>

@property (strong, nonatomic) DataForIndexPathBlock        dataForIndexPathBlock;
@property (strong, nonatomic) IMGViewSELForIndexPathBlock  imgSELForIndexPathBlock;
@property (strong, nonatomic) URLSELForIndexPathBlock      urlSELForIndexPathBlock;
@property (strong, nonatomic) PlaceHolderForIndexPathBlock placeHolderForIndexPathBlock;


- (void)setLazyImageForCell:(id)cell indexPath:(NSIndexPath *)indexPath;

- (void)setImageSourceBlocks:(DataForIndexPathBlock)datablock
                    imgBlock:(IMGViewSELForIndexPathBlock)imgBlock
                    urlblock:(URLSELForIndexPathBlock)urlBlock
            placeholderBlock:(PlaceHolderForIndexPathBlock)placeholderBlock;

- (void)loadImageForForVisibleItems;

@end
