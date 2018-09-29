//
//  SchoolsTableViewController.h
//  ChaseTest
//
//  Created by Andrew Turner on 9/28/18.
//  Copyright © 2018 Andrew Turner. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kCellIdentifier = @"UITableViewCell";
static NSString *const kScoreFormattedString = @"Avg SAT Scores:\nMath: %@\tReading: %@\tWriting: %@";
static NSString *const kScoresNotFound = @"No scores found for this school!";
static NSString *const kLoading = @"Loading..";
static NSString *const kHeaderText = @"NYC Schools - tap to see SAT scores";

@interface SchoolsTableViewController : UITableViewController

@end
