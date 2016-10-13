//
//  DemoSingleImageTableViewCell.m
//  BLLazyImageLoad
//
//  Created by T9 on 2016/10/11.
//  Copyright © 2016年 T9. All rights reserved.
//

#import "DemoSingleImageTableViewCell.h"

@implementation DemoSingleImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgWidthLayoutConstraint.constant = ([[UIScreen mainScreen] bounds].size.width - 40) / 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
