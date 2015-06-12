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

@interface ArtistViewController ()
@property (weak, nonatomic) IBOutlet UITextView *itemBio;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@end



@implementation ArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setting image to a circle
    self.itemImage.layer.cornerRadius = 90;
    self.itemImage.layer.masksToBounds = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.itemName.text = self.item.name;
    [[SARequestManager sharedManager] getBioWithArtist:self.item.uri success:^(NSString *bio) {
        NSLog(@"returned: %@", bio);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.itemBio.text = bio;
            [self.itemBio setTextColor:[UIColor whiteColor]];
        });
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    NSString *url= self.item.image[0][@"url"];
    NSLog(@"url: %@", url);
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    [self.itemImage setImage:image];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation
 
 

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
