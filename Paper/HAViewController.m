//
//  HAViewController.m
//  Paper
//
//  Created by Heberti Almeida on 03/02/14.
//  Copyright (c) 2014 Heberti Almeida. All rights reserved.
//

#import "HAViewController.h"

@interface HAViewController ()

@property (nonatomic) NSInteger status;

@end

@implementation HAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _status = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 4;
    
//    cell.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doSingleTap)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
    return cell;
}


//
- (void)doSingleTap
{
    NSLog(@"Single tap");
    
    [UIView transitionWithView:_collectionView duration:.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //any animateable attribute here.
        
        if (_status == 0) {
            _collectionView.frame = CGRectMake(0 , 0, 320, 568);
            _status = 1;
        } else {
            _collectionView.frame = CGRectMake(0 , 314, 320, 254);
            _status = 0;
        }
        
    } completion:^(BOOL finished) {
        //whatever you want to do upon completion
    }];
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"resize");
//    
//    
//    if (_status == 0) {
//        return CGSizeMake(320, 568);
//    } else {
//        return CGSizeMake(142, 254);
//    }
//}



@end
