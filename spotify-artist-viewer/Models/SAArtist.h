//
//  SAArtist.h
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAArtist : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *bio;
@property (nonatomic) NSArray *image;
@property (nonatomic) NSString *uri;

+ (SAArtist *) artistOfName: (NSString *) name bio: (NSString *) bio image: (NSArray *) image uri: (NSString *) number;

@end
