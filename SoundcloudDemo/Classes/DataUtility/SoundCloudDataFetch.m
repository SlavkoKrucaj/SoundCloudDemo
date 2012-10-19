//
//  SoundCloudDataFetch.m
//  SoundcloudDemo
//
//  Created by Slavko Krucaj on 19.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "SoundCloudDataFetch.h"
#import "SCUI.h"
#import "DocumentHandler.h"
#import "JSONKit.h"
#import "SoundCloudItem+Create.h"

@implementation SoundCloudDataFetch

+ (void)fetchData {
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:@"https://api.soundcloud.com/users/25974038/favorites.json"]
             usingParameters:nil
                 withAccount:[SCSoundCloud account]
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                 // Handle the response
                 if (error) {
                     NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                 } else {
                     [[DocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
                         NSArray *array = [data objectFromJSONData];
                         
                         for (NSDictionary *dictionary in array) {
                             [SoundCloudItem createItemWithDictionary:dictionary inContext:document.managedObjectContext];
                         }
                         
                         [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
                     }];
                 }
             }];

}

@end
