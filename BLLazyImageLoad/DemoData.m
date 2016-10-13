//
//  DemoData.m
//  BLLazyImageLoad
//
//  Created by T9 on 2016/10/11.
//  Copyright © 2016年 T9. All rights reserved.
//

#import "DemoData.h"

@implementation DemoData

+ (NSArray *)demoDatas {
    NSString * path = [[NSBundle mainBundle]pathForResource:@"DemoDatas" ofType:@"json" ];
    NSData * jsonData = [[NSData alloc] initWithContentsOfFile:path];
    id JsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    if (![JsonObject isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *datas = [NSMutableArray arrayWithCapacity:99];
    for (NSDictionary *dic in JsonObject) {
        DemoData *data = [[DemoData alloc] init];
        data.title = dic[@"title"];
        data.imgURLs = dic[@"cover"];
        [datas addObject:data];
    }
    return datas;
}

@end
