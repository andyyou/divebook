//
//  DBKMainViewController.m
//  Divebook
//
//  Created by AndyYou on 2014/8/8.
//  Copyright (c) 2014年 AndyYou. All rights reserved.
//

#import "DBKMainViewController.h"
#import "DBKDiveLogViewCell.h"
#import <Parse/Parse.h>

@interface DBKMainViewController () <UITableViewDataSource, UITableViewDelegate>
{
    PFQuery *query;
    NSUInteger currentRowCount;
}
@property (nonatomic, strong) NSMutableArray *logs;

// IBOutlet
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DBKMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // load data from Parse.
    query = [PFQuery queryWithClassName:@"DiveLog"];
    [query whereKey:@"Owner" equalTo:[PFUser currentUser]];
    [query orderByDescending:@"createdAt"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _logs = [NSMutableArray arrayWithArray:[query findObjects]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark IBActions
- (IBAction)logoutButtonTouchHandler:(id)sender  {
    [PFUser logOut]; // Log out
    
    // Return to login page
    DBKMainViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController setViewControllers:@[loginViewController] animated:YES];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_logs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DiveLogCell";
    DBKDiveLogViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[DBKDiveLogViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    PFObject *log = _logs[indexPath.row];
    NSDate *diveAt = log[@"diveAt"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    NSString *monthString = [formatter stringFromDate:diveAt];
    cell.month.text = monthString;
    [formatter setDateFormat:@"dd"];
    NSString *dayString = [formatter stringFromDate:diveAt];
    cell.day.text = dayString;
    cell.placeName.text = log[@"placeName"];
    cell.wave.text = @"小浪";
    // 0:晴, 1:多雲, 2:下雨
    NSString *imagePath = [NSString stringWithFormat:@"weather_%@", log[@"weatherType"]];
    cell.weather.image = [UIImage imageNamed:imagePath];
    float alpha = 0.3 + [log[@"maxDepth"] intValue] / 100.0;
    cell.backgroundColor = [UIColor colorWithRed:80/255.0 green:176/255.0 blue:236/255.0 alpha:alpha];
    NSString *maxDepthString = [NSString stringWithFormat:@"最大深度 %@ 公尺", log[@"maxDepth"]];
    cell.maxDepth.text = maxDepthString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        PFObject *log = [_logs objectAtIndex:indexPath.row];
        [log deleteEventually];
        [_logs removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}
#pragma mark -
#pragma mark UITableViewDelegate

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
