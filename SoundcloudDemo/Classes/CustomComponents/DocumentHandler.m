//
//  DocumentHandler.m
//  iOUTracker
//
//  Created by Slavko Krucaj on 8.10.2012..
//  Copyright (c) 2012. Infinum. All rights reserved.
//

#import "DocumentHandler.h"
#import <CoreData/CoreData.h>

@interface DocumentHandler ()
- (void)objectsDidChange:(NSNotification *)notification;
- (void)contextDidSave:(NSNotification *)notification;
@end;

@implementation DocumentHandler

@synthesize document = _document;

static DocumentHandler *_sharedInstance;

+ (DocumentHandler *)sharedDocumentHandler
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Soundcloud.db"];
        
        self.document = [[UIManagedDocument alloc] initWithFileURL:url];
        
        // Set our document up for automatic migrations
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        self.document.persistentStoreOptions = options;
    }
    return self;
}

- (void)performWithDocument:(OnDocumentReady)onDocumentReady
{
    void (^OnDocumentDidLoad)(BOOL) = ^(BOOL success) {
        onDocumentReady(self.document);
    };
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.document.fileURL path]]) {
        [self.document saveToURL:self.document.fileURL
                forSaveOperation:UIDocumentSaveForCreating
               completionHandler:OnDocumentDidLoad];
    } else if (self.document.documentState == UIDocumentStateClosed) {
        [self.document openWithCompletionHandler:OnDocumentDidLoad];
    } else if (self.document.documentState == UIDocumentStateNormal) {
        OnDocumentDidLoad(YES);
    }
}

- (void)dropDatabase {
    
    [self performWithDocument:^(UIManagedDocument *document) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SoundCloudItem"];
        NSArray *items = [document.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        
        for (NSManagedObject *managedObject in items) {
            [document.managedObjectContext deleteObject:managedObject];
        }
        
        [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
    }];
}

- (void)objectsDidChange:(NSNotification *)notification
{
#ifdef DEBUG
    NSLog(@"NSManagedObjects did change.");
#endif
}

- (void)contextDidSave:(NSNotification *)notification
{
#ifdef DEBUG
    NSLog(@"NSManagedContext did save.");
#endif
}

@end