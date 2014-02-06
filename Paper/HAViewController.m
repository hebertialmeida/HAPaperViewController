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

@property (nonatomic) NSInteger slide;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) HACollectionViewLargeLayout *largeLayout;
@property (nonatomic, strong) HACollectionViewSmallLayout *smallLayout;
@property (nonatomic, getter=isFullscreen) BOOL fullscreen;
@property (nonatomic, strong) UIImageView *topImage;
@property (nonatomic, strong) UIImageView *reflected;

@end

@implementation HAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _scale = 1.0;
    _galleryImages = @[@"Image", @"Image1", @"Image2", @"Image3"];
    _slide = 1;
    
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
    _collectionView.backgroundColor = [UIColor clearColor];
    
    // Shadow on collection
//    [_collectionView setClipsToBounds:NO];
//    [_collectionView.layer setShadowOffset:CGSizeMake(0, 0)];
//    [_collectionView.layer setShadowColor:[[UIColor blackColor] CGColor]];
//    [_collectionView.layer setShadowRadius:6.0];
//    [_collectionView.layer setShadowOpacity:0.5];
//
//    // Improve shadow performance
//    CGPathRef path = [UIBezierPath bezierPathWithRect:_collectionView.bounds].CGPath;
//    [_collectionView.layer setShadowPath:path];
    
    
    // Init mainView
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mainView.clipsToBounds = YES;
    _mainView.layer.cornerRadius = 4;
    [self.view insertSubview:_mainView belowSubview:_collectionView];
    
    // ImageView on top
    _topImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_galleryImages[_slide]]];
    _reflected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_galleryImages[_slide]]];
    [_mainView addSubview:_topImage];
    [_mainView addSubview:_reflected];
    
    
    // Reflected image
    CGRect reflectedFrame = _reflected.frame;
    reflectedFrame.origin.y = CGRectGetHeight(_topImage.bounds);
    _reflected.frame = reflectedFrame;
    _reflected.transform = CGAffineTransformMakeScale(1.0, -1.0); // Reflect image
    
    
    // Gradient top image
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _topImage.bounds;
    gradient.colors = @[(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] CGColor],
                        (id)[[UIColor colorWithWhite:0 alpha:0] CGColor]];
    [_topImage.layer insertSublayer:gradient atIndex:0];
    
    
    // Gradient reflected image
    CAGradientLayer *gradientReflected = [CAGradientLayer layer];
    gradientReflected.frame = _reflected.bounds;
    gradientReflected.colors = @[(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor],
                                 (id)[[UIColor colorWithWhite:0 alpha:0] CGColor]];
    [_reflected.layer insertSublayer:gradientReflected atIndex:0];
    
    
    // Content perfect pixel
    UIView *perfectPixelContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_topImage.bounds), 1)];
    perfectPixelContent.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    [_topImage addSubview:perfectPixelContent];
    
    
    // Label logo
    UILabel *logo = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 320, 30)];
    logo.backgroundColor = [UIColor clearColor];
    logo.textColor = [UIColor whiteColor];
    logo.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    logo.textAlignment = NSTextAlignmentLeft;
    logo.text = @"Paper by Heberti";
    
    // Label Shadow
    [logo setClipsToBounds:NO];
    [logo.layer setShadowOffset:CGSizeMake(0, 0)];
    [logo.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [logo.layer setShadowRadius:1.0];
    [logo.layer setShadowOpacity:0.6];
    [_mainView addSubview:logo];
    
    

    // Loop gallery - fix loop: http://bynomial.com/blog/?p=67
    NSTimer *timer = [NSTimer timerWithTimeInterval:5.0f target:self selector:@selector(changeSlide) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
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
        
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            // Change flow layout
            [_collectionView setCollectionViewLayout:_smallLayout animated:YES];
            _collectionView.backgroundColor = [UIColor clearColor];
            
            // Reset scale
            _mainView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:nil];
    }
    else {
        _fullscreen = YES;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            // Change flow layout
            [_collectionView setCollectionViewLayout:_largeLayout animated:YES];
            _collectionView.backgroundColor = [UIColor blackColor];
            
            // Transform to zoom in effect
            CGAffineTransform transform = _mainView.transform;
            _mainView.transform = CGAffineTransformScale(transform, 0.96, 0.96);
        } completion:nil];
    }
}


//
- (void)changeSlide
{
    if(_slide > _galleryImages.count-1)//an array count perhaps
        _slide = 0;
    
    UIImage *toImage = [UIImage imageNamed:_galleryImages[_slide]];
    [UIView transitionWithView:_mainView
                      duration:1.0f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _topImage.image = toImage;
                        _reflected.image = toImage;
                    } completion:NULL];
    _slide++;
}

//
//-(void)setTopImage:(UIImageView *)topImage
//{
//    NSLog(@"set image");
//    _reflected.image = [UIImage imageNamed:_galleryImages[_slide]];
//    _topImage.image = [UIImage imageNamed:_galleryImages[_slide]];
//}



@end
