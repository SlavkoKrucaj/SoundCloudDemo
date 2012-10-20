//
//  SoundCloudDataFetch.h
//  SoundcloudDemo
//
//  Created by Slavko Krucaj on 19.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundCloudDataFetch : NSObject

+ (SoundCloudDataFetch *)dataFetcher;

/*
    fetchets new Activities, after completion it calls [target selector];
*/
- (void)fetchNewActivities;
- (void)fetchNextPageActivitiesWithTarget:(id)target andSelector:(SEL)selector;

- (void)fetchFavorites;

@end
