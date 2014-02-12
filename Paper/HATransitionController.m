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
@property (nonatomic) CGFloat initialScale;

@end


@implementation HATransitionController

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
{
    self = [super init];
    if (self != nil)
    {
        // setup our pinch gesture:
        //  pinch in closes photos down into a stack,
        //  pinch out expands the photos intoa  grid
        //
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [collectionView addGestureRecognizer:pinchGesture];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerGesture:)];
        panGestureRecognizer.delegate = self;
        panGestureRecognizer.minimumNumberOfTouches = 1;
        panGestureRecognizer.maximumNumberOfTouches = 1;
        [collectionView addGestureRecognizer:panGestureRecognizer];
        
        self.collectionView = collectionView;
    }
    return self;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // transition animation time between grid and stack layout
    return 1.0;
}

// required method for view controller transitions, called when the system needs to set up
// the interactive portions of a view controller transition and start the animations
//
- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    self.context = transitionContext;
    
    UICollectionViewController *fromCollectionViewController =
    (UICollectionViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UICollectionViewController *toCollectionViewController =
    (UICollectionViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:[toCollectionViewController view]];
    
    self.transitionLayout = (HATransitionLayout *)[fromCollectionViewController.collectionView startInteractiveTransitionToCollectionViewLayout:toCollectionViewController.collectionViewLayout completion:^(BOOL didFinish, BOOL didComplete) {
        [self.context completeTransition:didComplete];
        self.transitionLayout = nil;
        self.context = nil;
        self.hasActiveInteraction = NO;
    }];
}

- (void)updateWithProgress:(CGFloat)progress andOffset:(UIOffset)offset
{
    if (self.context != nil &&  // we must have a valid context for updates
        ((progress != self.transitionLayout.transitionProgress) || !UIOffsetEqualToOffset(offset, self.transitionLayout.offset)))
    {
        [self.transitionLayout setOffset:offset];
        [self.transitionLayout setTransitionProgress:progress];
        [self.transitionLayout invalidateLayout];
        [self.context updateInteractiveTransition:progress];
    }
}

- (void)updateWithProgress:(CGFloat)progress
{
    if (self.context != nil && ((progress != self.transitionLayout.transitionProgress)))
    {
        [self.transitionLayout setTransitionProgress:progress];
        [self.transitionLayout invalidateLayout];
        [self.context updateInteractiveTransition:progress];
    }
}

// called by our pinch gesture recognizer when the gesture has finished or cancelled, which
// in turn is responsible for finishing or cancelling the transition.
//
- (void)endInteractionWithSuccess:(BOOL)success
{
    if (self.context == nil)
    {
        self.hasActiveInteraction = NO;
    }
    // allow for the transition to finish when it's progress has started as a threshold of 10%,
    // if you want to require the pinch gesture with a wider threshold, change it it a value closer to 1.0
    //
    else if ((self.transitionLayout.transitionProgress > 0.1) && success)
    {
        [self.collectionView finishInteractiveTransition];
        [self.context finishInteractiveTransition];
    }
    else
    {
        [self.collectionView cancelInteractiveTransition];
        [self.context cancelInteractiveTransition];
    }
}

// action method for our pinch gesture recognizer
//
- (void)handlePinch:(UIPinchGestureRecognizer *)sender
{
    // here we want to end the transition interaction if the user stops or finishes the pinch gesture
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self endInteractionWithSuccess:YES];
    }
    else if (sender.state == UIGestureRecognizerStateCancelled)
    {
        [self endInteractionWithSuccess:NO];
    }
    else if (sender.numberOfTouches == 2)
    {
        // here we expect two finger touch
        CGPoint point;      // the main touch point
        CGPoint point1;     // location of touch #1
        CGPoint point2;     // location of touch #2
        CGFloat distance;   // computed distance between both touches
        
        // return the locations of each gesture’s touches in the local coordinate system of a given view
        point1 = [sender locationOfTouch:0 inView:sender.view];
        point2 = [sender locationOfTouch:1 inView:sender.view];
        distance = sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));
        
        // get the main touch point
        point = [sender locationInView:sender.view];
        
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            // start the pinch in our out
            if (!self.hasActiveInteraction)
            {
                self.initialPinchDistance = distance;
                self.initialPinchPoint = point;
                self.hasActiveInteraction = YES;    // the transition is in active motion
                [self.delegate interactionBeganAtPoint:point];
            }
        }
        
        if (self.hasActiveInteraction)
        {
            if (sender.state == UIGestureRecognizerStateChanged)
            {
                // update the progress of the transtition as the user continues to pinch
                CGFloat delta = distance - self.initialPinchDistance;
                CGFloat offsetX = point.x - self.initialPinchPoint.x;
//                CGFloat offsetY = point.y - self.initialPinchPoint.y;
                CGFloat offsetY = (point.y - self.initialPinchPoint.y) + delta/M_PI;
                UIOffset offsetToUse = UIOffsetMake(offsetX, offsetY);
                
                CGFloat distanceDelta = distance - self.initialPinchDistance;
                if (self.navigationOperation == UINavigationControllerOperationPop)
                {
                    distanceDelta = -distanceDelta;
                }
//                CGFloat dimension = sqrt(self.collectionView.bounds.size.width * self.collectionView.bounds.size.width + self.collectionView.bounds.size.height * self.collectionView.bounds.size.height);
//                CGFloat progress = MAX(MIN((distanceDelta / dimension), 1.0), 0.0);
                CGFloat progress = MAX(MIN(((distanceDelta + sender.velocity * M_PI) / 250), 1.0), 0.0);
                
                // tell our UICollectionViewTransitionLayout subclass (transitionLayout)
                // the progress state of the pinch gesture
                //
                [self updateWithProgress:progress andOffset:offsetToUse];
            }
        }
    }
}

- (void)oneFingerGesture:(UIPanGestureRecognizer *)sender
{
        CGPoint point = [sender locationInView:sender.view];
        NSLog(@"point.x %f", point.x);
        NSLog(@"point.y %f", point.y);
}


@end
