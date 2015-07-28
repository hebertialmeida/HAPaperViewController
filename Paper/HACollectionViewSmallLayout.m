//
//  HACollectionViewSmallLayout.m
//  Paper
//
//  Created by Heberti Almeida on 04/02/14.
//  Copyright (c) 2014 Heberti Almeida. All rights reserved.
//

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#import "HACollectionViewSmallLayout.h"

@implementation HACollectionViewSmallLayout

- (id)init
{
    if (!(self = [super init])) return nil;
    
    [self setup];

    return self;
}

-(void)awakeFromNib{
    
    [self setup];
}

-(void)setup{
    self.itemSize = CGSizeMake(142, 254);
    self.sectionInset = UIEdgeInsetsMake((iPhone5 ? 314 : 224), -[UIScreen mainScreen].bounds.size.width, 0, 2);
    self.minimumInteritemSpacing = 10.0f;
    self.minimumLineSpacing = 2.0f;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.headerReferenceSize = [UIScreen mainScreen].bounds.size ;
    self.collectionView.pagingEnabled = NO;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    // This will schedule calls to layoutAttributesForElementsInRect: as the
    // collectionView is scrolling.
    return YES;
}


@end
