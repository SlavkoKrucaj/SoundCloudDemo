//
//  SoundCloudItem+Create.h
//  SoundcloudDemo
//
//  Created by Slavko Krucaj on 19.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "SoundCloudItem.h"

@interface SoundCloudItem (Create)

+ (void)createItemWithDictionary:(NSDictionary *)data inContext:(NSManagedObjectContext *)context;

@end
