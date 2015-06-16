//
//  ArtistViewController.m
//  spotify-artist-viewer
//
//  Created by Anbita Siregar on 6/9/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "ArtistViewController.h"
#import "SARequestManager.h"
#import "SAItem.h"
#import "FavoritesTableViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface ArtistViewController ()
@property (weak, nonatomic) IBOutlet UITextView *itemBioTextView;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) FavoritesTableViewController *favoritesTableViewController;
@end



@implementation ArtistViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setting image to a circle
    self.itemImageView.layer.cornerRadius = 90;
    self.itemImageView.layer.masksToBounds = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.itemNameLabel.text = self.item.name;
    self.itemNameLabel.adjustsFontSizeToFitWidth = YES;
    
    if ([self.item.type isEqualToString:@"artist"]) {
        [[SARequestManager sharedManager] getBioWithArtist:self.item.uri success:^(NSString *bio) {
            //NSLog(@"returned: %@", bio);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.itemBioTextView.text = bio;
                [self.itemBioTextView setTextColor:[UIColor whiteColor]];
                if (self.item.image.count > 0) {
                    //NSLog(@"url: %@", self.item.image[0]);
                    NSString *url= self.item.image[0][@"url"];
                    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:url]];
                }
            });
        } failure:^(NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    } else if ([self.item.type isEqualToString:@"song"]) {
        //tracks.items.album.images[0][@"url"]
        //tracks.items.album.name
        //tracks.items.artists[0]["name"]
        dispatch_async(dispatch_get_main_queue(), ^{
            self.itemBioTextView.text = self.item.bio;
            [self.itemBioTextView setTextColor:[UIColor whiteColor]];
            if (self.item.image.count > 0) {
                //NSLog(@"url: %@", self.item.image[0]);
                NSString *url= self.item.image[0][@"url"];
                [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:url]];
            }
        });
    } else if ([self.item.type isEqualToString:@"album"]) {
        [[SARequestManager sharedManager] getSonglistWithAlbum:self.item.uri success:^(NSString *bio) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.itemBioTextView.text = bio;
                [self.itemBioTextView setTextColor:[UIColor whiteColor]];
                if (self.item.image.count > 0) {
                    //NSLog(@"url: %@", self.item.image[0]);
                    NSString *url= self.item.image[0][@"url"];
                    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:url]];
                }
            });
        } failure:^(NSError *error) {
            NSLog(@"Error: %@", error);
        }];

    }
}

#pragma mark - Favorite Button Delegates
- (IBAction)favoriteButtonPressed:(UIButton *)sender {
    if (!self.favoriteButton.selected) {
        self.favoriteButton.selected = YES;
        [self.favoriteButton setBackgroundColor:[UIColor colorWithRed:(51.0/255) green:(51.0/255) blue:(51.0/255) alpha:1]];
        [self.favoriteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        self.favoritesTableViewController.favoriteItems[self.item.name] = [[NSMutableArray alloc] init];
        [self.favoritesTableViewController.favoriteItems[self.item.name] addObject:self.item];
        NSLog(@"favorites of type %@: %@",self.item.name, self.favoritesTableViewController.favoriteItems[self.item.name]);
    } else {
        self.favoriteButton.selected = NO;
        [self.favoriteButton setBackgroundColor:[UIColor colorWithRed:(64.0/255) green:(128.0/255) blue:0.0 alpha:1]];
        [self.favoriteButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        
        [self.favoritesTableViewController.favoriteItems[self.item.name] removeObject:self.item];
    }
}

 #pragma mark - Navigation
- (IBAction)backButtonWasPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
 
 
 /*
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
