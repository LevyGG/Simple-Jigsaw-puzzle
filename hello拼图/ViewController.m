//
//  ViewController.m
//  hello拼图
//  Created by AJB on 16/7/18.
//  Copyright © 2016年 NLW. All rights reserved.
//

#import "ViewController.h"
#import "ContainerView.h"

#import "Masonry.h"
#import "MBProgressHUD.h"

@interface ViewController ()

@property (nonatomic,weak) ContainerView *mainJigsaw; // 主图
@property (nonatomic,weak) UIButton *randomButton; // 打乱按钮
@property (nonatomic,weak) UIButton *changePicButton; // 更换图片按钮
@property (nonatomic,strong) NSArray *picNameArr; // 图片数组
@property (nonatomic,assign) int picIndex; // 当前图片所在数组中的索引

@property (nonatomic,assign) BOOL isPortrait; // 是否竖屏

@end

@implementation ViewController

-(NSArray *)picNameArr{
    if (!_picNameArr) {
        NSArray *arr = [NSArray arrayWithObjects:@"dabailanmao",@"xiaoxin",@"byemax",@"keaixiaoxin",@"xiaoxinmaimeng", nil];
        _picNameArr = arr;
        return _picNameArr;
    }
    return _picNameArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successCall) name:@"success" object:nil];
    // 先判断屏幕方向
    if (self.view.frame.size.width < self.view.frame.size.height) { // 一开始用[[UIDevice currentDevice] orientation]获取不到屏幕方向所以只好这样判断了
        self.isPortrait = YES;
        [self createJigsawWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.width) isRandom:YES picIndex:999];
    }else{
        self.isPortrait = NO;
        [self createJigsawWithSize:CGSizeMake(self.view.frame.size.height, self.view.frame.size.height) isRandom:YES picIndex:999];
    }
    
    [self createButton];
    
    if (self.isPortrait) {
        [self setPortraitLayout];
    }else{
        [self setLandscapeLayout];
    }
    
}

-(void)randomButtonClick{
    [self.mainJigsaw randomLayout];
}

-(void)changePicButtonClick{
    self.picIndex++;
    if (self.picIndex == self.picNameArr.count) {
        self.picIndex = 0;
    }
    [self.mainJigsaw removeFromSuperview];
    self.mainJigsaw = nil;
    [self createJigsawWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.width) isRandom:YES picIndex:self.picIndex];

    
    if (self.isPortrait) {
        [self setPortraitLayout];
    }else{
        [self setLandscapeLayout];
    }
    
}

-(void)createButton{
    UIButton *randomLayoutButton = [[UIButton alloc]init];
    [randomLayoutButton setTitle:@"打乱" forState:UIControlStateNormal];
    randomLayoutButton.backgroundColor = [UIColor blackColor];
    [randomLayoutButton addTarget:self action:@selector(randomButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.randomButton = randomLayoutButton;
    [self.view addSubview:randomLayoutButton];
    
    UIButton *changePicButton = [[UIButton alloc]init];
    [changePicButton setTitle:@"换一张" forState:UIControlStateNormal];
    changePicButton.backgroundColor = [UIColor blackColor];
    [changePicButton addTarget:self action:@selector(changePicButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.changePicButton = changePicButton;
    [self.view addSubview:changePicButton];
}

#pragma mark - layout
/** 竖布局 */
-(void)setPortraitLayout{
    
    [self.mainJigsaw mas_makeConstraints:^(MASConstraintMaker *make) { // 竖屏
        make.center.mas_equalTo(self.view);
        make.width.lessThanOrEqualTo(self.view.mas_width);
        make.width.equalTo(self.view.mas_width).with.priorityLow();
        make.height.equalTo(self.mainJigsaw.mas_width);
    }];
    
    [self.randomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.mainJigsaw.mas_bottom).offset(10);
        make.width.equalTo(@50);
        make.height.equalTo(@40);
    }];
    
    [self.changePicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.randomButton.mas_right).offset(30);
        make.top.equalTo(self.mainJigsaw.mas_bottom).offset(10);
        make.width.equalTo(@70);
        make.height.equalTo(@40);
    }];
    
    
}

/** 横屏布局 */
-(void)setLandscapeLayout{
    [self.mainJigsaw mas_makeConstraints:^(MASConstraintMaker *make) { // 横屏
        make.center.mas_equalTo(self.view);
        make.height.lessThanOrEqualTo(self.view.mas_height);
        make.height.equalTo(self.view.mas_height).with.priorityLow();
        make.width.equalTo(self.mainJigsaw.mas_height);
    }];
}

/** 添加拼图模块 */
-(void)createJigsawWithSize:(CGSize)size isRandom:(BOOL)random picIndex:(int)index{
    
    if (random) { // 默认随机
        int picIndex = arc4random() % self.picNameArr.count;
        self.picIndex = picIndex;
        NSString *picName = self.picNameArr[picIndex];
        ContainerView *backView = [[ContainerView alloc]initWithSize:size andImage:picName];
        self.mainJigsaw = backView;
        [self.view addSubview:backView];
        return;
    }
    // 请求换图片，不随机
    NSString *picName = self.picNameArr[index];
    ContainerView *backView = [[ContainerView alloc]initWithSize:size andImage:picName];
    self.mainJigsaw = backView;
    [self.view addSubview:backView];
    
    
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{ // 旋转屏幕方法，系统自动调用
    if (toInterfaceOrientation == UIDeviceOrientationLandscapeRight || toInterfaceOrientation == UIDeviceOrientationLandscapeLeft) {
        self.isPortrait = YES;
    }else{
        self.isPortrait = NO;
    }
}

-(void)updateViewConstraints{ // 更新约束方法，系统自动调用
    UIView *superview = self.view;
    if (self.isPortrait) { // 横屏
        [self.mainJigsaw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(superview);
            make.height.lessThanOrEqualTo(superview.mas_height);
            make.height.equalTo(superview.mas_height).with.priorityLow();
            make.width.equalTo(self.mainJigsaw.mas_height);
        }];
    }else{ // 竖屏
        [self.mainJigsaw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(superview);
            make.width.lessThanOrEqualTo(superview.mas_width);
            make.width.equalTo(superview.mas_width).with.priorityLow();
            make.height.equalTo(self.mainJigsaw.mas_width);
        }];
    }
    [super updateViewConstraints];
}



-(void)successCall{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.5f];
    
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.square = YES;
    hud.label.text = @"完成拼图!";
    [hud hideAnimated:YES afterDelay:1.f];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
