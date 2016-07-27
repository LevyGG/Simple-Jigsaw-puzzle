//
//  LWImageViewForImageBlock.h
//  hello拼图
//
//  Created by AJB on 16/7/19.
//  Copyright © 2016年 NLW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWImageViewForImageBlock : UIImageView
/** 滑块的序列号,一旦设定就不要改变 */
@property (nonatomic,assign) int serial;
/** 滑块在网格中的索引 */
@property (nonatomic,assign) int index;
/** 滑块在网格中的X坐标 */
@property (nonatomic,assign) int coordinate_X;
/** 滑块在网格中的Y坐标 */
@property (nonatomic,assign) int coordinate_Y;

@end
