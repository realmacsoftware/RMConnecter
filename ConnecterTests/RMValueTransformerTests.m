//
//  RMValueTransformerTests.m
//  Connecter
//
//  Created by Markus Emrich on 22.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAppScreenshotTypeValueTransformer.h"
#import "RMByteValueTransformer.h"

#import <XCTest/XCTest.h>

@interface RMValueTransformerTests : XCTestCase

@end


@implementation RMValueTransformerTests

- (void)testAppScreenshotTypeValueTransformer;
{
    RMAppScreenshotTypeValueTransformer *transformer = [[RMAppScreenshotTypeValueTransformer alloc] init];
    
    XCTAssertEqualObjects([transformer transformedValue:@"iOS-3.5-in"], @(RMAppScreenshotTypeiPhone35inch));
    XCTAssertEqualObjects([transformer transformedValue:@"iOS-4-in"], @(RMAppScreenshotTypeiPhone4inch));
    XCTAssertEqualObjects([transformer transformedValue:@"iOS-iPad"], @(RMAppScreenshotTypeiPad));
    XCTAssertEqualObjects([transformer transformedValue:@"Mac"], @(RMAppScreenshotTypeMac));
    
    XCTAssertEqualObjects([transformer transformedValue:@(0)], nil);
    XCTAssertEqualObjects([transformer transformedValue:@(1)], nil);
    XCTAssertEqualObjects([transformer transformedValue:nil], nil);
    XCTAssertEqualObjects([transformer transformedValue:@"text"], nil);
}

- (void)testAppScreenshotTypeValueTransformerReverse;
{
    RMAppScreenshotTypeValueTransformer *transformer = [[RMAppScreenshotTypeValueTransformer alloc] init];
    
    XCTAssertEqualObjects([transformer reverseTransformedValue:@(RMAppScreenshotTypeiPhone35inch)], @"iOS-3.5-in");
    XCTAssertEqualObjects([transformer reverseTransformedValue:@(RMAppScreenshotTypeiPhone4inch)], @"iOS-4-in");
    XCTAssertEqualObjects([transformer reverseTransformedValue:@(RMAppScreenshotTypeiPad)], @"iOS-iPad");
    XCTAssertEqualObjects([transformer reverseTransformedValue:@(RMAppScreenshotTypeMac)], @"Mac");
    
    XCTAssertEqualObjects([transformer reverseTransformedValue:@(123)], nil);
    XCTAssertEqualObjects([transformer reverseTransformedValue:@(-1)], nil);
    XCTAssertEqualObjects([transformer reverseTransformedValue:nil], nil);
    XCTAssertEqualObjects([transformer reverseTransformedValue:@"text"], nil);
}

@end
