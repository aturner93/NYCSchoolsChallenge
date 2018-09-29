//
//  NYCSchools.h
//  ChaseTest
//
//  Created by Andrew Turner on 9/28/18.
//  Copyright © 2018 Andrew Turner. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString *const kSchoolsURL = @"https://data.cityofnewyork.us/resource/97mf-9njv.json";
static NSString *const kScoresURL = @"https://data.cityofnewyork.us/resource/734v-jeq5.json";
static NSString *const kSchoolKey = @"school_name";
static NSString *const kDBNKey = @"dbn";
static NSString *const kMathKey = @"sat_math_avg_score";
static NSString *const kReadingKey = @"sat_critical_reading_avg_score";
static NSString *const kWritingKey = @"sat_writing_avg_score";
static NSString *const kSchoolsCreatedNotification = @"SchoolsCreatedNotification";


@interface NYCSchools : NSObject
@property NSMutableArray *schoolArray;
-(void) makeAPICalls;
@end

//Represents a school and holds our desired values
@interface School : NSObject
@property NSString *name;
@property NSString *dbn;
@property BOOL hasSATScores;
@property NSString *mathScore;
@property NSString *readingScore;
@property NSString *writingScore;
@end

