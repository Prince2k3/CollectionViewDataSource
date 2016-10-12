//
//  ViewController4.m
//  Test
//
//  Created by Prince Ugwuh on 8/10/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "ViewController4.h"
#import "Test-Swift.h"
#import "TestTextFieldCell.h"

@interface ViewController4 () <MSCollectionViewDataSourceDelegate>
@property(nonatomic, weak, nullable) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong, nullable) MSCollectionViewDataSource *dataSource;
@end

@implementation ViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:[TestTextFieldCell identifier] bundle:nil] forCellWithReuseIdentifier:[TestTextFieldCell identifier]];
    
    [self build];
}


- (void)build {
    
    
    MSCollectionReusableViewItem *item = [[MSCollectionReusableViewItem alloc] init];
    item.identifier = [TestTextFieldCell identifier];
    item.item = nil;
    
    self.dataSource = [[MSCollectionViewDataSource alloc] initWithReusableViewItems:@[item] headerReusableViewItem:nil footerReusableViewItem:nil items:nil];
    self.dataSource.delegate = self;
    
    self.collectionView.dataSource = self.dataSource;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Mark - MSTableViewDataSourceDelegate

- (void)dataSource:(TestTextFieldCell *)cell didConfigureCell:(NSIndexPath *)indexPath {
    cell.textFieldValueDidChange = ^(NSString *text){
        NSLog(@"%@", text);
    };
}

@end
