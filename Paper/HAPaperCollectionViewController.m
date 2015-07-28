//
//  HAPaperCollectionViewController.m
//  Paper
//
//  Created by Heberti Almeida on 11/02/14.
//  Copyright (c) 2014 Heberti Almeida. All rights reserved.
//

#import "HAPaperCollectionViewController.h"
#import "HATransitionLayout.h"
#import "MXKCardsView.h"
#import "MXKCardCell.h"

#define MAX_COUNT 20
#define CELL_ID @"CELL_ID"

#define CARD_CELL @"CARD_CELL"

@interface HAPaperCollectionViewController ()

@end


@implementation HAPaperCollectionViewController

- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout])
    {
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_ID];
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        
        
        //[self.collectionView registerClass:[MXKCardCell class] forCellWithReuseIdentifier:CARD_CELL];
        //UINib *cellNib = [UINib nibWithNibName:CARD_CELL bundle:nil];
        //[self.collectionView registerNib:cellNib forCellWithReuseIdentifier:CARD_CELL];

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
    
    static BOOL nibMyCellloaded = NO;
    [NSBundle mainBundle];
    
    if(!nibMyCellloaded)
    {
        UINib *nib = [UINib nibWithNibName: @"cardCell" bundle: [NSBundle mainBundle]];
        [collectionView registerNib:nib forCellWithReuseIdentifier:CARD_CELL];
        nibMyCellloaded = YES;
    }
    //[collectionView registerClass:[MXKCardCell class] forCellWithReuseIdentifier:CARD_CELL];
    
    MXKCardCell *cardCell = (MXKCardCell*)[collectionView dequeueReusableCellWithReuseIdentifier:CARD_CELL forIndexPath:indexPath];
    
    cardCell.backgroundColor = [UIColor whiteColor];
    cardCell.layer.cornerRadius = 4;
    cardCell.clipsToBounds = YES;
    
    [cardCell layoutIfNeeded];

    
    return cardCell;
    
//    cell.backgroundColor = [UIColor whiteColor];
//    cell.layer.cornerRadius = 4;
//    cell.clipsToBounds = YES;
//    
//    //UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Cell"]];
//    //cell.backgroundView = backgroundView;
//    
//    MXKCardsView *card= [[[NSBundle mainBundle] loadNibNamed:@"MXKCardsView" owner:self options:nil] lastObject];
//    
//    [card layoutIfNeeded];
//    
//    cell.backgroundView = card;
//    
//    [cell addSubview:card];
//    
//    [cell layoutIfNeeded];
//    
//    [card layoutIfNeeded];


    
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
