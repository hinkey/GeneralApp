//
//  UIImageView+UAExtension.h
//  GeneralApp
//
//  Created by hinkey on 15/8/16.
//  Copyright (c) 2015年 hinkey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (UAExtension)


// Get the point of image color
- (UIColor*)colorForPoint:(CGPoint)point;

// Download image
- (void)setImage:(NSString *)url placeholder:(UIImage *)image;

@end
