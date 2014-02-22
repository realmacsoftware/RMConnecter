//
//  AppMetaData.m
//  Connecter
//
//  Created by Markus on 18.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAppVersion.h"

#import "RMAppMetaData.h"

NSString *const RMAppMetaDataXMLNS = @"http://apple.com/itunes/importer";
NSString *const RMAppMetaDataVersion = @"software5.1";

@interface RMAppMetaData ()
@property (nonatomic, strong) NSXMLElement *readOnlyNode;
@property (nonatomic, strong) NSArray *unhandledMetaDataXMLNodes;
@end

@implementation RMAppMetaData

- (id)init
{
    self = [super init];
    if (self) {
        self.versions = @[[[RMAppVersion alloc] init]];
    }
    return self;
}

- (id)initWithXMLElement:(NSXMLElement*)xmlElement;
{
    self = [super init];
    if (self) {
        if ([[xmlElement name] isEqualToString:@"package"]) {
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
            
            self.readOnlyNode = [[software elementsForName:@"read_only_info"] firstObject];
            self.unhandledMetaDataXMLNodes = [metaData.children filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name != 'versions'"]];
            
        }
    }
    return self;
}

- (NSXMLElement *)xmlRepresentation;
{
    NSXMLElement *root = [NSXMLElement elementWithName:@"package"];
    [root setAttributesWithDictionary:@{@"xmlns":RMAppMetaDataXMLNS,
                                        @"version":RMAppMetaDataVersion}];
    
    [root addChild:[NSXMLElement elementWithName:@"metadata_token" stringValue:self.metadataToken]];
    [root addChild:[NSXMLElement elementWithName:@"provider" stringValue:self.provider]];
    [root addChild:[NSXMLElement elementWithName:@"team_id" stringValue:self.teamID]];
    
    NSXMLElement *software = [NSXMLElement elementWithName:@"software"];
    NSXMLElement *vendor = [NSXMLElement elementWithName:@"vendor_id" stringValue:self.vendorID];
    NSXMLElement *metadata = [NSXMLElement elementWithName:@"software_metadata"];
    [root addChild:software];
    [software addChild:vendor];
    [software addChild:self.readOnlyNode];
    [software addChild:metadata];
    
    // versions
    NSXMLElement *versions = [NSXMLElement elementWithName:@"versions"];
    for (RMAppVersion *version in self.versions) {
        NSXMLElement *versionElement = [version xmlRepresentation];
        [versions addChild:versionElement];
    }
    [metadata addChild:versions];

    // save unhandled data
    for (NSXMLElement *element in self.unhandledMetaDataXMLNodes) {
        [metadata addChild:element];
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
