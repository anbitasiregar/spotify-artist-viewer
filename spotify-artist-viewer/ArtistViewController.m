//
//  ArtistViewController.m
//  spotify-artist-viewer
//
//  Created by Anbita Siregar on 6/9/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "ArtistViewController.h"
#import "SARequestManager.h"
#import "SAArtist.h"

@interface ArtistViewController ()
@property (weak, nonatomic) IBOutlet UITextView *artistBio;
@property (weak, nonatomic) IBOutlet UIImageView *artistImage;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@end



@implementation ArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setting image to a circle
    self.artistImage.layer.cornerRadius = 90;
    self.artistImage.layer.masksToBounds = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.artistName.text = self.artist.name;
    [[SARequestManager sharedManager] getBioWithArtist:self.artist.uri success:^(NSString *bio) {
        NSLog(@"returned: %@", bio);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.artistBio.text = bio;
            [self.artistBio setTextColor:[UIColor whiteColor]];
        });
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    NSString *url= self.artist.image[0][@"url"];
    NSLog(@"url: %@", url);
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    [self.artistImage setImage:image];
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
