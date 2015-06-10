//
//  SAArtist.m
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SAArtist.h"

@implementation SAArtist

+ (SAArtist *) artistOfName: (NSString *) name bio: (NSString *) bio url: (NSString *) url {
    SAArtist *artist = [[self alloc] init];
    artist.name = name;
    artist.bio = bio;
    artist.imageURL = url;
    return artist;
}

@end
