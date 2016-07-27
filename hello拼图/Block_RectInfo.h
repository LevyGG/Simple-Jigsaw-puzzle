//
//  Block_RectInfo.h
//  hello拼图
//
//  Created by AJB on 16/7/21.
//  Copyright © 2016年 NLW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Block_RectInfo : NSObject

@property (nonatomic,assign) float x;
@property (nonatomic,assign) float y;
@property (nonatomic,assign) float width;
@property (nonatomic,assign) float heigh;


/** 该槽网格中的索引 */
@property (nonatomic,assign) int index;

/** 该槽的X坐标 */
@property (nonatomic,assign) int coordinate_X;
/** 该槽的Y坐标 */
@property (nonatomic,assign) int coordinate_Y;

@end
