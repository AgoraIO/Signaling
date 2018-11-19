//
//  UIColor+Extension.m
//  Agora-Signaling-Tutorial
//
//  Created by Zhangji on 2018/11/16.
//  Copyright © 2018 Agora. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor(Extension)
+ (UIColor *)randomColor {
    CGFloat red = arc4random_uniform(255)/255.0;
    CGFloat green = arc4random_uniform(255)/255.0;
    CGFloat blue = arc4random_uniform(255)/255.0;
    
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    return color;
}
@end
