//
//  DocumentHandler.h
//  iOUTracker
//
//  Created by Slavko Krucaj on 8.10.2012..
//  Copyright (c) 2012. Infinum. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OnDocumentReady) (UIManagedDocument *document);

@interface DocumentHandler : NSObject

@property UIManagedDocument *document;

+ (DocumentHandler *)sharedDocumentHandler;
- (void)performWithDocument:(OnDocumentReady)onDocumentReady;
- (void)dropDatabase;

@end
