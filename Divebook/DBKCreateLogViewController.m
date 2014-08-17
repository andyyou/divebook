//
//  DBKCreateLogViewController.m
//  Divebook
//
//  Created by AndyYou on 2014/8/8.
//  Copyright (c) 2014年 AndyYou. All rights reserved.
//

#import "DBKCreateLogViewController.h"
#import <Parse/Parse.h>
#import <iAd/iAd.h>

@interface DBKCreateLogViewController () <UIScrollViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) UITextField *activeTextField;
@property (weak, nonatomic) UIDatePicker *datepicker;
@property (strong, nonatomic, readonly) NSDateFormatter *formatter;

// IBOutlet
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *diveDate;
@property (strong, nonatomic) IBOutlet UITextField *divePlaceName;
@property (strong, nonatomic) IBOutlet UISegmentedControl *diveType;
@property (strong, nonatomic) IBOutlet UISegmentedControl *diveWeatherType;
@property (strong, nonatomic) IBOutlet UISegmentedControl *diveWaveStatus;
@property (strong, nonatomic) IBOutlet UISegmentedControl *diveAircanType;
@property (strong, nonatomic) IBOutlet UITextField *diveAircanCapacity;
@property (strong, nonatomic) IBOutlet UITextField *diveStartTime;
@property (strong, nonatomic) IBOutlet UITextField *diveEndTime;
@property (strong, nonatomic) IBOutlet UITextField *diveVisibility;
@property (strong, nonatomic) IBOutlet UITextField *diveLandTemperature;
@property (strong, nonatomic) IBOutlet UITextField *diveWaterTemperature;
@property (strong, nonatomic) IBOutlet UITextField *diveMaxDepth;
@property (strong, nonatomic) IBOutlet UISwitch *diveIsShareFacebook;
@end

@implementation DBKCreateLogViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // fixed UIScrollView with navigation bar bug.
    self.automaticallyAdjustsScrollViewInsets = NO;
    // using UIScrollView with autolayout
    NSLayoutConstraint *leftEdgeAlign = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeading relatedBy:0 toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self.view addConstraint:leftEdgeAlign];
    NSLayoutConstraint *rightEdgeAlign = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailing relatedBy:0 toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    [self.view addConstraint:rightEdgeAlign];
    
    // setup default
    NSDate *date = [NSDate date];
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayString = [_formatter stringFromDate:date];
    [self.diveDate setText:todayString];
    [_formatter setDateFormat:@"hh:mm a"];
    NSString *startTimeString = [_formatter stringFromDate:date];
    [self.diveStartTime setText:startTimeString];
    NSString *endTimeString = [_formatter stringFromDate:[date dateByAddingTimeInterval:3600]];
    [self.diveEndTime setText:endTimeString];
    
    // setup tool bar for datepicker.
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPicker:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePicker:)];
    toolbar.items = @[cancelButton, space, doneButton];
    self.diveDate.inputAccessoryView = toolbar;
    self.diveEndTime.inputAccessoryView = toolbar;
    self.diveStartTime.inputAccessoryView = toolbar;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPicker:)];
    [self.contentView addGestureRecognizer:tapRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self deregisterFromKeyboardNotifications];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ([self.activeTextField tag] == 1) {
         [self.activeTextField resignFirstResponder];
    }
    return NO;
}

