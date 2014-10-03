//
//  RMAppScreenshotTypeValueTransformer.m
//  Connecter
//
//  Created by Markus on 21.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAppScreenshotTypeValueTransformer.h"


NSString *const RMAppScreenshotTypeValueTransformerName = @"RMAppScreenshotTypeValueTransformerName";

NSString *const RMAppScreenshotTypeStringIphone35inch = @"iOS-3.5-in";
NSString *const RMAppScreenshotTypeStringIphone4inch = @"iOS-4-in";
NSString *const RMAppScreenshotTypeStringIphone47inch = @"iOS-4.7-in";
NSString *const RMAppScreenshotTypeStringIphone55inch = @"iOS-5.5-in";
NSString *const RMAppScreenshotTypeStringIpad = @"iOS-iPad";
NSString *const RMAppScreenshotTypeStringMac = @"Mac";

@implementation RMAppScreenshotTypeValueTransformer

- (id)transformedValue:(id)value;
{
    if ([value isKindOfClass:[NSString class]]) {
        NSString *string = (NSString*)value;
        if ([string isEqualToString:RMAppScreenshotTypeStringIphone35inch]) {
            return @(RMAppScreenshotTypeiPhone35inch);
        } else if ([string isEqualToString:RMAppScreenshotTypeStringIphone4inch]) {
            return @(RMAppScreenshotTypeiPhone4inch);
        } else if ([string isEqualToString:RMAppScreenshotTypeStringIphone47inch]) {
            return @(RMAppScreenshotTypeiPhone47inch);
        } else if ([string isEqualToString:RMAppScreenshotTypeStringIphone55inch]) {
            return @(RMAppScreenshotTypeiPhone55inch);
        } else if ([string isEqualToString:RMAppScreenshotTypeStringIpad]) {
            return @(RMAppScreenshotTypeiPad);
        } else if ([string isEqualToString:RMAppScreenshotTypeStringMac]) {
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
            return RMAppScreenshotTypeStringIphone35inch;
        } else if (type == RMAppScreenshotTypeiPhone4inch) {
            return RMAppScreenshotTypeStringIphone4inch;
        } else if (type == RMAppScreenshotTypeiPhone47inch) {
            return RMAppScreenshotTypeStringIphone47inch;
        } else if (type == RMAppScreenshotTypeiPhone55inch) {
            return RMAppScreenshotTypeStringIphone55inch;         
        } else if (type == RMAppScreenshotTypeiPad) {
            return RMAppScreenshotTypeStringIpad;
        } else if (type == RMAppScreenshotTypeMac) {
            return RMAppScreenshotTypeStringMac;
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
