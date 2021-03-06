//
//  GFHNumberOfPlayersButtonsViewController.m
//  GoFishIOS
//
//  Created by Amanda Simon on 12/25/15.
//  Copyright © 2015 RoleModel Software. All rights reserved.
//
//
#import "GFHNumberOfPlayersButtonsViewController.h"
#import "KTCenterFlowLayout.h"
#import "CALayer+RuntimeAttribute.h"
#import "GFHColors.h"
#import "GFHRepository.h"
#import "GFHMatchNewViewController.h"

static NSString * const CELL_ID = @"NumberOfPlayersButtonCell";

@interface GFHNumberOfPlayersButtonsViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *numberOfPlayersCollectionView;
@property (nonatomic, strong) NSArray *numberOfPlayers;
@property (nonatomic, assign) BOOL gameAlreadyRequested;
@end

@implementation GFHNumberOfPlayersButtonsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    KTCenterFlowLayout *layout = [KTCenterFlowLayout new];
    layout.minimumInteritemSpacing = 75.f;
    layout.minimumLineSpacing = 75.f;
    self.numberOfPlayersCollectionView.collectionViewLayout = layout;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _gameAlreadyRequested = NO;
 if ([[GFHRepository sharedRepository] loggedIn]) {
     [[GFHRepository sharedRepository] getNumberOfPlayersWithSuccess:^(NSArray *numberOfPlayers) {
        self.numberOfPlayers = numberOfPlayers;
        [self makeNumberOfPlayersButtons:self.numberOfPlayers];
    } failure:nil
     ];
 }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.numberOfPlayersButtons count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    [cell.contentView addSubview:self.numberOfPlayersButtons[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIButton *button = [self.numberOfPlayersButtons objectAtIndex:indexPath.row];
    return CGSizeMake(button.frame.size.width, button.frame.size.height);
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.numberOfPlayersCollectionView.collectionViewLayout invalidateLayout];
}

- (void)makeNumberOfPlayersButtons:(NSArray *)numberOfPlayers {
    self.numberOfPlayersButtons = [NSMutableArray new];
    for (NSNumber *number in self.numberOfPlayers) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0 , 100 , 100);
        [button setTag:[number integerValue]];
        [button addTarget:self
                   action:@selector(buttonPressed:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[number stringValue] forState:UIControlStateNormal];
        [button setTitleColor:GoFishYellow forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:40.f];
        button.tintColor = GoFishYellow;
        button.layer.borderWidth = 4;
        button.layer.cornerRadius = 10;
        button.layer.borderIBColor = GoFishYellow;
        button.layer.backgroundColor = GoFishBlue.CGColor;
        [self.numberOfPlayersButtons addObject:button];
    }
    [self.numberOfPlayersCollectionView reloadData];
}

- (IBAction)buttonPressed:(UIButton *)sender {
    if (!_gameAlreadyRequested) {
        NSInteger chosenNumberOfPlayers = sender.tag;
        [[GFHRepository new] postNumberOfPlayersWithSuccess:nil failure:^(NSString *errorMessage) { NSLog(@"%@", errorMessage);
        } withNumber: @(chosenNumberOfPlayers)];
        ((GFHMatchNewViewController*)_parent).speech.text = [NSString stringWithFormat:@"Game with %ld players requested!", (long)chosenNumberOfPlayers];
    }
    _gameAlreadyRequested = YES;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
