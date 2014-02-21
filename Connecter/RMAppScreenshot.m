//
//  RMAppScreenshot.m
//  Connecter
//
//  Created by Markus on 19.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "NSData+MD5.h"

#import "RMAppScreenshot.h"

NSString *const RMAppScreenshotChecksumTypeStringMD5 = @"md5";

@implementation RMAppScreenshot

+ (void)initialize;
{
    [super initialize];
    [NSValueTransformer setValueTransformer:[[RMAppScreenshotTypeValueTransformer alloc] init]
                                    forName:RMAppScreenshotTypeValueTransformerName];
}

#pragma mark RMXMLObject

- (id)initWithXMLElement:(NSXMLElement *)xmlElement
{
    self = [super init];
    if (self) {
        if ([[xmlElement name] isEqualToString:@"software_screenshot"]) {
            NSString *typeString = [[xmlElement attributeForName:@"display_target"] objectValue];
            self.displayTarget = [[[self displayTargetValueTransformer] transformedValue:typeString] integerValue];
            
            self.position = [[[xmlElement attributeForName:@"position"] objectValue] integerValue];
            self.filename = [[[xmlElement elementsForName:@"file_name"] firstObject] objectValue];
            self.size = [[[[xmlElement elementsForName:@"size"] firstObject] objectValue] integerValue];
            
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
    
    NSString *typeString = [[self displayTargetValueTransformer] reverseTransformedValue:@(self.displayTarget)];
    [screenshot setAttributesWithDictionary:@{@"display_target":typeString,
                                              @"position":[NSString stringWithFormat:@"%d", self.position]}];
    
    [screenshot addChild:[NSXMLElement elementWithName:@"file_name"
                                           stringValue:self.filename]];
    [screenshot addChild:[NSXMLElement elementWithName:@"size"
                                           stringValue:[NSString stringWithFormat: @"%d", self.size]]];
    
    NSXMLElement *checksum = [NSXMLElement elementWithName:@"checksum"
                                               stringValue:self.checksum];
    [checksum setAttributesWithDictionary:@{@"type":self.checksumType}];
    [screenshot addChild:checksum];
    
    return screenshot;
}

#pragma mark RMAppScreenshot

- (void)setImageData:(NSData *)imageData;
{
    if (imageData == _imageData) return;
    _imageData = imageData;
    
    self.checksum = [imageData md5CheckSum];
    self.checksumType = RMAppScreenshotChecksumTypeStringMD5;
    self.size = [imageData length];
}

- (NSString *)description;
{
    return [NSString stringWithFormat: @"%@ - %@, %d., %@, %d",
            [super description],
            [[self displayTargetValueTransformer] reverseTransformedValue:@(self.displayTarget)],
            self.position, self.filename, self.size];
}

- (RMAppScreenshotTypeValueTransformer*)displayTargetValueTransformer;
{
    return (RMAppScreenshotTypeValueTransformer*)[NSValueTransformer valueTransformerForName:RMAppScreenshotTypeValueTransformerName];
}

@end

