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

@end
