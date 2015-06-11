//
//  SAArtist.m
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SAArtist.h"

@implementation SAArtist

+ (SAArtist *) artistOfName: (NSString *) name bio: (NSString *) bio image: (NSArray *) image uri:(NSString *)number {
    SAArtist *artist = [[self alloc] init];
    artist.name = name;
    artist.bio = bio;
    artist.image = image;
    artist.uri = number;
    return artist;
}

@end

//API key: QOTTQXCRUR2RFYVQQ