//
//  ContainerView.m
//  hello拼图
//
//  Created by AJB on 16/7/20.
//  Copyright © 2016年 NLW. All rights reserved.
//

#import "ContainerView.h"
#import "UIImage+LWUIImageExtansion.h"
#import "Block_RectInfo.h"

#define SPACE 2 //小图边距
#define NUMBER 4 //拼图横竖个数

@interface ContainerView()

/** 空的那块 */
@property (nonatomic,weak) LWImageViewForImageBlock *emtpyImage;
@property (nonatomic,assign) CGSize size;// 拼图的尺寸
@property (nonatomic,strong) NSMutableArray *indexsPosition; // 记录索引槽对应的位置

@end

@implementation ContainerView

-(NSMutableArray *)indexsPosition{
    if (!_indexsPosition) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        _indexsPosition = arr;
        return _indexsPosition;
    }
    return _indexsPosition;
}

-(instancetype)initWithSize:(CGSize)size andImage:(NSString *)imageName{
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (!self) return nil;
    self.contentMode = UIViewContentModeScaleToFill;
    self.backgroundColor = [UIColor darkGrayColor];
    [self segmentImageWithCoordinateWithImage:imageName];
    return self;
}

/** 打乱dd */
-(void)randomLayout{
    NSMutableArray *temArr = [[NSMutableArray alloc]initWithArray:self.indexsPosition];
    for (LWImageViewForImageBlock *piece in self.subviews) {
        int pickOne = arc4random() % temArr.count;
        Block_RectInfo *temPiece = temArr[pickOne];
        
        [self exchangePositionWithImageview:temPiece otherImageView:piece];
        
        
        [temArr removeObjectAtIndex:pickOne];
        
    }
    self.emtpyImage.hidden = YES;

}



/** 块置换到槽的位置d */
-(void)exchangePositionWithImageview:(Block_RectInfo *)rectInfo otherImageView:(LWImageViewForImageBlock *)imageview2{
    [UIView animateWithDuration:0.12  animations:^{
        imageview2.frame = CGRectMake(rectInfo.x, rectInfo.y, rectInfo.width, rectInfo.heigh);
        imageview2.coordinate_X = rectInfo.coordinate_X;
        imageview2.coordinate_Y = rectInfo.coordinate_Y;
        imageview2.index = rectInfo.index;
        
        
    } completion:nil];
}


/** 与空块换位置 */
-(void)exchangePositionWithImageview:(LWImageViewForImageBlock *)imageview{
    [UIView animateWithDuration:0.12  animations:^{
        CGRect rect = imageview.frame;
        imageview.frame = self.emtpyImage.frame;
        self.emtpyImage.frame = rect;
        
        int ox = imageview.coordinate_X;
        int oy = imageview.coordinate_Y;
        int oIndex = imageview.index;
        
        imageview.coordinate_X = self.emtpyImage.coordinate_X;
        imageview.coordinate_Y = self.emtpyImage.coordinate_Y;
        imageview.index = self.emtpyImage.index;
        
        self.emtpyImage.coordinate_X = ox;
        self.emtpyImage.coordinate_Y = oy;
        self.emtpyImage.index = oIndex;
        
    } completion:nil];
    [self missionCheck];
}

/** 检查拼接结果 */
-(void)missionCheck{
    int countOfAll = (int)self.indexsPosition.count;
    int i = 0 ;
    for (LWImageViewForImageBlock *subject in self.subviews) {
        if (subject.index != subject.serial) {
            return;
        }
        i ++;
    }
    if (i == countOfAll) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"success" object:nil];
        
        self.emtpyImage.hidden = NO;
        
        
    }
}


/** 分割图片并构建网格 */
-(void)segmentImageWithCoordinateWithImage:(NSString *)imageName{
    UIImage *originalImage = [UIImage imageNamed:imageName];
    // 切图
    UIImage *image = [UIImage scaleToSize:originalImage size:CGSizeMake(self.frame.size.width - SPACE,self.frame.size.width -SPACE)];
    
    //<2>获取分割以后的每一小块图片的宽和高
    float newImageW = image.size.width / NUMBER;
    float newImageH = image.size.height / NUMBER;
    
    //<3>设置number个子视图
    int k = 0;
    for (int i = 0; i < NUMBER; i++) // i对应网格的y j对应网格的x
    {
        for (int j = 0; j < NUMBER; j++)
        {
            CGRect positionRect = CGRectMake(SPACE + j * newImageW, SPACE + i * newImageH, newImageW - SPACE, newImageH - SPACE);
            Block_RectInfo *rectInfo = [[Block_RectInfo alloc]init];
            rectInfo.x = positionRect.origin.x;
            rectInfo.y = positionRect.origin.y;
            rectInfo.width = positionRect.size.width;
            rectInfo.heigh = positionRect.size.height;
            rectInfo.coordinate_X = j;
            rectInfo.coordinate_Y = i;
            rectInfo.index = k;
            
            LWImageViewForImageBlock *littleImageView = [[LWImageViewForImageBlock alloc] initWithFrame:positionRect];
            littleImageView.coordinate_X = j;
            littleImageView.coordinate_Y = i;
            littleImageView.index = k;
            littleImageView.serial = k;
            [self.indexsPosition addObject:rectInfo];
            k ++;
            
            CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, littleImageView.frame);
            
            UIImage *imageNew = [UIImage imageWithCGImage:imageRef];
            
            littleImageView.image = imageNew;
            
            if (i == 0 && j == NUMBER - 1) // 右上角那个为空
            {
                self.emtpyImage = littleImageView;
                littleImageView.hidden = YES;
            }
            
            littleImageView.userInteractionEnabled = YES;
            [self addGestureRecgonizerOnImageView:littleImageView];
            
            [self addSubview:littleImageView];
        }
    }
    
}

