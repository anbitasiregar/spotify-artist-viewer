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
    NSString *encodedURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:encodedURL];
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
                                NSArray *image = [artist valueForKey:@"images"];
                                NSString *uri = [artist valueForKey:@"uri"];
                                /*
                                [[SARequestManager sharedManager] getBio:uri success:^(NSString *bio) {
                                    NSString *newBio = bio;
                                } failure:^(NSError *error) {
                                    failure(error);
                                }];
                                 */
                                [artists addObject:[SAArtist artistOfName:artistName bio:@"bio" image:image uri:uri]];
                            }
                            
                            NSLog(@"artists: %@", artists);
                            success(artists);
                        } else {
                            failure(error);
                        }
                    }];
}

- (void) getBioWithArtist:(NSString *)uri success:(void (^)(NSString *bio))success failure:(void (^)(NSError *error))failure {
    
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:@"http://developer.echonest.com/api/v4/artist/biographies?api_key=FILDTEOIK2HBORODV&id="];
    [urlString appendString:uri];
    NSString *encodedURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:encodedURL];
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
             NSArray *jSonBios = [json valueForKeyPath:@"response.biographies"];
             
             NSString *newBio = @"No bio found!";
             for (NSDictionary *bio in jSonBios) {
                 if (![bio valueForKey:@"truncated"]) {
                     newBio = [bio valueForKey:@"text"];
                     NSLog(@"newBio: %@", newBio);
                     break;
                 }
             }
             success(newBio);
         } else {
             failure(error);
         }
     }];

    
    
}


@end
