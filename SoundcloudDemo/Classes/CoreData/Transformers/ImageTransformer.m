//
//  ImageTransformer.m
//  SoundcloudDemo
//
//  Created by Slavko Krucaj on 19.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "ImageTransformer.h"

@implementation ImageTransformer

+ (Class)transformedValueClass {
    return [UIImage class];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}

- (id)transformedValue:(id)value {
    return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value {
    return [UIImage imageWithData:value];
}

@end
