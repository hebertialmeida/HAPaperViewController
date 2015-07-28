//
//  MXKCardCell.m
//  Paper
//
//  Created by Максим Колесник on 28.07.15.
//  Copyright (c) 2015 Sugar And Candy LLC. All rights reserved.
//

#import "MXKCardCell.h"

@implementation MXKCardCell

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        NSString *cellNibName = @"CARD_CELL";
        NSArray *resultantNibs = [[NSBundle mainBundle] loadNibNamed:@"CARD_CELL" owner:nil options:nil];
        
        if ([resultantNibs count] < 1) {
            return nil;
        }
        
        if (![[resultantNibs objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [resultantNibs objectAtIndex:0];
    }
    
    return self;    
}
@end
