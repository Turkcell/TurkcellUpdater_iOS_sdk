//
//  ViewController.m
//  TurkcellUpdaterTVOS
//
//  Created by Abdulbasıt Tanhan on 18.12.2015.
//  Copyright © 2015 Abdulbasıt Tanhan. All rights reserved.
//

#import "ViewController.h"
#import "UpdaterController.h"

@interface ViewController () <UpdaterControllerDelegate>

@end

@implementation ViewController

- (IBAction)checkForUpdate:(id)sender {
    
    //NSString *updateURL = @"http://127.0.0.1/update.json";
    NSString *updateURL = @"https://dl.dropboxusercontent.com/u/26644626/update.json";
    
    UpdaterController *updaterController = [UpdaterController initWithUpdateURL:updateURL delegate:self postProperties:NO parentViewController:self];
    [updaterController getUpdateInformation];
}

- (void) updateActionChosen
{
    NSLog(@"Update action chosen");
}

- (void) updateCheckCompleted{
    NSLog(@"Update check completed");
}

@end
