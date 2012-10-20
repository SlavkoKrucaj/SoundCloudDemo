//
//  SoundCloudItem+Create.m
//  SoundcloudDemo
//
//  Created by Slavko Krucaj on 19.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "SoundCloudItem+Create.h"
#import "AFNetworking.h"
#import "UIImage+Crop.h"

static const NSString *SoundCloudTitle = @"title";
static const NSString *SoundCloudArtwork = @"artwork_url";
static const NSString *SoundCloudWaveform = @"waveform_url";
static const NSString *SoundCloudDate = @"created_at";
static const NSString *SoundCloudId = @"id";
static const NSString *SoundCloudFavorite = @"user_favorite";
static const NSString *SoundCloudWeb = @"permalink_url";

@implementation SoundCloudItem (Create)

+ (void)insertItem:(NSDictionary *)data inContext:(NSManagedObjectContext *)context withImage:(UIImage *)image {

    SoundCloudItem *item = (SoundCloudItem *)[NSEntityDescription insertNewObjectForEntityForName:@"SoundCloudItem"
                                                                           inManagedObjectContext:context];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy/MM/dd HH:mm:ss ZZZ";

    //simple hack for aligning top of name with date and image
    item.name =         [[data objectForKey:SoundCloudTitle] stringByAppendingString:@"\n "];
    
    item.artworkUrl =   ([[data objectForKey:SoundCloudArtwork] class] != [NSNull class])? [data objectForKey:SoundCloudArtwork]:@"";
    item.waveformUrl =  [data objectForKey:SoundCloudWaveform];
    item.uniqueId =     [data objectForKey:SoundCloudId];
    item.date =         [df dateFromString:[data objectForKey:SoundCloudDate]];
    item.waveformImage = image;
    item.favorite =     [data objectForKey:SoundCloudFavorite];
    item.webUrl =       [data objectForKey:SoundCloudWeb];

}

+ (void)createItemWithDictionary:(NSDictionary *)data inContext:(NSManagedObjectContext *)context {
    
    NSString *waveformUrl = [data objectForKey:SoundCloudWaveform];
    NSString *itemId = [data objectForKey:SoundCloudId];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SoundCloudItem"];
    request.predicate = [NSPredicate predicateWithFormat:@"uniqueId = %@", itemId];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    //if there is this item in context return it don't create new one
    if ([matches count] == 1) {
        return;
    }
    
    //if it doesn't contain waveform create it without image
    if (!waveformUrl || [waveformUrl isEqualToString:@""]) {
        [SoundCloudItem insertItem:data inContext:context withImage:nil];
    }

    // download the waveform image
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:waveformUrl]];
    
    AFImageRequestOperation *operation = [AFImageRequestOperation
                                          imageRequestOperationWithRequest:imgRequest
                                          imageProcessingBlock:^UIImage *(UIImage *image) {
                                              return [image crop:CGRectMake(0, 0, image.size.width, image.size.height/2)];
                                          }
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              
                                              [SoundCloudItem insertItem:data inContext:context withImage:image];
                                          
                                          }
                                          failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                              
                                              [SoundCloudItem insertItem:data inContext:context withImage:nil];
                                              
                                          }];
    [operation start];
    
}


@end
