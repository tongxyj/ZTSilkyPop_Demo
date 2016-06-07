//
//  PopAnimation.m
//  navTest
//
//  Created by zhaitong on 16/6/7.
//  Copyright © 2016年 zhaitong. All rights reserved.
//

#import "PopAnimation.h"

@interface PopAnimation ()<UINavigationControllerDelegate>
@end
@implementation PopAnimation

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    //这个方法返回动画执行的时间
    return 0.25;
}
/**
 *  trainsitionContext你可以看作是一个工具，用来获取一系列动画执行相关的对象，并且通知系统动画是否完成等功能。
 */
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)trainsitionContext {
    // 动画来自的那个控制器
    UIViewController *fromViewController = [trainsitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    // 专场到的那个控制器
    UIViewController *ToViewController = [trainsitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    // 转场动画是两个控制器试图时间的动画，需要一个containerView来作为一个“舞台”，让动画执行
    UIView *containerView = [trainsitionContext containerView];
    [containerView insertSubview:ToViewController.view belowSubview:fromViewController.view];
    //执行动画
    [UIView animateWithDuration:0.25 animations:^{
        fromViewController.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
    } completion:^(BOOL finished) {
        [trainsitionContext completeTransition:!trainsitionContext.transitionWasCancelled];
    }];
    
}
@end
