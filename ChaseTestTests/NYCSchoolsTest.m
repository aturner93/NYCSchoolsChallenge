//
//  NYCSchoolsTest.m
//  ChaseTestTests
//
//  Created by Andrew Turner on 9/29/18.
//  Copyright © 2018 Andrew Turner. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NYCSchools.h"

//Expose private methods and properties for testing
@interface NYCSchools(Test)
- (NSArray*) parseJSON:(NSData *) jsonData;
- (void)JSONRequestWithURL:(NSString*) address andCompletion:(void(^)(void))completion;
-(void) createSchools;
@property NSArray *schoolResponse;
@property NSArray *scoresResponse;
@property NSData *__block returnedData;
@end

@interface NYCSchoolsTest : XCTestCase
@end

@implementation NYCSchoolsTest
NYCSchools *schools;

- (void)setUp {
    [super setUp];
    schools = [[NYCSchools alloc] init];
}

//Utility methods for loading mock data and using NYCSchools JSON parsing and school creation
- (void) loadSchoolsResponse {
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"schoolsJSON" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    schools.schoolResponse = [schools parseJSON:data];
}

- (void) loadScoresResponse {
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"scoresJSON" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    schools.scoresResponse = [schools parseJSON:data];
}

- (void) createSchools {
    [self loadSchoolsResponse];
    [self loadScoresResponse];
    [schools createSchools];
}

//Tests that JSON data is nil when URL is bad
- (void) testJSONRequestFailure{
    XCTestExpectation *expectation = [self expectationWithDescription:@"JSON doesn't load"];
    [schools JSONRequestWithURL: @"sdfds" andCompletion:^{
        if (schools.returnedData == nil){
            [expectation fulfill];
        }
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
            XCTAssertNil(error, @"JSON data loaded successfully");
    }];
}

//Tests that JSON data is created when proper URL is used
- (void) testJSONRequestSuccess{
    XCTestExpectation *expectation = [self expectationWithDescription:@"JSON loads"];
    [schools JSONRequestWithURL: @"https://data.cityofnewyork.us/resource/97mf-9njv.json" andCompletion:^{
        if (schools.returnedData != nil){
            [expectation fulfill];
        }
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
            XCTAssertNil(error, @"JSON data wasn't loaded");
    }];
}

//Uses mock data to check parsing method
- (void)testParseSchoolData {
    [self loadSchoolsResponse];
    XCTAssertEqual(schools.schoolResponse.count, 440);

}

- (void)testParseScoresData {
    [self loadScoresResponse];
    XCTAssertEqual(schools.scoresResponse.count, 478);
}

- (void) testSchoolCreation {
    [self createSchools];
    XCTAssert(schools.schoolArray.count > 0);
}

- (void) testSchoolObjectWithScores {
    [self createSchools];
    School *school = schools.schoolArray[1];
    XCTAssertNotNil(school.name);
    XCTAssertNotNil(school.dbn);
    XCTAssert(school.hasSATScores == YES);
    XCTAssertNotNil(school.mathScore);
    XCTAssertNotNil(school.readingScore);
    XCTAssertNotNil(school.writingScore);
}

- (void) testSchoolObjectWithoutScores {
    [self createSchools];
    School *school = schools.schoolArray[0];
    XCTAssertNotNil(school.name);
    XCTAssertNotNil(school.dbn);
    XCTAssert(school.hasSATScores == NO);
    XCTAssertNil(school.mathScore);
    XCTAssertNil(school.readingScore);
    XCTAssertNil(school.writingScore);
}

@end

