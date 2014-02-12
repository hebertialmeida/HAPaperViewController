//
//  HASmallCollectionViewController.m
//  Paper
//
//  Created by Heberti Almeida on 11/02/14.
//  Copyright (c) 2014 Heberti Almeida. All rights reserved.
//

#import "HASmallCollectionViewController.h"
#import "HACollectionViewLargeLayout.h"

@interface HASmallCollectionViewController ()

@property (nonatomic, assign) NSInteger slide;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *topImage;
@property (nonatomic, strong) UIImageView *reflected;
@property (nonatomic, strong) NSArray *galleryImages;

@end

@implementation HASmallCollectionViewController

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [self nextViewControllerAtPoint:CGPointZero];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionViewController *)nextViewControllerAtPoint:(CGPoint)point
{
    // We could have multiple section stacks and find the right one,
    HACollectionViewLargeLayout *largeLayout = [[HACollectionViewLargeLayout alloc] init];
    HAPaperCollectionViewController *nextCollectionViewController = [[HAPaperCollectionViewController alloc] initWithCollectionViewLayout:largeLayout];
    
    nextCollectionViewController.useLayoutToLayoutNavigationTransitions = YES;
    return nextCollectionViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Gallery
    _galleryImages = @[@"Image", @"Image1", @"Image2", @"Image3", @"Image4"];
    _slide = 0;
    
    
    // Init mainView
    _mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    _mainView.clipsToBounds = YES;
    _mainView.layer.cornerRadius = 4;
    [self.view insertSubview:_mainView belowSubview:self.collectionView];
    
    // ImageView on top
    _topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    _reflected = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_topImage.bounds), 320, 320)];
    [_mainView addSubview:_topImage];
    [_mainView addSubview:_reflected];
    
    
    // Reflect imageView
    _reflected.transform = CGAffineTransformMakeScale(1.0, -1.0);
    
    
    // Gradient to top image
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _topImage.bounds;
    gradient.colors = @[(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] CGColor],
                        (id)[[UIColor colorWithWhite:0 alpha:0] CGColor]];
    [_topImage.layer insertSublayer:gradient atIndex:0];
    
    
    // Gradient to reflected image
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
    UILabel *logo = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 290, 0)];
    logo.backgroundColor = [UIColor clearColor];
    logo.textColor = [UIColor whiteColor];
    logo.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    logo.text = @"Paper";
    [logo sizeToFit];
    // Label Shadow
    [logo setClipsToBounds:NO];
    [logo.layer setShadowOffset:CGSizeMake(0, 0)];
    [logo.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [logo.layer setShadowRadius:1.0];
    [logo.layer setShadowOpacity:0.6];
    [_mainView addSubview:logo];
    
    
    // Label Title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, logo.frame.origin.y + CGRectGetHeight(logo.frame) + 8, 290, 0)];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    title.text = @"Heberti Almeida";
    [title sizeToFit];
    // Label Shadow
    [title setClipsToBounds:NO];
    [title.layer setShadowOffset:CGSizeMake(0, 0)];
    [title.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [title.layer setShadowRadius:1.0];
    [title.layer setShadowOpacity:0.6];
    [_mainView addSubview:title];
    
    
    // Label SubTitle
    UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, title.frame.origin.y + CGRectGetHeight(title.frame), 290, 0)];
    subTitle.backgroundColor = [UIColor clearColor];
    subTitle.textColor = [UIColor whiteColor];
    subTitle.font = [UIFont fontWithName:@"Helvetica" size:13];
    subTitle.text = @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit";
    subTitle.lineBreakMode = NSLineBreakByWordWrapping;
    subTitle.numberOfLines = 0;
    [subTitle sizeToFit];
    // Label Shadow
    [subTitle setClipsToBounds:NO];
    [subTitle.layer setShadowOffset:CGSizeMake(0, 0)];
    [subTitle.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [subTitle.layer setShadowRadius:1.0];
    [subTitle.layer setShadowOpacity:0.6];
    [_mainView addSubview:subTitle];
    
    
    // First Load
    [self changeSlide];
    
    // Loop gallery - fix loop: http://bynomial.com/blog/?p=67
    NSTimer *timer = [NSTimer timerWithTimeInterval:5.0f target:self selector:@selector(changeSlide) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

#pragma mark - Change slider
- (void)changeSlide
{
    //    if (_fullscreen == NO && _transitioning == NO) {
    if(_slide > _galleryImages.count-1) _slide = 0;
    
    UIImage *toImage = [UIImage imageNamed:_galleryImages[_slide]];
    [UIView transitionWithView:_mainView
                      duration:0.6f
                       options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationCurveEaseInOut
                    animations:^{
                        _topImage.image = toImage;
                        _reflected.image = toImage;
                    } completion:nil];
    _slide++;
    //    }
}

@end
