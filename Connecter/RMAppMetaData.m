//
//  AppMetaData.m
//  Connecter
//
//  Created by Markus on 18.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAppVersion.h"

#import "RMAppMetaData.h"

@implementation RMAppMetaData

- (id)initWithXMLElement:(NSXMLElement*)xmlElement;
{
    self = [super init];
    if (self) {
        NSXMLElement *software = [[xmlElement elementsForName:@"software"] firstObject];
        NSXMLElement *metaData = [[software elementsForName:@"software_metadata"] firstObject];
        NSXMLElement *versions = [[metaData elementsForName:@"versions"] firstObject];
        
        NSArray *versionElements = [versions children];
        NSMutableArray *versionsArray = [NSMutableArray array];
        for (NSXMLElement *version in versionElements) {
            [versionsArray addObject:[[RMAppVersion alloc] initWithXMLElement:version]];
        }
        self.versions = versionsArray;
    }
    return self;
}

- (NSXMLElement *)xmlRepresentation;
{
    NSXMLElement *root = [NSXMLElement elementWithName:@"package"];
    [root setAttributesWithDictionary:@{@"xmlns":@"http://apple.com/itunes/importer",
                                        @"version":@"software5.1"}];
    
    NSXMLElement *software = [NSXMLElement elementWithName:@"software"];
    NSXMLElement *metadata = [NSXMLElement elementWithName:@"software_metadata"];
    NSXMLElement *versions = [NSXMLElement elementWithName:@"versions"];
    [root addChild:software];
    [software addChild:metadata];
    [metadata addChild:versions];
    
    for (RMAppVersion *version in self.versions) {
        NSXMLElement *versionElement = [version xmlRepresentation];
        [versions addChild:versionElement];
    }
    
    return root;
}

@end
