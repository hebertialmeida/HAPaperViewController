//
//  HANavigationViewController.m
//  Paper
//
//  Created by Istvan Balogh on 15/10/14.
//  Copyright (c) 2014 Heberti Almeida. All rights reserved.
//

#import "HANavigationViewController.h"
#import "HASmallCollectionViewController.h"
#import "HACollectionViewSmallLayout.h"


@interface HANavigationViewController ()<UINavigationControllerDelegate, HATransitionControllerDelegate>

@property (nonatomic, strong) HATransitionController *transitionController;

@end

@implementation HANavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
    self.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if ([viewController isKindOfClass:[HASmallCollectionViewController class]] && !self.transitionController) {

        
        HASmallCollectionViewController *collectionViewController = (HASmallCollectionViewController*)viewController;
        
        self.transitionController = [[HATransitionController alloc] initWithCollectionView:collectionViewController.collectionView];
        self.transitionController.delegate = self;
    }
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    
    if ([self.topViewController isKindOfClass:[HASmallCollectionViewController class]]) {
        
        self.transitionController = nil;
    }
    
    return [super popViewControllerAnimated:animated];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)interactionBeganAtPoint:(CGPoint)point
{
    // Very basic communication between the transition controller and the top view controller
    // It would be easy to add more control, support pop, push or no-op
    HASmallCollectionViewController *presentingVC = (HASmallCollectionViewController *)[self topViewController];
    HASmallCollectionViewController *presentedVC = (HASmallCollectionViewController *)[presentingVC nextViewControllerAtPoint:point];
    if (presentedVC!=nil)
    {
        [self pushViewController:presentedVC animated:YES];
    }
    else
    {
        [self popViewControllerAnimated:YES];
    }
}


- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    if (animationController==self.transitionController) {
        return self.transitionController;
    }
    return nil;
}


- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if (![fromVC isKindOfClass:[UICollectionViewController class]] || ![toVC isKindOfClass:[UICollectionViewController class]])
    {
        return nil;
    }
    if (!self.transitionController.hasActiveInteraction)
    {
        return nil;
    }
    
    self.transitionController.navigationOperation = operation;
    return self.transitionController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
