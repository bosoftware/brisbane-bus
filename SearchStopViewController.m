//
//  SearchStopViewController.m
//  SydneyTransit
//
//  Created by Bo Wang on 20/06/2015.
//  Copyright (c) 2015 Bo Software. All rights reserved.
//

#import "SearchStopViewController.h"
#import "RealTimeTableViewController.h"

@interface SearchStopViewController ()

@end

@implementation SearchStopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.stopTableView.delegate=self;
    self.stopTableView.dataSource=self;
    [self.myIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    Stops * stop = [self.stopsArray objectAtIndex:self.stopTableView.indexPathForSelectedRow.row];
    RealTimeTableViewController * controller = [segue destinationViewController];
    controller.stop = stop;
}

- (IBAction)searchStop:(id)sender {
    
    if (self.stopNameTextField.text.length==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Sorry,Stop name cannot be empty"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [self.myIndicator startAnimating];
    [GtfsUtility getStopsByName:self.stopNameTextField.text indicator:self.myIndicator controller:self];
}


-(void) setResponseArray:(id)responseArray{
    [self.stopNameTextField resignFirstResponder];
    self.stopsArray = responseArray;
    [self.stopTableView reloadData];
    [self.myIndicator stopAnimating];
    if (self.stopsArray.count==0){
        [GtfsUtility ToastNotification:@"Sorry,Cannot find a stop name contains this keyword,Please try another word." andView:self andLoading:YES andIsBottom:YES];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.stopsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stopIdentifier"];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"stopIdentifier"];
        
    }
    Stops *stops = [_stopsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = stops.stop_name;
    // Configure the cell...
    cell.textLabel.numberOfLines = 0;
    return cell;
}
@end
