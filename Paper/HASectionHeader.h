//
//  HASectionHeader.h
//  Paper
//
//  Created by Istvan Balogh on 19/10/14.
//  Copyright (c) 2014 Heberti Almeida. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NIB_NAME_HEADER @"HASectionHeader"

@interface HASectionHeader : UICollectionViewCell

@property (nonatomic, copy) void (^didPagControllerChanged)(int newPageIndex);

@end
