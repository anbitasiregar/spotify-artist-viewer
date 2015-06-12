//
//  SARequestManager.h
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SARequestManager : NSObject

+ (instancetype)sharedManager;

- (void)getArtistsWithQuery:(NSString *)query
                    success:(void (^)(NSArray *artists))success
                    failure:(void (^)(NSError *error))failure;

- (void) getBioWithArtist:(NSString *)uri
                  success:(void (^)(NSString *bio))success
                  failure:(void (^)(NSError *error))error;

- (void) getAllWithQuery:(NSString *)query
                 success:(void (^)(NSDictionary *items))success
                 failure:(void (^)(NSError *error))failure;

@end
