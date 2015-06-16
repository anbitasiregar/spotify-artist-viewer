//
//  SAItem.m
//  spotify-artist-viewer
//
//  Created by Anbita Siregar on 6/12/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SAItem.h"

@implementation SAItem

+ (SAItem *) itemOfType:(NSString *)type name:(NSString *)name bio:(NSString *)bio image:(NSArray *)image uri:(NSString *)number {
    SAItem *item = [[self alloc] init];
    item.type = type; //artist, album, song
    item.name = name;
    item.bio = bio;
    item.image = image;
    item.uri = number;
    return item;
}

@end
