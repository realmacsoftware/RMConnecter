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
            for (NSXMLElement *locale in localeElements) {
                [locales addObject:[[RMAppLocale alloc] initWithXMLElement:locale]];
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
    
    NSXMLElement *locales = [NSXMLElement elementWithName:@"locales"];
    [version addChild:locales];
    
    for (RMAppLocale *locale in self.locales) {
        NSXMLElement *localeElement = [locale xmlRepresentation];
        [locales addChild:localeElement];
    }
    
    return version;
}

@end
