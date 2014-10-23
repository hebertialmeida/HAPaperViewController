//
//  HAPaperCollectionViewController.m
//  Paper
//
//  Created by Heberti Almeida on 11/02/14.
//  Copyright (c) 2014 Heberti Almeida. All rights reserved.
//

#import "HAPaperCollectionViewController.h"
#import "HATransitionLayout.h"
#import "HASmallCollectionViewController.h"
#import "HASectionHeader.h"

#define CELL_ID @"CELL_ID"

@interface HAPaperCollectionViewController ()

@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, strong) HASectionHeader* header;

@end


@implementation HAPaperCollectionViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_ID];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.topItem.title = @"";
    
    [self.collectionView registerNib:[UINib nibWithNibName:NIB_NAME_HEADER bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];

    [self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.delaysContentTouches = NO;
    self.count = 20;
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
    return self.count;
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {

    if (!self.header) {
        
        self.header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                    withReuseIdentifier:@"header"
                                                           forIndexPath:indexPath];
        __weak __typeof__(self) weakSelf = self;
        self.header.didPagControllerChanged = ^(NSInteger newPageIndex){
            
            weakSelf.count = arc4random_uniform(20) + 3;
            [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        };
    }
    return self.header;
}

#pragma mark - Hide StatusBar
- (BOOL)prefersStatusBarHidden
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    return YES;
}

@end