#pragma mark -
#pragma IBActions
- (IBAction)cancelCreateLog
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)saveDivelog:(id)sender
{
    PFObject *diveLog = [PFObject objectWithClassName:@"DiveLog"];
    [_formatter setDateFormat:@"yyyy-MM-dd"];
    diveLog[@"diveAt"] = [_formatter dateFromString:_diveDate.text];
    diveLog[@"placeName"] = _divePlaceName.text;
    // 0:岸潛 1:船潛
    diveLog[@"diveType"] = @([_diveType selectedSegmentIndex]);
    // 0:晴, 1:多雲, 2:下雨
    diveLog[@"weatherType"] = @([_diveWeatherType selectedSegmentIndex]);
    // 0:平靜, 1:小浪, 2:中浪, 3:大浪
    diveLog[@"waveStatus"] = @([_diveWaveStatus selectedSegmentIndex]);
    // 0:空氣 , 1:高氧32%,  2:高氧36% , 3:高氧40%
    diveLog[@"aircanType"] = @([_diveAircanType selectedSegmentIndex]);
    // 氧氣使用量
    diveLog[@"aircanCapacity"] = @([_diveAircanCapacity.text intValue]);
    NSString *startTimeString = [NSString stringWithFormat:@"%@ %@", _diveDate.text, _diveStartTime.text];
    [_formatter setDateFormat:@"yyyy-MM-dd hh:mm aa"];
    NSDate *startTime =  [_formatter dateFromString:startTimeString];
    diveLog[@"startDivingTime"] = startTime;
    NSString *endDivingTimeString = [NSString stringWithFormat:@"%@ %@", _diveDate.text, _diveEndTime.text];
    diveLog[@"endDivingTime"] = [_formatter dateFromString:endDivingTimeString];
    diveLog[@"maxDepth"] = @([_diveMaxDepth.text intValue]);
    diveLog[@"waterTemperature"] = @([_diveWaterTemperature.text intValue]);
    diveLog[@"landTemperature"] = @([_diveLandTemperature.text intValue]);
    diveLog[@"shareFacebook"] = [NSNumber numberWithBool:_diveIsShareFacebook.on];
    diveLog[@"Owner"] = [PFUser currentUser];

    [diveLog saveEventually];
    // share to facebook
    if (_diveIsShareFacebook.on) {
        NSString *diveTypeString;
        if ([_diveType selectedSegmentIndex] == 0) {
            diveTypeString = @"岸潛";
        } else if ([_diveType selectedSegmentIndex] == 1)
        {
            diveTypeString = @"船潛";
        }else
        {
            diveTypeString = @"潛水";
        }
        
        NSString *facebookMessage = [NSString stringWithFormat:@"%@ 在%@完成一次%@，最大深度 %@ 公尺，氧氣使用量%@ BAR - Divebook!", _diveDate.text, _divePlaceName.text, diveTypeString, _diveMaxDepth.text, _diveAircanCapacity.text];
        PFUser *user = [PFUser currentUser];
        if (![PFFacebookUtils isLinkedWithUser:user]) {
            [PFFacebookUtils linkUser:user permissions:@[@"public_profile", @"publish_actions"] block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [FBRequestConnection startForPostStatusUpdate:facebookMessage completionHandler:
                     ^(FBRequestConnection *connection, id result, NSError *error) {
                         if (!error) {
                             NSLog(@"result: %@", result);
                         } else {
                             NSLog(@"%@", error.description);
                         }
                     }];
                }
            }];
        } else
        {
            [FBRequestConnection startForPostStatusUpdate:facebookMessage completionHandler:
             ^(FBRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     NSLog(@"result: %@", result);
                 } else {
                     NSLog(@"%@", error.description);
                 }
             }];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    // TODO: add share link https://developers.facebook.com/docs/ios/share#link

}
#pragma mark -
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
    
    if (textField.tag == 1) {
        UIDatePicker *d = [[UIDatePicker alloc] init];
        d.datePickerMode = UIDatePickerModeDate;
        _datepicker = d;
        [self.activeTextField setInputView:_datepicker];
        self.activeTextField.inputView.backgroundColor = [UIColor whiteColor];
    } else if (textField.tag == 2)
    {
        UIDatePicker *d = [[UIDatePicker alloc] init];
        d.datePickerMode = UIDatePickerModeTime;
        _datepicker = d;
        [self.activeTextField setInputView:_datepicker];
        self.activeTextField.inputView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeTextField = nil;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark Helpers
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)deregisterFromKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardRect.size.height + 5 , 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect screenRect = self.view.frame;
    screenRect.size.height -= keyboardRect.size.height + 10;
    if (!CGRectContainsPoint(screenRect, self.activeTextField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeTextField.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)donePicker:(id)sender
{
    if (self.activeTextField.tag == 1) {
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    } else if (self.activeTextField.tag == 2) {
        [_formatter setDateFormat:@"hh:mm a"];
    }
   
    self.activeTextField.text = [_formatter stringFromDate:[_datepicker date]];
    if ([self.activeTextField isFirstResponder]) {
        [self.activeTextField resignFirstResponder];
    }
}

- (void)cancelPicker:(id)sender
{
    if ([self.activeTextField isFirstResponder]) {
        [self.activeTextField resignFirstResponder];
    }
}


#pragma mark -
#pragma iAd
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    
}


#pragma mark - 
#pragma mark Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
