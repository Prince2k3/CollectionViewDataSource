//
//  ViewController.m
//  Test
//
//  Created by Prince Ugwuh on 8/10/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "ViewController.h"
#import "Test-Swift.h"
#import "TestCell.h"

@interface ViewController () 
@property(nonatomic, weak, nullable) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong, nullable) MSCollectionViewDataSource *dataSource;
@end

@implementation ViewController

- (NSArray *)sampleData {
        return @[@"Bananas", @"Apples", @"Oranges", @"Grapes", @"Strawberry", @"Pineapple", @"Mango"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Note: You can set the items anytime you want. Make sure you reload the table view for the changes to take effect.
    
    [self.collectionView registerClass:[TestCell class] forCellWithReuseIdentifier:[TestCell identifier]];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)[self.collectionView collectionViewLayout];
    layout.itemSize = CGSizeMake(100, 100);
    
    self.dataSource = [[MSCollectionViewDataSource alloc] initWithCellIdentifier:[TestCell identifier] headerReusableViewItem:nil footerReusableViewItem:nil items:self.sampleData];
    self.collectionView.dataSource = self.dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
