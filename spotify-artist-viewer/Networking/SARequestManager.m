//
//  SARequestManager.m
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SARequestManager.h"
#import "SAItem.h"

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

- (NSMutableURLRequest *)getRequestOfURL: (NSString *) url query: (NSString *) query endString: (NSString *) endString {
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:url];
    [urlString appendString:query];
    [urlString appendString:endString];
    NSString *encodedURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *newURL = [NSURL URLWithString:encodedURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:newURL];
    [request setURL:newURL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return request;
    
}

//- (void)getArtistsWithQuery:(NSString *)query success:(void (^)(NSArray *artists))success failure:(void (^)(NSError *error))failure {
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection sendAsynchronousRequest:[[SARequestManager sharedManager] getRequestOfURL:@"https://api.spotify.com/v1/search?q=" query:query endString:@"&type=artist"] queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//                    {
//                        if ([data length] && !error) {
//                            NSError *jsonErr;
//                            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonErr];
//                            
//                            //NSArray *alt = json[@"artists"][@"items"];
//                            NSArray *jSonArtists = [json valueForKeyPath:@"artists.items"];
//                            
//                            NSMutableArray *artists = [[NSMutableArray alloc] init];
//                            
//                            for (NSObject *artist in jSonArtists) {
//                                NSString *artistName = [artist valueForKey:@"name"];
//                                NSArray *image = [artist valueForKey:@"images"];
//                                NSString *uri = [artist valueForKey:@"uri"];
//                                [artists addObject:[SAArtist artistOfName:artistName bio:@"bio" image:image uri:uri]];
//                            }
//                            
//                            NSLog(@"artists: %@", artists);
//                            success(artists);
//                        } else {
//                            failure(error);
//                        }
//                    }];
//}

- (void) getBioWithArtist:(NSString *)uri success:(void (^)(NSString *bio))success failure:(void (^)(NSError *error))failure {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:[[SARequestManager sharedManager] getRequestOfURL:@"http://developer.echonest.com/api/v4/artist/biographies?api_key=FILDTEOIK2HBORODV&id=" query:uri endString:@""] queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
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

- (void) getAllWithQuery:(NSString *)query success:(void (^)(NSDictionary *items))success failure:(void (^)(NSError *error))failure {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:[[SARequestManager sharedManager] getRequestOfURL:@"https://api.spotify.com/v1/search?q=" query:query endString:@"&type=track,album,artist"] queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] && !error) {
             NSError *jsonErr;
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonErr];
             
             //NSArray *alt = json[@"artists"][@"items"];
             NSArray *jSonArtists = [json valueForKeyPath:@"artists.items"];
             NSArray *jSonSongs = [json valueForKey:@"songs.items"];
             NSArray *jSonAlbums = [json valueForKey:@"albums.items"];
             
             NSMutableArray *artists = [[NSMutableArray alloc] init];
             artists = [[SARequestManager sharedManager] addItemsFromArray:jSonArtists toNewArray:artists];
             NSMutableArray *songs = [[NSMutableArray alloc] init];
             songs = [[SARequestManager sharedManager] addItemsFromArray:jSonSongs toNewArray:songs];
             NSMutableArray *albums = [[NSMutableArray alloc] init];
             albums = [[SARequestManager sharedManager] addItemsFromArray:jSonAlbums toNewArray:albums];
             
             NSLog(@"artists: %@", artists);
             NSLog(@"songs: %@", songs);
             NSLog(@"albums: %@", albums);
             success(@{@"Artists": artists, @"Songs": songs, @"Albums" : albums});
         } else {
             failure(error);
         }
     }];
}

-(NSMutableArray *) addItemsFromArray: (NSArray *) jsonArray toNewArray: (NSMutableArray *) newArray {
    for (NSObject *item in jsonArray) {
        NSString *name = [item valueForKey:@"name"];
        NSArray *image = [item valueForKey:@"images"];
        NSString *uri = [item valueForKey:@"uri"];
        [newArray addObject:[SAItem itemOfName:name bio:@"bio" image:image uri:uri]];
    }
    return newArray;
}


@end
