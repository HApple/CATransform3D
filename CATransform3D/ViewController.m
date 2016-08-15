//
//  ViewController.m
//  CATransform3D
//
//  Created by Jn.Huang on 16/8/12.
//  Copyright © 2016年 huang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *translateCatImgView;
@property (weak, nonatomic) IBOutlet UIImageView *scaleCatImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rotationCatImgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self applyTranslate];
    [self applyScale];
    [self applyRotation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)applyTranslate{
    
    CATransform3D transform3D = CATransform3DMakeTranslation(100, 100, 10);
    self.translateCatImgView.layer.transform = transform3D;
}

- (void)applyScale{
    
    CATransform3D transform3D = CATransform3DMakeScale(0.5, 0.5, 0);
    self.scaleCatImgView.layer.transform = transform3D;
}

- (void)applyRotation{
    
    CATransform3D xRotation = CATransform3DMakeRotation(45*M_PI/180.0, 1.0, 0, 0);
    
    CATransform3D yRotation = CATransform3DIdentity;
    CGFloat zDistance = 1000;
    yRotation.m34 = - 1.0 / zDistance;// (-1.0 / zDistance)，zDistance越小，透视效果越明显  必须先设置m34再设置旋转角度
    yRotation = CATransform3DRotate(yRotation,-30*M_PI/180.0, 0.0, 1.0, 0);
    
    CATransform3D xYRotation = CATransform3DConcat(xRotation, yRotation);//合并xRotation, yRotation
    self.rotationCatImgView.layer.transform = xYRotation;

    
 
}

@end
