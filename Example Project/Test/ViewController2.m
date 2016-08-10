//
//  ViewController2.m
//  Test
//
//  Created by Prince Ugwuh on 8/10/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "ViewController2.h"
#import "Test-Swift.h"
#import "TestCell.h"

@interface ViewController2 ()
@property(nonatomic, weak, nullable) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong, nullable) MSCollectionViewDataSource *dataSource;
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[TestCell class] forCellWithReuseIdentifier:[TestCell identifier]];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)[self.collectionView collectionViewLayout];
    layout.itemSize = CGSizeMake(100, 100);
    
    [self build];
}


- (void)build {
    
    NSMutableArray *items = @[].mutableCopy;
    
    for (NSInteger i = 0; i < 100; i++) {
        MSCollectionReusableViewItem *item = [[MSCollectionReusableViewItem alloc] init];
        item.identifier = [TestCell identifier];
        item.item = [NSString stringWithFormat:@"%ld", i];
        [items addObject:item];
    }
    
    self.dataSource = [[MSCollectionViewDataSource alloc] initWithReusableViewItems:items headerReusableViewItem:nil footerReusableViewItem:nil items:nil];

    self.collectionView.dataSource = self.dataSource;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

