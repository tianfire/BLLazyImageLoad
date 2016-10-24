# BLLazyImageLoad

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-oc-brightgreen.svg?style=flat)](https://developer.apple.com/)
[![License MIT](https://img.shields.io/badge/contact-@Tianfire-blue.svg?style=flat)](https://cgfloat.com)


`BLLazyImageLoad` is an iOS drop-in class that displays the images on `tableView` or `collectionView` when scroll view dragging or decelerating end.  
 ![img_demo01.gif](https://github.com/tianfire/BLLazyImageLoad/blob/master/demo01.gif)
## Requirements

`BLLazyImageLoad` works on iOS 8+ and requires ARC to build. It depends on the following Apple frameworks, which should already be included with most Xcode templates:

* SDWebImage

You will need the latest developer tools in order to build `BLLazyImageLoad`. Old Xcode versions might work, but compatibility will not be explicitly maintained.

## Add BLLazyImageLoad to your project

#### CocoaPods

[CocoaPods](http://cocoapods.org) is the recommended way to add BLLazyImageLoad to your project.

1. Add a pod entry for BLLazyImageLoad to your Podfile `pod 'BLLazyImageLoad'`
2. Install the pod(s) by running `pod install`.
3. Include BLLazyImageLoad wherever you need it with `#import "UIScrollView+lazyImage.h"`.
 
#### Source files

Alternatively you can directly add the `LazyImageLoad/` source files to your project.

1. Download the [latest code version](https://github.com/tianfire/BLLazyImageLoad/archive/master.zip) or add the repository as a git submodule to your git-tracked project.
2. Open your project in Xcode, then drag and drop `LazyImageLoad/` onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project.
3. Include BLLazyImageLoad wherever you need it with `#import "UIScrollView+lazyImage.h"`.

## How to use  

#### 1: Import header 
```objective-c
#import "UIScrollView+lazyImage.h"
```

#### 2: Set lazy datasource
```objective-c
__weak __typeof(self)weakSelf = self;
    [self.tableView setImageSourceBlocks:^NSObject *(NSIndexPath *indexPath) {
        // -- Return model of tableview datasource.(返回表视图数据源中此indexPath对应的对象)
        return weakSelf.dataSource[indexPath.row];
        
    } imgBlock:^id(NSIndexPath *indexPath) {
        // -- Return imageView's property name of model Class.(返回imageView在数据源model类型中的属性名字)
        DemoData *data = weakSelf.dataSource[indexPath.row];
        if (data.imgURLs.count < 3) {
            // -- If only One image，return "string".(单张图片返回返回字符串类型)
            return @"imgView";
            
        } else {
            // -- If more than one images, return [array].(多张图片返回数组类型)
            return @[@"imgView1", @"imgView2", @"imgView3"];
        }
        
    } urlblock:^id(NSIndexPath *indexPath) {
        // -- If only One image, Return string of image's url.
        DemoData *data = weakSelf.dataSource[indexPath.row];
        if (data.imgURLs.count < 3) {
            return data.imgURLs[0];
        } else {
            // -- If more than one images, Return [array].
            return data.imgURLs;
        }
        
        
    } placeholderBlock:^id(NSIndexPath *indexPath) {
        // -- Return placeholder.(-> UIImage)
        return nil;
    }];
```
#### 3: Set lazy image for cell
```objective-c
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell = ...
    [tableView setLazyImageForCell:cell indexPath:indexPath];
    return cell;
}
```
#### 4: Set scroll View delegate
```objective-c
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate && scrollView.dataForIndexPathBlock) {
        [scrollView loadImageForForVisibleItems];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.dataForIndexPathBlock) {
        [scrollView loadImageForForVisibleItems];
    }
}
``` 

## Contact 
[https://cgfloat.com](https://cgfloat.com)   
[libotian9999@9999.com](mailto:libotian9999@gmail.com) 



