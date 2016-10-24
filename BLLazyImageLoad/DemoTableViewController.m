//
//  DemoTableViewController.m
//  BLLazyImageLoad
//
//  Created by T9 on 2016/10/11.
//  Copyright © 2016年 T9. All rights reserved.
//

#import "DemoTableViewController.h"
#import "DemoSingleImageTableViewCell.h"
#import "DemoMultipleImageTableViewCell.h"
#import "DemoData.h"

// -- 1,import header(导入头文件)
#import "UIScrollView+lazyImage.h"
#import "BLImageDownloader.h"


@interface DemoTableViewController ()

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation DemoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // -- 2,set lazy load data source(设置懒加载数据源)
    [self setLazyDatasource];
}

- (void)setLazyDatasource {
    __weak __typeof(self)weakSelf = self;
    [self.tableView setImageSourceBlocks:^NSObject *(NSIndexPath *indexPath) {
        // -- Return model of tableview datasource.(返回表视图数据源中此indexPath对应的对象)
        return weakSelf.dataSource[indexPath.row];
        
    } imgBlock:^id(NSIndexPath *indexPath) {
        // -- Return imageView's property name of model Class.(返回imageView在Cell中的属性名)
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Models

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [DemoData demoDatas];
    }
    return _dataSource;
}

- (IBAction)reloadDataSource:(id)sender {
    [BLImageDownloader clearImageCache];
    self.dataSource = nil;
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DemoData *data = self.dataSource[indexPath.row];
    if (data.imgURLs.count < 3) {
        DemoSingleImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SingleImageCell" forIndexPath:indexPath];
        cell.titleLabel.text = data.title;
        [tableView setLazyImageForCell:cell indexPath:indexPath];
        return cell;
    } else {
        DemoMultipleImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MutipleImageCell" forIndexPath:indexPath];
        cell.titleLabel.text = data.title;
        // -- 3,Set lazy image for cell.(为当前表格行设置图片懒加载)
        [tableView setLazyImageForCell:cell indexPath:indexPath];
        return cell;
    }
    
}

#pragma mark - Table View delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DemoData *data = self.dataSource[indexPath.row];
    if (data.imgURLs.count < 3) {
        return 90;
    } else {
        return 120;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// -- 4,Load image whele scroll view did end dragging or decelerating.(scroll view减速完成或停止拖拽时加载图片)
#pragma mark - Srcoll View delegate
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

@end
