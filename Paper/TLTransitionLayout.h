//
//  TLTransitionLayout.h
//
//  Copyright (c) 2013 Tim Moose (http://tractablelabs.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

/**
 A subclass of `UICollectionViewTransitionLayout` that interpolates linearly between
 layouts and optionally content offsets. The target offset can be specified directly
 by setting the `toContentOffset` property. The `UICollectionView+TLTransitioning` category
 provides API for calculating useful values for `toContentOffset`.
 
 When the transition is finalized, the collection view will set `contentOffset`
 back to it's original value. To negate this, one can set it back to the value
 of `toContentOffset` in the transition's completion block. This class conforms
 to the `TLTransitionAnimatorLayout` protocol, so when used with
 `[UICollectionView+TLTransitioning transitionToCollectionViewLayout:duration:completion:]`,
 this negation happens automatically.
 */

#import <UIKit/UIKit.h>
#import "UICollectionView+TLTransitioning.h"

@interface TLTransitionLayout : UICollectionViewTransitionLayout <TLTransitionAnimatorLayout>

/**
 When specified, the content offset will be transitioned from the current value
 to this value.
 */
 @property (nonatomic) CGPoint toContentOffset;

/**
 The initial content offset.
 */
@property (nonatomic, readonly) CGPoint fromContentOffset;

/**
 Optional callback to modify the interpolated layout attributes. Can be used to customize the
 animation or to substitute a custom `UICollectionViewLayoutAttributes` subclass.
 */
@property (strong, nonatomic) UICollectionViewLayoutAttributes *(^updateLayoutAttributes)(UICollectionViewLayoutAttributes *layoutAttributes, UICollectionViewLayoutAttributes *fromAttributes, UICollectionViewLayoutAttributes *toAttributes, CGFloat progress);

/**
 Optional callback when progress changes. Can be used to modify things outside of the
 scope of the layout
 */
@property (strong, nonatomic) void(^progressChanged)(CGFloat progress);

@end
