//
//  HAPaperCollectionViewController.m
//  Paper
//
//  Created by Heberti Almeida on 11/02/14.
//  Copyright (c) 2014 Heberti Almeida. All rights reserved.
//

#import "HAPaperCollectionViewController.h"
#import "HATransitionLayout.h"

#define MAX_COUNT 20
#define CELL_ID @"CELL_ID"

@interface HAPaperCollectionViewController ()

@end


@implementation HAPaperCollectionViewController

- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout])
    {
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_ID];
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

#pragma mark - Hide StatusBar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 4;
    cell.clipsToBounds = YES;
    
    UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Cell"]];
    cell.backgroundView = backgroundView;
    
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MAX_COUNT;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(UICollectionViewController*)nextViewControllerAtPoint:(CGPoint)point
{
    return nil;
}

- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView
                        transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
{
    HATransitionLayout *transitionLayout = [[HATransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout];
    return transitionLayout;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Adjust scrollView decelerationRate
    self.collectionView.decelerationRate = self.class != [HAPaperCollectionViewController class] ? UIScrollViewDecelerationRateNormal : UIScrollViewDecelerationRateFast;
}

@end
