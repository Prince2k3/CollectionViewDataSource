//
//  ViewController3.m
//  Test
//
//  Created by Prince Ugwuh on 8/10/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "ViewController3.h"
#import "Test-Swift.h"
#import "TestCell.h"

@interface ViewController3 () //<MSCollectionViewDataSourceDelegate>
@property(nonatomic, weak, nullable) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong, nullable) MSCollectionViewSectionDataSource *sectionDataSource;
@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[TestCell class] forCellWithReuseIdentifier:[TestCell identifier]];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)[self.collectionView collectionViewLayout];
    layout.itemSize = CGSizeMake(100, 100);
    
    [self build];
}


- (void)build {
    
    NSMutableArray *dataSources = @[].mutableCopy;
    for (NSInteger i = 0; i < 3; i++) {
        NSMutableArray *items = @[].mutableCopy;
        
        for (NSInteger j = 0; j < 10; j++) {
            [items addObject:[NSString stringWithFormat:@"%ld", j]];
        }
        
        MSCollectionViewDataSource *dataSource = [[MSCollectionViewDataSource alloc] initWithCellIdentifier:[TestCell identifier] headerReusableViewItem:nil footerReusableViewItem:nil items:items];
        dataSource.title = [NSString stringWithFormat:@"Section %ld", i];
        [dataSources addObject:dataSource];
    }
    
    self.sectionDataSource = [[MSCollectionViewSectionDataSource alloc] initWithDataSources:dataSources headerReusableViewItem:nil footerReusableViewItem:nil];
    self.sectionDataSource.delegate = self;
    
    self.collectionView.dataSource = self.sectionDataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end