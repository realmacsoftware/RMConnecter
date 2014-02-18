//
//  RMAppLocale.m
//  Connecter
//
//  Created by Markus on 18.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAppLocale.h"

@implementation RMAppLocale

- (id)initWithXMLElement:(NSXMLElement *)xmlElement;
{
    self = [super init];
    if (self) {
        self.shouldDeleteLocale = NO;
        self.localeName = [[xmlElement attributeForName:@"name"] stringValue];
        
        self.title = [[[xmlElement elementsForName:@"title"] firstObject] stringValue];
        self.description = [[[xmlElement elementsForName:@"description"] firstObject] stringValue];
        self.whatsNew = [[[xmlElement elementsForName:@"version_whats_new"] firstObject] stringValue];
        self.softwareURL = [[[xmlElement elementsForName:@"software_url"] firstObject] stringValue];
        self.supportURL = [[[xmlElement elementsForName:@"support_url"] firstObject] stringValue];
        self.privacyURL = [[[xmlElement elementsForName:@"privacy_url"] firstObject] stringValue];
        
        // keywords
        NSMutableString *keywordsString = [NSMutableString string];
        NSXMLElement *keywords = [[xmlElement elementsForName:@"keywords"] firstObject];
        for (NSXMLElement *element in [keywords children]) {
            [keywordsString appendFormat:@"%@,", [element stringValue]];
        }
        self.keywords = keywordsString;
        
        // @TODO: screenshots
    }
    return self;
}

- (NSXMLElement *)xmlRepresentation;
{
    NSXMLElement *locale = [NSXMLElement elementWithName:@"locale"];
    
    if (self.shouldDeleteLocale) {
        [locale setAttributesWithDictionary:@{@"name":self.localeName,
                                              @"remove":@"true"}];
    } else {
        [locale setAttributesWithDictionary:@{@"name":self.localeName}];
        
        [locale addChild:[NSXMLElement elementWithName:@"title"
                                           stringValue:self.title]];
        
        [locale addChild:[NSXMLElement elementWithName:@"description"
                                           stringValue:self.description]];
        
        [locale addChild:[NSXMLElement elementWithName:@"version_whats_new"
                                           stringValue:self.whatsNew]];
        
        [locale addChild:[NSXMLElement elementWithName:@"software_url"
                                           stringValue:self.softwareURL]];
        
        [locale addChild:[NSXMLElement elementWithName:@"support_url"
                                           stringValue:self.supportURL]];
        
        [locale addChild:[NSXMLElement elementWithName:@"privacy_url"
                                           stringValue:self.privacyURL]];
        
        // keywords
        NSXMLElement *keywords = [NSXMLElement elementWithName:@"keywords"];
        NSArray *keywordStrings = [self.keywords componentsSeparatedByString:@","];
        for (NSString *keywordString in keywordStrings) {
            [keywords addChild:[NSXMLElement elementWithName:@"keyword"
                                                 stringValue:keywordString]];
        }
        [locale addChild:keywords];
        
        // @TODO: screenshots
    }
    
    return locale;
}

@end

