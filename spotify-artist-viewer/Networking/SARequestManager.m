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

- (NSMutableURLRequest *) getRequestOfURL:(NSString *)url query:(NSString *)query endString:(NSString *)endString {
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

- (void) getBioWithArtist:(NSString *)uri success:(void (^)(NSString *bio))success failure:(void (^)(NSError *error))failure {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:[[SARequestManager sharedManager] getRequestOfURL:@"http://developer.echonest.com/api/v4/artist/biographies?api_key=QOTTQXCRUR2RFYVQQ&id=spotify:artist:" query:uri endString:@""] queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] && !error) {
             NSError *jsonErr;
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonErr];
             
             //NSArray *alt = json[@"artists"][@"items"];
             NSArray *jsonBios = [json valueForKeyPath:@"response.biographies"];
             //NSLog(@"all bios: %@", jsonBios);
             
             NSString *newBio = @"No bio found!";
             for (NSDictionary *bio in jsonBios) {
                 if (![bio valueForKey:@"truncated"]) {
                     newBio = [bio valueForKey:@"text"];
                     //NSLog(@"newBio: %@", newBio);
                     break;
                 }
             }
             success(newBio);
         } else {
             failure(error);
         }
     }];
}

- (void) getSonglistWithAlbum:(NSString *)uri success:(void (^)(NSString *bio))success failure:(void (^)(NSError *error))failure {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:[[SARequestManager sharedManager] getRequestOfURL:@"https://api.spotify.com/v1/albums/" query:uri endString:@"/tracks"] queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] && !error) {
             NSError *jsonErr;
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonErr];
             
             //NSArray *alt = json[@"artists"][@"items"];
             NSArray *jsonSongs = [json valueForKey:@"items"];
             NSMutableString *bio = [[NSMutableString alloc] init];
             
             for (NSDictionary *song in jsonSongs) {
                 [bio appendString:[NSString stringWithFormat:@"%@: ",[song valueForKey:@"track_number"]]];
                 [bio appendFormat:@"%@\n", [song valueForKey:@"name"]];
                 
             }

             success(bio);
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
             NSArray *jsonArtists = [json valueForKeyPath:@"artists.items"];
             NSArray *jsonSongs = [json valueForKeyPath:@"tracks.items"];
             NSArray *jsonAlbums = [json valueForKeyPath:@"albums.items"];
             
             NSMutableArray *artists = [[NSMutableArray alloc] init];
             artists = [[SARequestManager sharedManager] addItemsOfType:@"artist" fromArray:jsonArtists toNewArray:artists];
             NSMutableArray *songs = [[NSMutableArray alloc] init];
             songs = [[SARequestManager sharedManager] addItemsOfType:@"song" fromArray:jsonSongs toNewArray:songs];
             NSMutableArray *albums = [[NSMutableArray alloc] init];
             albums = [[SARequestManager sharedManager] addItemsOfType:@"album" fromArray:jsonAlbums toNewArray:albums];
             
             //NSLog(@"artists: %@", artists);
             //NSLog(@"songs: %@", songs);
             //NSLog(@"albums: %@", albums);
             success(@{@"Artists": artists, @"Songs": songs, @"Albums" : albums});
         } else {
             failure(error);
         }
     }];
}

- (NSMutableArray *) addItemsOfType:(NSString *)type fromArray:(NSArray *)jsonArray toNewArray:(NSMutableArray *)newArray {
    if ([type isEqualToString:@"song"]) {
        newArray = [[SARequestManager sharedManager] addSongFromArray:jsonArray toNewArray:newArray];
    } else {
        for (NSObject *item in jsonArray) {
            NSString *name = [item valueForKey:@"name"];
            NSArray *image = [item valueForKey:@"images"];
            NSString *uri = [item valueForKey:@"id"];
            [newArray addObject:[SAItem itemOfType:type name:name bio:@"bio" image:image uri:uri]];
        }
    }
    return newArray;
}

- (NSMutableArray *) addSongFromArray:(NSArray *)jsonArray toNewArray:(NSMutableArray *)newArray {
    for (NSObject *song in jsonArray) {
        NSString *name = [song valueForKey:@"name"];
        NSArray *image = [song valueForKeyPath:@"album.images"];
        NSString *uri = [song valueForKey:@"uri"];
        NSArray *artistArray = [song valueForKeyPath:@"artists"];
        NSString *bio = artistArray[0][@"name"];
        [newArray addObject:[SAItem itemOfType:@"song" name:name bio:bio image:image uri:uri]];
    }
    return newArray;
}


@end
