//
//  HAViewController.m
//  Paper
//
//  Created by Heberti Almeida on 03/02/14.
//  Copyright (c) 2014 Heberti Almeida. All rights reserved.
//

#import "HAViewController.h"
#import "HACollectionViewSmallLayout.h"
#import "HACollectionViewLargeLayout.h"

@interface HAViewController ()

@property (nonatomic) NSInteger status;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, strong) HACollectionViewLargeLayout *largeLayout;
@property (nonatomic, strong) HACollectionViewSmallLayout *smallLayout;

@property (nonatomic, getter=isFullscreen) BOOL fullscreen;

@end

@implementation HAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _status = 0;
    _scale = 1.0;
    
    UIPinchGestureRecognizer *gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didReceivePinchGesture:)];
    [self.collectionView addGestureRecognizer:gesture];
    
    
    self.smallLayout = [[HACollectionViewSmallLayout alloc] init];
    self.largeLayout = [[HACollectionViewLargeLayout alloc] init];
    
//    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.smallLayout];
//    [self.collectionView registerClass:[AFCollectionViewCell class] forCellWithReuseIdentifier:ItemIdentifier];
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
    
    _collectionView.collectionViewLayout = _smallLayout;
    _collectionView.clipsToBounds = NO;
    _collectionView.backgroundColor = [UIColor orangeColor];
    
    // Shadow on collection
//    [_collectionView setClipsToBounds:NO];
    [_collectionView.layer setShadowOffset:CGSizeMake(0, 0)];
    [_collectionView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [_collectionView.layer setShadowRadius:6.0];
    [_collectionView.layer setShadowOpacity:0.5];
    
    // Improve shadow performance
    CGPathRef path = [UIBezierPath bezierPathWithRect:_collectionView.bounds].CGPath;
    [_collectionView.layer setShadowPath:path];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)didReceivePinchGesture:(UIPinchGestureRecognizer*)gesture
{
    NSLog(@"scale %f", gesture.scale);
}

///
///
///
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 4;
    
//    cell.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doSingleTap)];
//    singleTap.numberOfTapsRequired = 1;
//    [self.view addGestureRecognizer:singleTap];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.collectionView.collectionViewLayout invalidateLayout];
    
    if (_fullscreen) {
        _fullscreen = NO;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
        
        [_collectionView snapshotViewAfterScreenUpdates:YES];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_collectionView setCollectionViewLayout:_smallLayout animated:YES];
        } completion:nil];
    }
    else {
        _fullscreen = YES;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_collectionView setCollectionViewLayout:_largeLayout animated:YES];
        } completion:nil];
    }
}



@end
