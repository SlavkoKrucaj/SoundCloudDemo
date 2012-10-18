//
//  SoundCloudItem.h
//  SoundcloudDemo
//
//  Created by Slavko Krucaj on 19.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SoundCloudItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * artworkUrl;
@property (nonatomic, retain) id waveformImage;
@property (nonatomic, retain) NSNumber * favorite;

@end
