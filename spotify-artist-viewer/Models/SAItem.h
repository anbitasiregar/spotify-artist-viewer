//
//  SAItem.h
//  spotify-artist-viewer
//
//  Created by Anbita Siregar on 6/12/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAItem : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *bio;
@property (nonatomic) NSArray *image;
@property (nonatomic) NSString *uri;

+ (SAItem *) itemOfName: (NSString *) name bio: (NSString *) bio image: (NSArray *) image uri: (NSString *) number;

@end
