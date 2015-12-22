//
//  ViewController.m
//  TurkcellUpdater
//
//  Created by Abdulbasıt Tanhan on 26.10.2014.
//  Copyright (c) 2014 Abdulbasıt Tanhan. All rights reserved.
//

#import "ViewController.h"
#import "UpdaterController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)checkForUpdate:(id)sender {
    
    NSString *updateURL = @"https://dl.dropboxusercontent.com/u/26644626/update.json";
    [[UpdaterController sharedInstance] checkUpdateURL:updateURL preferredLanguageForTitles:@"tr" parentViewController:self completionHandler:^(UpdateAction updateAction) {
        if (updateAction == UpdateActionUpdateCheckCompleted) {
            NSLog(@"Update check completed");
        } else if (updateAction == UpdateActionUpdateChosen) {
            NSLog(@"Update action chosen");
        }
    }];
                                                
}

@end
