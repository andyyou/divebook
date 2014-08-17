//
//  DBKViewController.m
//  Divebook
//
//  Created by AndyYou on 2014/8/6.
//  Copyright (c) 2014年 AndyYou. All rights reserved.
//

#import "DBKLoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "DBKMainViewController.h"

typedef NS_ENUM(NSInteger, IDEVICE_HEIGHT_TYPE)
{
    IDEVICE_HEIGHT_TYPE_480,
    IDEVICE_HEIGHT_TYPE_568
};

#define IPHONE_SCREEN_TYPE ( [ [ UIScreen mainScreen ] bounds ].size.height == 480 ?  IDEVICE_HEIGHT_TYPE_480 : IDEVICE_HEIGHT_TYPE_568)

@interface DBKLoginViewController ()

@end

@implementation DBKLoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup background image
    UIGraphicsBeginImageContext(self.view.frame.size);
    switch (IPHONE_SCREEN_TYPE) {
        case 0:
             [[UIImage imageNamed:@"loginBackground"] drawInRect:self.view.bounds];
            break;
        case 1:
            [[UIImage imageNamed:@"loginBackground_R4"] drawInRect:self.view.bounds];
            break;
        default:
            [[UIImage imageNamed:@"loginBackground"] drawInRect:self.view.bounds];
            break;
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    // hide navigation bar
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (void)viewWillAppear:(BOOL)animated
{
    // check login status
    [super viewWillAppear:animated];
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        DBKMainViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        [self.navigationController setViewControllers:@[mainViewController] animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark IBActions
- (IBAction)loginButtonTouchHandler:(id)sender
{
    NSArray *permissions = @[@"public_profile", @"publish_actions"];
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            // NSLog(@"Uh oh. The user cancelled the Facebook login.");
            return;
        } else if (user.isNew) {
            DBKMainViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
            [self.navigationController setViewControllers:@[mainViewController] animated:YES];
            return;
        } else {
            DBKMainViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
            [self.navigationController setViewControllers:@[mainViewController] animated:YES];
            return;
        }
    }];
}

#pragma mark -
#pragma mark Navigation / Segue
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Segue"])
    {
       
    }
}
 */
@end
