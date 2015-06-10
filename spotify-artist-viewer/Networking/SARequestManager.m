//
//  SARequestManager.m
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SARequestManager.h"
#import "SAArtist.h"

@implementation SARequestManager

+ (instancetype)sharedManager {
    // creates token so only one instance
    static dispatch_once_t onceToken;
    
    // object to be returned
    static id shared = nil;
    
    //Executes a block object once and only once for the lifetime of an application
    dispatch_once(&onceToken, ^{
        shared = [SARequestManager new];
    });
    return shared;
}

- (void)getArtistsWithQuery:(NSString *)query
                    success:(void (^)(NSArray *artists))success
                    failure:(void (^)(NSError *error))failure {
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:@"https://api.spotify.com/v1/search?q="];
    [urlString appendString:query];
    [urlString appendString:@"&type=artist"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
                    {
                        if ([data length] && !error) {
                            NSError *jsonErr;
                            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonErr];
                            
                            //NSArray *alt = json[@"artists"][@"items"];
                            NSArray *jSonArtists = [json valueForKeyPath:@"artists.items"];
                            
                            NSMutableArray *artists = [[NSMutableArray alloc] init];
                            
                            for (NSObject *artist in jSonArtists) {
                                NSString *artistName = [artist valueForKey:@"name"];
                                NSString *imageURL = @"url";
                                NSString *bio = @"bio";
                                
                                [artists addObject:[SAArtist artistOfName:artistName bio:bio url:imageURL]];
                            }
                            
                            NSLog(@"artists: %@", artists);
                            success(artists);
                        } else {
                            failure(error);
                        }
                    }];
}

@end
