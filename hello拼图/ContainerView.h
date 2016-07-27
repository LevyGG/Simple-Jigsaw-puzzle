//
//  ContainerView.h
//  hello拼图
//
//  Created by AJB on 16/7/20.
//  Copyright © 2016年 NLW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWImageViewForImageBlock.h"

@interface ContainerView : UIView

/** 创建拼图模块dd */
-(instancetype)initWithSize:(CGSize)size andImage:(NSString *)imageName;

/** 随机打乱 */
-(void)randomLayout;




@end
