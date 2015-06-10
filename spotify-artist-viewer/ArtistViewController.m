//
//  ArtistViewController.m
//  spotify-artist-viewer
//
//  Created by Anbita Siregar on 6/9/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "ArtistViewController.h"
#import "SARequestManager.h"

@interface ArtistViewController ()
@property (nonatomic) SARequestManager *SARequestManager;
@end



@implementation ArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showArtistName:(UIButton *)sender {
    if ([sender.currentTitle  isEqual: @"Artist"]) {
        [sender setTitle:@"test1" forState:UIControlStateNormal];
    }
}

- (IBAction)showArtistBio:(UIButton *)sender {
    if (![sender.currentTitle length]) {
        [sender setTitle:@"test1" forState:UIControlStateNormal];
    }
}
- (IBAction)showArtistPicture:(UIButton *)sender {
    if(![sender.currentTitle length]) {
        [sender setBackgroundImage:[UIImage imageNamed:@"test1"] forState:UIControlStateNormal];
    }
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
