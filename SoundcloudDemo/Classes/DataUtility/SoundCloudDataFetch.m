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

#define ACTIVITIES_API @"https://api.soundcloud.com/me/activities.json?limit=20"
#define FAVORITES_API @"https://api.soundcloud.com/me/favorites.json"

static SoundCloudDataFetch *_dataFetcher;

static NSString *ActivitiesNextHref   = @"next_href";
static NSString *ActivitiesCollection = @"collection";
static NSString *ActivitiesTrack      = @"origin";
static NSString *ActivitiesTrackType  = @"track";
static NSString *ActivitiesType       = @"type";

@interface SoundCloudDataFetch()
@property (nonatomic, strong) NSString *activitesNextUrl;
@property (nonatomic, assign) BOOL fetchingNewPage;
@end

@implementation SoundCloudDataFetch

+ (SoundCloudDataFetch *)dataFetcher
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _dataFetcher = [[self alloc] init];
        _dataFetcher.fetchingNewPage = YES;
    });
    
    return _dataFetcher;
}

- (void)saveNextPageUrl:(NSString *)url {
    if (!url || [url isEqualToString:@""]) self.activitesNextUrl = nil;
    else {
        NSArray *stringComponents = [url componentsSeparatedByString:@"?"];
        self.activitesNextUrl = [NSString stringWithFormat:@"%@%@?%@", [stringComponents objectAtIndex:0],
                                 @".json", [stringComponents objectAtIndex:1]];
    }
}

- (void)fetchActivitiesWithTarget:(id)target andSelector:(SEL)selector forNextPage:(BOOL)nextPage{
    
    NSString *apiUrl = nextPage? self.activitesNextUrl:ACTIVITIES_API;
    
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:apiUrl]
             usingParameters:nil
                 withAccount:[SCSoundCloud account]
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                 // Handle the response
                 if (error) {
                     NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                 } else {
                     NSDictionary *dict = [data objectFromJSONData];
                     
                     [[DocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
                         
                         NSArray *collection = [dict objectForKey:ActivitiesCollection];
                         for (NSDictionary *activity in collection) {
                             if ([[activity objectForKey:ActivitiesType] isEqualToString:ActivitiesTrackType]) {
                                 NSDictionary *track = [activity objectForKey:ActivitiesTrack];
                                 [SoundCloudItem createItemWithDictionary:track inContext:document.managedObjectContext];
                             }
                         }
                         
                         [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
                         [target performSelector:selector];
                         self.fetchingNewPage = NO;
                         [self saveNextPageUrl:[dict objectForKey:ActivitiesNextHref]];
                     }];
                     
                 }
             }];
}

- (void)fetchNewActivities {
    self.fetchingNewPage = YES;
    [self fetchActivitiesWithTarget:nil andSelector:nil forNextPage:NO];
}

- (void)fetchNextPageActivitiesWithTarget:(id)target andSelector:(SEL)selector {
    if (self.fetchingNewPage || !self.activitesNextUrl) {
        [target performSelector:selector];
        return;
    }
    self.fetchingNewPage = YES;
    [self fetchActivitiesWithTarget:target andSelector:selector forNextPage:YES];
}

- (void)fetchFavorites {
    self.fetchingNewPage = YES;
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:FAVORITES_API]
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
