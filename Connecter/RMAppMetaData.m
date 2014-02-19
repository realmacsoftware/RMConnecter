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
        self.metadataToken = [[[xmlElement elementsForName:@"metadata_token"] firstObject] objectValue];
        self.provider = [[[xmlElement elementsForName:@"provider"] firstObject] objectValue];
        self.teamID = [[[xmlElement elementsForName:@"team_id"] firstObject] objectValue];
        self.vendorID = [[[software elementsForName:@"vendor_id"] firstObject] objectValue];
    }
    return self;
}

- (NSXMLElement *)xmlRepresentation;
{
    NSXMLElement *root = [NSXMLElement elementWithName:@"package"];
    [root setAttributesWithDictionary:@{@"xmlns":@"http://apple.com/itunes/importer",
                                        @"version":@"software5.1"}];
    
    [root addChild:[NSXMLElement elementWithName:@"metadata_token"
                                     stringValue:self.metadataToken]];
    [root addChild:[NSXMLElement elementWithName:@"provider"
                                     stringValue:self.provider]];
    [root addChild:[NSXMLElement elementWithName:@"team_id"
                                     stringValue:self.teamID]];
    NSXMLElement *vendor = [NSXMLElement elementWithName:@"vendor_id"
                                             stringValue:self.vendorID];
    
    NSXMLElement *software = [NSXMLElement elementWithName:@"software"];
    NSXMLElement *metadata = [NSXMLElement elementWithName:@"software_metadata"];
    NSXMLElement *versions = [NSXMLElement elementWithName:@"versions"];
    [root addChild:software];
    [software addChild:vendor];
    [software addChild:metadata];
    [metadata addChild:versions];
    
    for (RMAppVersion *version in self.versions) {
        NSXMLElement *versionElement = [version xmlRepresentation];
        [versions addChild:versionElement];
    }
    
    return root;
}

- (NSXMLDocument *)xmlDocumentRepresentation;
{
    NSXMLDocument *document = [[NSXMLDocument alloc] initWithRootElement:self.xmlRepresentation];
    [document setCharacterEncoding:@"UTF-8"];
    [document setVersion:@"1.0"];
    [document setStandalone:YES];
    [document setMIMEType:@"text/xml"];
    return document;
}

@end
