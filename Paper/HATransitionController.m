//
//  HATransitionController.m
//  Paper
//
//  Created by Heberti Almeida on 11/02/14.
//  Copyright (c) 2014 Heberti Almeida. All rights reserved.
//

#import "HATransitionController.h"
#import "HATransitionLayout.h"

@interface HATransitionController ()

@property (nonatomic) HATransitionLayout* transitionLayout;
@property (nonatomic) id <UIViewControllerContextTransitioning> context;
@property (nonatomic) CGFloat initialPinchDistance;
@property (nonatomic) CGPoint initialPinchPoint;

@end


@implementation HATransitionController 

-(instancetype)initWithCollectionView:(UICollectionView*)collectionView
{
    self = [super init];
    if (self) {
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [collectionView addGestureRecognizer:pinchGesture];
        self.collectionView = collectionView;
    }
    return self;
}


-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
}


-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}


- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    self.context = transitionContext;
    UICollectionViewController* fromCollectionViewController = (UICollectionViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UICollectionViewController* toCollectionViewController   = (UICollectionViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    self.transitionLayout = (HATransitionLayout *)[fromCollectionViewController.collectionView startInteractiveTransitionToCollectionViewLayout:toCollectionViewController.collectionViewLayout completion:^(BOOL didFinish, BOOL didComplete) {
        [_context.containerView addSubview:toCollectionViewController.view];
        [_context completeTransition:didComplete];

        if (didComplete)
            self.collectionView.delegate = toCollectionViewController;
        else 
            self.collectionView.delegate = fromCollectionViewController;
        self.transitionLayout = nil;
        self.context = nil;
        self.hasActiveInteraction = FALSE;
    }];
}

-(void)updateWithProgress:(CGFloat)progress andOffset:(UIOffset)offset
{
    if (_context==nil) {
        return;
    }
    
    if ((progress != self.transitionLayout.transitionProgress) || !UIOffsetEqualToOffset(offset, self.transitionLayout.offset)) {
        [self.transitionLayout setOffset:offset];
        [self.transitionLayout setTransitionProgress:progress];
        [self.transitionLayout invalidateLayout];
        [_context updateInteractiveTransition:progress];
    }
}

-(void)updateWithProgress:(CGFloat)progress
{
    if (_context==nil) {
        return;
    }
    
    if (progress != self.transitionLayout.transitionProgress) {
        [self.transitionLayout setTransitionProgress:progress];
        [self.transitionLayout invalidateLayout];
        [_context updateInteractiveTransition:progress];
    }
}


-(void)endInteractionWithSuccess:(BOOL)success
{
    if (_context==nil)
    {
        self.hasActiveInteraction = FALSE;
        return;
    }
    if ((self.transitionLayout.transitionProgress > 0.1) && success)
    {
        [self.collectionView finishInteractiveTransition];
        [_context finishInteractiveTransition];
    }
    else
    {
        [self.collectionView cancelInteractiveTransition];
        [_context cancelInteractiveTransition];
    }
}

-(void)handlePinch:(UIPinchGestureRecognizer*)sender
{
    NSLog(@"gesture %d", sender.state);
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self endInteractionWithSuccess:TRUE];
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateCancelled)
    {
        [self endInteractionWithSuccess:FALSE];
        return;
    }
    
    if (sender.numberOfTouches < 2)
    {
        return;
    }
    
    CGPoint point1 = [sender locationOfTouch:0 inView:sender.view];
    CGPoint point2 = [sender locationOfTouch:1 inView:sender.view];
    CGFloat distance = sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));
    CGPoint point = [sender locationInView:sender.view];
    
//    NSLog(@"distance: %f", distance);
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        if (self.hasActiveInteraction)
        {
            return;
        }
        self.initialPinchDistance = distance;
        self.initialPinchPoint = point;
        self.hasActiveInteraction = TRUE;
        [self.delegate interactionBeganAtPoint:point];
        return;
    }
    if (!self.hasActiveInteraction)
    {
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGFloat offsetX = point.x - self.initialPinchPoint.x;
        CGFloat offsetY = point.y - self.initialPinchPoint.y;
        UIOffset offsetToUse = UIOffsetMake(offsetX, offsetY);
        
//        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:self.initialPinchPoint];
//        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//        UIOffset offsetToUse = UIOffsetMake(cell.bounds.origin.x, cell.bounds.origin.y + offsetY);
        
        
        CGFloat distanceDelta = distance - self.initialPinchDistance;
        if (self.navigationOperation == UINavigationControllerOperationPop)
        {
            distanceDelta = -distanceDelta;
        }
        
        CGFloat dimension = sqrt(CGRectGetWidth(self.collectionView.bounds) * CGRectGetWidth(self.collectionView.bounds) + CGRectGetHeight(self.collectionView.bounds) * CGRectGetHeight(self.collectionView.bounds));
        
        CGFloat progress = MAX(MIN((distanceDelta / dimension), 1.0), 0.0);
        [self updateWithProgress:progress andOffset:offsetToUse];
//        [self updateWithProgress:progress];
        return;
    }
}


@end
