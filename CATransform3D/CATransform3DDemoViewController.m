//
//  CATransform3DDemoViewController.m
//  CATransform3D
//
//  Created by Jn.Huang on 16/8/12.
//  Copyright © 2016年 huang. All rights reserved.
//

#import "CATransform3DDemoViewController.h"
#import <JHChainableAnimations.h>


#define FrameEnable 0

@interface CATransform3DDemoViewController ()

@property (nonatomic , strong)UIImageView *moneyImgView;
@property (nonatomic , strong)UIImageView *logoImgView;
@property (nonatomic , strong)UIButton *actionButton;

@end

@implementation CATransform3DDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.moneyImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_img_balance"]];
    self.moneyImgView.frame = CGRectMake(self.view.center.x-30/2, -60, 30, 30);
    [self.view addSubview:self.moneyImgView];
    
    
    self.logoImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_img_minilogo"]];
    self.logoImgView.frame = CGRectMake(0, 0, 100, 100);
    self.logoImgView.center = self.view.center;
#if !FrameEnable

    CGRect rect = self.logoImgView.frame;
    self.logoImgView.layer.anchorPoint = CGPointMake(0.5, 1);
    self.logoImgView.frame = rect;
    
    
#endif
   
    [self.view addSubview:self.logoImgView];
    
    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.actionButton setTitle:@"执行动画" forState:UIControlStateNormal];
    [self.actionButton sizeToFit];
    self.actionButton.center = CGPointMake(self.view.center.x, self.view.center.y+50+self.logoImgView.frame.size.height/2);
    
    [self.actionButton addTarget:self action:@selector(startAnimation) forControlEvents:UIControlEventTouchUpInside];
    //[self.actionButton addTarget:self action:@selector(animationByJHChainableAnimations) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.actionButton];
    
    
    
    
}

- (void)startAnimation{
    self.actionButton.enabled = NO;
    [self.moneyImgView.layer removeAnimationForKey:@"rotation"];
    
    CABasicAnimation *rotationAimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAimation.duration = 0.15f;
    rotationAimation.repeatDuration = 1.5f;
    rotationAimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotationAimation.toValue = [NSNumber numberWithFloat:M_PI];
    [self.moneyImgView.layer addAnimation:rotationAimation forKey:@"rotation"];
    

    CGRect originRect = self.moneyImgView.frame;
    [UIView animateWithDuration:2.0f animations:^{
#if FrameEnable
        CGRect rect = self.moneyImgView.frame;
        rect.origin.y = self.logoImgView.center.y - rect.size.height/2;
        self.moneyImgView.frame = rect;
#else
        
        
        //self.moneyImgView.transform = CGAffineTransformMakeTranslation(0, 90+self.logoImgView.frame.origin.y);
        self.moneyImgView.layer.transform = CATransform3DMakeTranslation(0, 90+self.logoImgView.frame.origin.y, 0);
#endif
        
        
    } completion:^(BOOL finished) {
#if FrameEnable
        self.moneyImgView.frame = originRect;
#else
        //self.moneyImgView.transform = CGAffineTransformIdentity;
        self.moneyImgView.layer.transform = CATransform3DIdentity;
#endif
    }];
    
    
    
    [UIView animateWithDuration:0.1 delay:1.75f options:UIViewAnimationOptionCurveEaseOut animations:^{
#if FrameEnable
       
        CGRect rect = self.logoImgView.frame;
        rect.size.width+=20;
        rect.origin.x-=10;
        
        rect.origin.y +=30;
        rect.size.height -= 30;
        self.logoImgView.frame = rect;
#else
        
        CATransform3D scaleTransform = CATransform3DMakeScale(1.1, 0.7, 1);
        self.logoImgView.layer.transform = scaleTransform;
#endif
        
        
        
        
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
#if  FrameEnable
            CGRect rect = self.logoImgView.frame;
            
            rect.size.width-=20;
            rect.origin.x+=10;
            
            rect.origin.y -=30;
            rect.size.height += 30;
            self.logoImgView.frame = rect;
#else
            CATransform3D scaleTransform = CATransform3DMakeScale(1, 1, 1);
            self.logoImgView.layer.transform = scaleTransform;
#endif

            
            
        } completion:^(BOOL finished) {
            self.actionButton.enabled = YES;
            
        }];

        
    }];
}


- (void )animationByJHChainableAnimations{
    self.actionButton.enabled = NO;
    
    CABasicAnimation *rotationAimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAimation.duration = 0.15f;
    rotationAimation.repeatDuration = 1.5f;
    rotationAimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotationAimation.toValue = [NSNumber numberWithFloat:M_PI];
    [self.moneyImgView.layer addAnimation:rotationAimation forKey:@"rotation"];
    
    self.moneyImgView.moveY(90+self.logoImgView.frame.origin.y).animate(2.0);
    
    __weak typeof(self) weakSelf = self;
    self.logoImgView.transformScaleX(1.1).transformScaleY(0.7).anchorBottom.wait(1.75f).thenAfter(0.2).transformIdentity.spring.anchorBottom.animate(1.0).animationCompletion = JHAnimationCompletion(){
        
        [self.moneyImgView.layer removeAnimationForKey:@"rotation"];
        self.moneyImgView.frame = CGRectMake(self.view.center.x-30/2, -60, 30, 30);
        weakSelf.actionButton.enabled = YES;
        
    };

}
@end
