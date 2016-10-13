//
//  DemoSingleImageTableViewCell.h
//  BLLazyImageLoad
//
//  Created by T9 on 2016/10/11.
//  Copyright © 2016年 T9. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoSingleImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidthLayoutConstraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
