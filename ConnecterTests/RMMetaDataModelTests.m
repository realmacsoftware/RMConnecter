//
//  ConnecterTests.m
//  ConnecterTests
//
//  Created by Nik Fletcher on 31/01/2014.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAppMetaData.h"
#import "RMAppVersion.h"
#import "RMAppLocale.h"
#import "RMAppScreenshot.h"
#import "RMAppScreenshotTypeValueTransformer.h"

#import <XCTest/XCTest.h>

@interface RMMetaDataModelTests : XCTestCase
@property (nonatomic, strong) RMAppMetaData *metaData;
@end

@implementation RMMetaDataModelTests

- (void)setUp
{
    [super setUp];
    
    // read xml file
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSData *xmlData = [NSData dataWithContentsOfFile:[testBundle pathForResource:@"testmetadata" ofType:@"xml"]];
    NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    self.metaData = [[RMAppMetaData alloc] initWithXMLElement:document.rootElement];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark tests

- (void)testAppMetaData
{
    RMAppMetaData *metaData = self.metaData;
    
    XCTAssertEqualObjects(metaData.metadataToken, @"someToken");
    XCTAssertEqualObjects(metaData.provider, @"someProvider");
    XCTAssertEqualObjects(metaData.teamID, @"someTeamID-01");
    XCTAssertEqualObjects(metaData.vendorID, @"test");
    XCTAssertEqualObjects(@(metaData.versions.count), @(1));
}

- (void)testAppVersion
{
    RMAppVersion *version = self.metaData.versions.firstObject;
    
    XCTAssertEqualObjects(version.versionString, @"2.0");
    XCTAssertEqualObjects(@(version.locales.count), @(2));
}

- (void)testAppLocale
{
    RMAppVersion *version = self.metaData.versions.firstObject;
    
    RMAppLocale *deLocale = version.locales.firstObject;
    XCTAssertEqualObjects(@(deLocale.shouldDeleteLocale), @(NO));
    XCTAssertEqualObjects(deLocale.localeName, @"de-DE");
    XCTAssertEqualObjects(deLocale.title, @"german name");
    XCTAssertEqualObjects(deLocale.description, @"Berlin, du kannst so schön hässlich sein. So dreckig und grau.");
    XCTAssertEqualObjects(deLocale.keywords, (@[@"berlin", @"munich"]));
    XCTAssertEqualObjects(deLocale.whatsNew, @"Die Eröffnung des Berliner Flughafens verzögert sich.");
    XCTAssertEqualObjects(deLocale.softwareURL, @"");
    XCTAssertEqualObjects(deLocale.supportURL, @"");
    XCTAssertEqualObjects(deLocale.privacyURL, @"");
    XCTAssertEqualObjects(@(deLocale.screenshots.count), @(3));
    
    RMAppLocale *enLocale = version.locales.lastObject;
    XCTAssertEqualObjects(@(enLocale.shouldDeleteLocale), @(NO));
    XCTAssertEqualObjects(enLocale.localeName, @"en-US");
    XCTAssertEqualObjects(enLocale.title, @"english title");
    XCTAssertEqualObjects(enLocale.description, @"Just some random text.");
    XCTAssertEqualObjects(enLocale.keywords, (@[@"nyc", @"sf"]));
    XCTAssertEqualObjects(enLocale.whatsNew, @"yep thats new!");
    XCTAssertEqualObjects(enLocale.softwareURL, @"www.google.com");
    XCTAssertEqualObjects(enLocale.supportURL, @"www.support.url");
    XCTAssertEqualObjects(enLocale.privacyURL, @"");
    XCTAssertEqualObjects(@(enLocale.screenshots.count), @(1));
}

- (void)testAppScreenshots
{
    RMAppVersion *version = self.metaData.versions.firstObject;
    NSArray *deScreenshots = [version.locales[0] screenshots];
    NSArray *enScreenshots = [version.locales[1] screenshots];
    
    RMAppScreenshot *deScreenshot = deScreenshots[0];
    XCTAssertEqualObjects(@(deScreenshot.displayTarget), @(RMAppScreenshotTypeiPhone35inch));
    XCTAssertEqualObjects(@(deScreenshot.position), @(1));
    XCTAssertEqualObjects(deScreenshot.filename, @"de-DE1704.png");
    XCTAssertEqualObjects(@(deScreenshot.size), @(172190));
    XCTAssertEqualObjects(deScreenshot.checksum, @"fb6b243baf13426a88f8382ab79283c2");
    XCTAssertEqualObjects(deScreenshot.checksumType, @"md5");
    
    deScreenshot = deScreenshots[1];
    XCTAssertEqualObjects(@(deScreenshot.displayTarget), @(RMAppScreenshotTypeiPad));
    XCTAssertEqualObjects(@(deScreenshot.position), @(1));
    XCTAssertEqualObjects(deScreenshot.filename, @"de-DE1721.png");
    XCTAssertEqualObjects(@(deScreenshot.size), @(655892));
    XCTAssertEqualObjects(deScreenshot.checksum, @"bcd2598924a7d0309d27dcdfa3cc2149");
    XCTAssertEqualObjects(deScreenshot.checksumType, @"md5");
    
    deScreenshot = deScreenshots[2];
    XCTAssertEqualObjects(@(deScreenshot.displayTarget), @(RMAppScreenshotTypeiPhone4inch));
    XCTAssertEqualObjects(@(deScreenshot.position), @(1));
    XCTAssertEqualObjects(deScreenshot.filename, @"de-DE1712.png");
    XCTAssertEqualObjects(@(deScreenshot.size), @(186242));
    XCTAssertEqualObjects(deScreenshot.checksum, @"7347462d3b543f33ccc6ba3c790602c3");
    XCTAssertEqualObjects(deScreenshot.checksumType, @"md5");
    
    RMAppScreenshot *enScreenshot = enScreenshots[0];
    XCTAssertEqualObjects(@(enScreenshot.displayTarget), @(RMAppScreenshotTypeiPhone35inch));
    XCTAssertEqualObjects(@(enScreenshot.position), @(1));
    XCTAssertEqualObjects(enScreenshot.filename, @"1.png");
    XCTAssertEqualObjects(@(enScreenshot.size), @(168337));
    XCTAssertEqualObjects(enScreenshot.checksum, @"957cce7ad063f79c8beffdc43d2e9e6b");
    XCTAssertEqualObjects(enScreenshot.checksumType, @"md5");
}

@end
