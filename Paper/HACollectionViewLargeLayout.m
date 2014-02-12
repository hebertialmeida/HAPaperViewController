//
//  HACollectionViewLargeLayout.m
//  Paper
//
//  Created by Heberti Almeida on 04/02/14.
//  Copyright (c) 2014 Heberti Almeida. All rights reserved.
//

#import "HACollectionViewLargeLayout.h"

@implementation HACollectionViewLargeLayout

- (id)init
{
    if (!(self = [super init])) return nil;
    
    self.itemSize = CGSizeMake(320, 568);
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.minimumInteritemSpacing = 10.0f;
    self.minimumLineSpacing = 4.0f;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [self layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        if (layoutAttributes.representedElementCategory != UICollectionElementCategoryCell)
            continue; // skip headers
        
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
            
            layoutAttributes.alpha = 0;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end
