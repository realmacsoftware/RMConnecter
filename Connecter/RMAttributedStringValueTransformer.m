//
//  RMAttributedStringValueTransformer.m
//  Connecter
//
//  Created by Markus Emrich on 22.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAttributedStringValueTransformer.h"

@implementation RMAttributedStringValueTransformer

+ (Class)transformedValueClass;
{
    return [NSAttributedString class];
}

+ (BOOL)allowsReverseTransformation;
{
    return YES;
}

- (id)transformedValue:(id)value;
{
    if ([value isKindOfClass:[NSString class]]) {
        return [[NSAttributedString alloc] initWithString:value];
    }
    return nil;
}

- (id)reverseTransformedValue:(id)value;
{
    if ([value isKindOfClass:[NSAttributedString class]]) {
        return [value string];
    }
    return nil;
}

@end
