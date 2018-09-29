//
//  NYCSchools.m
//  ChaseTest
//
//  Created by Andrew Turner on 9/28/18.
//  Copyright © 2018 Andrew Turner. All rights reserved.
//

#import "NYCSchools.h"

@interface NYCSchools()
@property NSArray *schoolResponse;
@property NSArray *scoresResponse;
@property NSData *__block returnedData;
@end

@implementation NYCSchools

//Create JSON objects from both URLS then make the schools array when they are both complete
-(void) makeAPICalls{
    [self JSONRequestWithURL:kSchoolsURL andCompletion:^{
        self.schoolResponse = [self parseJSON:self.returnedData];
        [self JSONRequestWithURL:kScoresURL andCompletion:^{
            self.scoresResponse = [self parseJSON:self.returnedData];
            [self createSchools];
        }];
    }];
}

- (void)JSONRequestWithURL:(NSString*) address andCompletion:(void(^)(void))completion {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:address]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (data != nil) {
                                          self.returnedData = data;
                                      }
                                      else
                                      {
                                          NSLog(@"There was an error with the request.");
                                      }
                                      
                                      [completion invoke];
                                  }];
    [task resume];
    
}


- (NSArray*) parseJSON:(NSData *) jsonData {
    NSError *error = nil;
    NSArray *object = [NSJSONSerialization
                       JSONObjectWithData:jsonData
                       options:0
                       error:&error];
    if(error) {
        NSLog(@"There was an error serializing the JSON.");
    }
    
    return object;
    
}

//Map the two responses to a single array of school objects that holds the name, dbn, and SAT scores (if available)
-(void) createSchools{
    _schoolArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary* schoolDict in _schoolResponse){
        School *school = [[School alloc] init];
        school.name = [schoolDict objectForKey:kSchoolKey];
        school.dbn = [schoolDict objectForKey:kDBNKey];
        school.hasSATScores = NO;

        for (NSDictionary* scoresDict in _scoresResponse){
            if ([[scoresDict objectForKey:kDBNKey] isEqualToString:school.dbn]){
                school.hasSATScores = YES;
                school.mathScore = [scoresDict objectForKey:kMathKey];
                school.readingScore = [scoresDict objectForKey:kReadingKey];
                school.writingScore = [scoresDict objectForKey:kWritingKey];
            }
        }

        [_schoolArray addObject:school];
    }
    
    //Let the interested ViewController know the service calls have finished and array is created
    [[NSNotificationCenter defaultCenter] postNotificationName:kSchoolsCreatedNotification object:nil];
}

@end

@implementation School
@end
