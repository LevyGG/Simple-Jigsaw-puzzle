//
//  UIImage+LWUIImageExtansion.m
//  hello拼图
//
//  Created by AJB on 16/7/20.
//  Copyright © 2016年 NLW. All rights reserved.
//

#import "UIImage+LWUIImageExtansion.h"

@implementation UIImage (LWUIImageExtansion)

/*图片缩放到指定大小尺寸*/
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
