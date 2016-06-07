//
//  ViewController.m
//  navTest
//
//  Created by zhaitong on 16/6/7.
//  Copyright © 2016年 zhaitong. All rights reserved.
//

#import "ViewController.h"
#import "PopAnimation.h"
@interface ViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition * interactivePopTransition;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handlePan:)];
    panGestureRecognizer.delegate = self;
    panGestureRecognizer.maximumNumberOfTouches = 1;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.navigationController.interactivePopGestureRecognizer.view addGestureRecognizer:panGestureRecognizer];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGFloat progress = [recognizer translationInView:self.view].x / self.view.bounds.size.width;
    
    //稳定进度区间，使其在0~1之间
    progress = MIN(1.0,MAX(0, progress)) ;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //手势开始，新建一个监控对象
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        // 告诉控制器开始执行pop的动画
        [self.navigationController popViewControllerAnimated:YES];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        /**
         *  更新手势的完成进度
         */
        [self.interactivePopTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        
        /**
         *  手势结束时如果进度大于一半，那么就完成pop操作，否则重新来过。
         */
        if (progress > 0.5) {
            [self.interactivePopTransition finishInteractiveTransition];
        }
        else {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        
        self.interactivePopTransition = nil;
    }

}

// 苹果提供给我们用来重写控制器之间转场动画的
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    /**
     *  方法1中判断如果当前执行的是Pop操作，就返回我们自定义的Pop动画对象。
     */
    if (operation == UINavigationControllerOperationPop) {
    
        return [[PopAnimation alloc] init];
    }
    
    return nil;
}


//苹果让我们返回一个交互的对象，用来实时管理控制器之间转场动画的完成度，通过它我们可以让控制器的转场动画与用户交互（注意一点，如果方法1返回是nil，方法2是不会调用的，也就是说，只有我们自定义的动画才可以与控制器交互
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    /**
     *  方法2会传给你当前的动画对象animationController，判断如果是我们自定义的Pop动画对象，那么就返回interactivePopTransition来监控动画完成度。
     */
    if ([animationController isKindOfClass:[PopAnimation class]])
        return self.interactivePopTransition;
    
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
