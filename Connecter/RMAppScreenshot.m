//
//  RMAppScreenshot.m
//  Connecter
//
//  Created by Markus on 19.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAppScreenshot.h"

NSString *const RMAppScreenshotTypeValueTransformerName = @"RMAppScreenshotTypeValueTransformerName";

@interface RMAppScreenshotTypeValueTransformer : NSValueTransformer
@end

@implementation RMAppScreenshot

+ (void)initialize;
{
    [super initialize];
    [NSValueTransformer setValueTransformer:[[RMAppScreenshotTypeValueTransformer alloc] init]
                                    forName:RMAppScreenshotTypeValueTransformerName];
}

- (id)initWithXMLElement:(NSXMLElement *)xmlElement
{
    self = [super init];
    if (self) {
        if ([[xmlElement name] isEqualToString:@"software_screenshot"]) {
            NSString *typeString = [[xmlElement attributeForName:@"display_target"] objectValue];
            self.displayTarget = [[[self valueTransformer] transformedValue:typeString] integerValue];
            
            self.position = [[[xmlElement attributeForName:@"position"] objectValue] integerValue];
            self.filename = [[[xmlElement elementsForName:@"file_name"] firstObject] objectValue];
            self.size = [[[[xmlElement elementsForName:@"size"] firstObject] objectValue] longValue];
            
            NSXMLElement *checksumElement = [[xmlElement elementsForName:@"checksum"] firstObject];
            self.checksum = [checksumElement objectValue];
            self.checksumType = [[checksumElement attributeForName:@"type"] objectValue];
        }
    }
    return self;
}

- (NSXMLElement *)xmlRepresentation;
{
    NSXMLElement *screenshot = [NSXMLElement elementWithName:@"software_screenshot"];
    
    NSString *typeString = [[self valueTransformer] reverseTransformedValue:@(self.displayTarget)];
    [screenshot setAttributesWithDictionary:@{@"display_target":typeString,
                                              @"position":@(self.position)}];
    
    [screenshot addChild:[NSXMLElement elementWithName:@"file_name"
                                           stringValue:self.filename]];
    [screenshot addChild:[NSXMLElement elementWithName:@"size"
                                           stringValue:[NSString stringWithFormat: @"%ld", self.size]]];
    
    NSXMLElement *checksum = [NSXMLElement elementWithName:@"checksum"
                                               stringValue:self.checksum];
    [checksum setAttributesWithDictionary:@{@"type":self.checksumType}];
    [screenshot addChild:checksum];
    
    return screenshot;
}

- (RMAppScreenshotTypeValueTransformer*)valueTransformer;
{
    return (RMAppScreenshotTypeValueTransformer*)[NSValueTransformer valueTransformerForName:RMAppScreenshotTypeValueTransformerName];
}

@end



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



