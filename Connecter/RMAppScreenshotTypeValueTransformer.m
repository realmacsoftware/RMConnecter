//
//  RMAppScreenshotTypeValueTransformer.m
//  Connecter
//
//  Created by Markus on 21.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAppScreenshotTypeValueTransformer.h"


NSString *const RMAppScreenshotTypeValueTransformerName = @"RMAppScreenshotTypeValueTransformerName";

@implementation RMAppScreenshotTypeValueTransformer

- (id)transformedValue:(id)value;
{
    if ([value isKindOfClass:[NSString class]]) {
        NSString *string = (NSString*)value;
        if ([string isEqualToString:@"iOS-3.5-in"]) {
            return @(RMAppScreenshotTypeiPhone35inch);
        } else if ([string isEqualToString:@"iOS-4-in"]) {
            return @(RMAppScreenshotTypeiPhone4inch);
        } else if ([string isEqualToString:@"iOS-iPad"]) {
            return @(RMAppScreenshotTypeiPad);
        } else if ([string isEqualToString:@"Mac"]) {
            return @(RMAppScreenshotTypeMac);
        }
    }
    return nil;
}

- (id)reverseTransformedValue:(id)value;
{
    if ([value isKindOfClass:[NSNumber class]]) {
        RMAppScreenshotType type = [value integerValue];
        if (type == RMAppScreenshotTypeiPhone35inch) {
            return @"iOS-3.5-in";
        } else if (type == RMAppScreenshotTypeiPhone4inch) {
            return @"iOS-4-in";
        } else if (type == RMAppScreenshotTypeiPad) {
            return @"iOS-iPad";
        } else if (type == RMAppScreenshotTypeMac) {
            return @"Mac";
        }
    }
    return nil;
}

+ (BOOL)allowsReverseTransformation;
{
    return YES;
}

+ (Class)transformedValueClass;
{
    return [NSNumber class];
}

@end
