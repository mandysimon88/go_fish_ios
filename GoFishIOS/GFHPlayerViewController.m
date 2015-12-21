//
//  GFHPlayerViewController.m
//  GoFishIOS
//
//  Created by Amanda Simon on 12/16/15.
//  Copyright © 2015 RoleModel Software. All rights reserved.
//

#import "GFHPlayerViewController.h"
#import "GFHCardCollectionCell.h"
#import "Player.h"

static NSString * const CELL_ID = @"cardCell";

@interface GFHPlayerViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@end

@implementation GFHPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake (71, 96);
    self.cardCollectionView.collectionViewLayout = layout;
}

- (void)setPlayer:(Player *)player {
    _player = player;
    [self setUpPlayerInfo];
}

- (void)setUpPlayerInfo {
    self.playerNameLabel.text =_player.name;
    [self.cardCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// look at the delegate and datasource protocols for collectionviews to find out what callbacks (like below) that you need to handle the CLICKING people will do on cards

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.player.cards count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GFHCardCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: CELL_ID forIndexPath:indexPath];
    cell.card = self.player.cards[indexPath.row];
    return cell;
}

@end