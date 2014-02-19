//
//  RMAppVersion.m
//  Connecter
//
//  Created by Markus on 18.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAppLocale.h"

#import "RMAppVersion.h"

@implementation RMAppVersion

- (id)initWithXMLElement:(NSXMLElement*)xmlElement;
{
    self = [super init];
    if (self) {
        if ([[xmlElement name] isEqualToString:@"version"]) {
            self.versionString = [[xmlElement attributeForName:@"string"] stringValue];
            
            NSMutableArray *locales = [NSMutableArray array];
            NSXMLElement *localesElement = [[xmlElement elementsForName:@"locales"] firstObject];
            NSArray *localeElements = [localesElement children];
            for (NSXMLElement *localeElement in localeElements) {
                [locales addObject:[[RMAppLocale alloc] initWithXMLElement:localeElement]];
            }
            self.locales = locales;
        }
    }
    return self;
}

- (NSXMLElement *)xmlRepresentation;
{
    NSXMLElement *version = [NSXMLElement elementWithName:@"version"];
    [version setAttributesWithDictionary:@{@"string":self.versionString}];
    
    // locales
    NSXMLElement *locales = [NSXMLElement elementWithName:@"locales"];
    for (RMAppLocale *locale in self.locales) {
        NSXMLElement *localeElement = [locale xmlRepresentation];
        [locales addChild:localeElement];
    }
    [version addChild:locales];
    
    return version;
}

@end
