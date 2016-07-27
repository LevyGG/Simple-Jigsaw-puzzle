//
//  UIImage+LWUIImageExtansion.h
//  hello拼图
//
//  Created by AJB on 16/7/20.
//  Copyright © 2016年 NLW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LWUIImageExtansion)
/** 图片缩放到指定大小尺寸*/
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
@end