//为每一个UIImageView视图添加手势----自定义方法
-(void)addGestureRecgonizerOnImageView:(LWImageViewForImageBlock *)imageView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [imageView addGestureRecognizer:tap];
    
    [imageView addGestureRecognizer:[self createSwipeGestureWithGestureDirection:UISwipeGestureRecognizerDirectionRight]];
    [imageView addGestureRecognizer:[self createSwipeGestureWithGestureDirection:UISwipeGestureRecognizerDirectionLeft]];
    [imageView addGestureRecognizer:[self createSwipeGestureWithGestureDirection:UISwipeGestureRecognizerDirectionUp]];
    [imageView addGestureRecognizer:[self createSwipeGestureWithGestureDirection:UISwipeGestureRecognizerDirectionDown]];
    
}

/** 创建滑动手势 */
-(UISwipeGestureRecognizer *)createSwipeGestureWithGestureDirection:(UISwipeGestureRecognizerDirection)direction{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    swipe.numberOfTouchesRequired = 1;
    swipe.direction = direction;
    return swipe;
}

/** 点击手势触发 */
- (void)tapAction:(UITapGestureRecognizer *)tap{
    LWImageViewForImageBlock *imageview = (LWImageViewForImageBlock *)tap.view;
    
    double absValueX = fabs((float)imageview.coordinate_X - (float)self.emtpyImage.coordinate_X);
    double absValueY = fabs((float)imageview.coordinate_Y - (float)self.emtpyImage.coordinate_Y);
    
    BOOL isXok = (absValueX > 0) && (absValueX <= 1) ;
    BOOL isYok = (absValueY > 0) && (absValueY <= 1) ;
    
    BOOL isDiffTooBig = NO;
    if (absValueX > 1 || absValueY > 1) {
        isDiffTooBig = YES;
    }
    
    if ( ( isXok||isYok ) && (isXok != isYok) && !isDiffTooBig) {
        [self exchangePositionWithImageview:imageview];
    }
    
}

/** 滑动手势触发 */
-(void)swipeAction:(UISwipeGestureRecognizer *)swipe{
    
    LWImageViewForImageBlock *imageview = (LWImageViewForImageBlock *)swipe.view;
    UISwipeGestureRecognizerDirection direction = swipe.direction;
    switch (direction) {
        case UISwipeGestureRecognizerDirectionUp:
            if ([self isThatImageCanSlideToDirection:imageview direction:UISwipeGestureRecognizerDirectionUp]) {
                [self exchangePositionWithImageview:imageview];
            }
            break;
            
        case UISwipeGestureRecognizerDirectionLeft:
            if ([self isThatImageCanSlideToDirection:imageview direction:UISwipeGestureRecognizerDirectionLeft]) {
                [self exchangePositionWithImageview:imageview];
            }
            break;
            
        case UISwipeGestureRecognizerDirectionDown:
            if ([self isThatImageCanSlideToDirection:imageview direction:UISwipeGestureRecognizerDirectionDown]) {
                [self exchangePositionWithImageview:imageview];
            }
            break;
            
        case UISwipeGestureRecognizerDirectionRight:
            if ([self isThatImageCanSlideToDirection:imageview direction:UISwipeGestureRecognizerDirectionRight]) {
                [self exchangePositionWithImageview:imageview];
            }
            break;
            
        default:
            break;
    }
}

/** 判断该滑块是否可以往该方向滑动 */
-(BOOL)isThatImageCanSlideToDirection:(LWImageViewForImageBlock *)imageview direction:(UISwipeGestureRecognizerDirection)direction{
    
    int difValueX = imageview.coordinate_X - self.emtpyImage.coordinate_X;
    int difValueY = imageview.coordinate_Y - self.emtpyImage.coordinate_Y;
    
    double absValueX = fabs((double)difValueX);
    double absValueY = fabs((double)difValueY);
    
    BOOL isXok = (absValueX > 0) && (absValueX <= 1) ;
    BOOL isYok = (absValueY > 0) && (absValueY <= 1) ;
    
    BOOL isDiffTooBig = NO;
    if (absValueX > 1 || absValueY > 1) {
        isDiffTooBig = YES;
    }
    
    if ( ( isXok||isYok ) && (isXok != isYok) && !isDiffTooBig) {
        
        switch (direction) {
            case UISwipeGestureRecognizerDirectionUp:
                if (difValueY > 0) {
                    return YES;
                }else{
                    return NO;
                }
                break;
                
            case UISwipeGestureRecognizerDirectionLeft:
                if (difValueX > 0) {
                    return YES;
                }else{
                    return NO;
                }
                break;
                
            case UISwipeGestureRecognizerDirectionDown:
                if (difValueY < 0) {
                    return YES;
                }else{
                    return NO;
                }
                break;
                
            case UISwipeGestureRecognizerDirectionRight:
                if (difValueX < 0) {
                    return YES;
                }else{
                    return NO;
                }
                break;
                
            default:
                break;
        }
  
    }
    
    return NO;
}



@end
