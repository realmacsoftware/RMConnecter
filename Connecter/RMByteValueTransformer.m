//
//  RMByteValueTransformer.m
//  Connecter
//
//  Created by Markus on 21.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMByteValueTransformer.h"

@implementation RMByteValueTransformer

- (id)transformedValue:(id)value;
{
    if ([value isKindOfClass:[NSNumber class]]) {
        CGFloat newValue = [value floatValue];
        if (newValue < 0) newValue = 0;
        
        if (newValue > 1000000) {
            newValue /= 1000000;
            return [NSString stringWithFormat: @"%.1f MB", newValue];
        }
        
        if (newValue > 1000) {
            newValue /= 1000;
            return [NSString stringWithFormat: @"%.0f kb", newValue];
        }
        
        return [NSString stringWithFormat: @"%.0f b", newValue];
    }
    return nil;
}

+ (Class)transformedValueClass;
{
    return [NSString class];
}

@end
