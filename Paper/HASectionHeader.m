//
//  HASectionHeader.m
//  Paper
//
//  Created by Istvan Balogh on 19/10/14.
//  Copyright (c) 2014 Heberti Almeida. All rights reserved.
//

#import "HASectionHeader.h"

@interface HASectionHeader () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *reflectedImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *imageViews;
@property (weak, nonatomic) IBOutlet UILabel *logoLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation HASectionHeader

-(void)awakeFromNib{
    
    self.reflectedImage.image = [self.imageViews[0] image];
    self.reflectedImage.transform = CGAffineTransformMakeScale(1.0, -1.0);
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 4;
    
    // Gradient to top image
    
    for (UIImageView* imageView in self.imageViews) {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.colors = @[(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] CGColor],
                            (id)[[UIColor colorWithWhite:0 alpha:0] CGColor]];
        gradient.frame = imageView.bounds;
        [imageView.layer insertSublayer:gradient atIndex:0];
    }
    

    // Gradient to reflected image
    CAGradientLayer *gradientReflected = [CAGradientLayer layer];
    gradientReflected.frame = self.reflectedImage.bounds;
    gradientReflected.colors = @[(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor],
                                 (id)[[UIColor colorWithWhite:0 alpha:0] CGColor]];
    [self.reflectedImage.layer insertSublayer:gradientReflected atIndex:0];
    
    // Label Shadow
    [self.logoLabel setClipsToBounds:NO];
    [self.logoLabel.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.logoLabel.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.logoLabel.layer setShadowRadius:1.0];
    [self.logoLabel.layer setShadowOpacity:0.6];
    
    // Label Shadow
    [self.titleLabel setClipsToBounds:NO];
    [self.titleLabel.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.titleLabel.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.titleLabel.layer setShadowRadius:1.0];
    [self.titleLabel.layer setShadowOpacity:0.6];
    
    // SubTitleLabel Shadow
    [self.subTitleLabel setClipsToBounds:NO];
    [self.subTitleLabel.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.subTitleLabel.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.subTitleLabel.layer setShadowRadius:1.0];
    [self.subTitleLabel.layer setShadowOpacity:0.6];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger newPage = lround(fractionalPage);
    if (self.pageControl.currentPage != newPage) {
        self.reflectedImage.image = [self.imageViews[newPage] image];
        self.pageControl.currentPage = newPage;
        
        if (self.didPagControllerChanged) {
            self.didPagControllerChanged(newPage);
        }
    }
}

@end
