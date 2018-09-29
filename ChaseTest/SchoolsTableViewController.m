//
//  SchoolsTableViewController.m
//  ChaseTest
//
//  This ViewController displays a list of high schools in NYC. When a row is tapped, the SAT Scores are shown for that school
//
//  Created by Andrew Turner on 9/28/18.
//  Copyright © 2018 Andrew Turner. All rights reserved.

#import "SchoolsTableViewController.h"
#import "NYCSchools.h"

@interface SchoolsTableViewController ()
@property NYCSchools *schools;
@property NSIndexPath *selectedIndexPath;
@end

@implementation SchoolsTableViewController

-(void)loadView{
    [super loadView];
    
    //Notification sent from model when API call is complete
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadWithData) name:kSchoolsCreatedNotification object:nil];
    self.schools = [[NYCSchools alloc] init];
    [self.schools makeAPICalls];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//Reload table with API data
-(void) reloadWithData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//Before data is loaded, we show 1 cell with a loading message; after loading, display # of cells based on school count
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.schools.schoolArray){
        return [self.schools.schoolArray count];
    }
    else{
        return 1;
    }
}

//After selecting a row, reload the section with an animation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndexPath = indexPath;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    });
}

//Return larger height for the cell with SAT scores as it has more text
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath == self.selectedIndexPath){
        return 100;
    }
    else{
        return 44;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
    }
    
    cell.detailTextLabel.text = @"";
    
    //If data is loaded, populate it into cells
    if (self.schools.schoolArray.count > 0){
        School *school = self.schools.schoolArray[indexPath.row];
        
        cell.textLabel.text = school.name;
        //When tapped, show additional details
        if (indexPath == self.selectedIndexPath){
            NSString *scoreString;
            if (school.hasSATScores){
                scoreString = [NSString stringWithFormat:kScoreFormattedString,
                               school.mathScore,
                               school.readingScore,
                               school.writingScore];
                
                cell.detailTextLabel.numberOfLines = 2;
            }
            else {
                scoreString = kScoresNotFound;
            }
            cell.detailTextLabel.text = scoreString;
        }
    }
    else{ //Text to show before schools are loaded
        cell.textLabel.text = kLoading;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc] init];
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.text = kHeaderText;
    headerLabel.font = [UIFont boldSystemFontOfSize:20];
    [headerLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [header addSubview:headerLabel];
    
    [headerLabel.centerYAnchor constraintEqualToAnchor:header.centerYAnchor].active = YES;
    [headerLabel.leftAnchor constraintEqualToAnchor:header.leftAnchor constant:20].active = YES;
    [headerLabel.rightAnchor constraintEqualToAnchor:header.rightAnchor constant:20].active = YES;

    return header;
}

@end
