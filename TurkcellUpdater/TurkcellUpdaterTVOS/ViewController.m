//
//  ViewController.m
//  TurkcellUpdaterTVOS
//
//  Created by Abdulbasıt Tanhan on 18.12.2015.
//  Copyright © 2015 Abdulbasıt Tanhan. All rights reserved.
//

#import "ViewController.h"
#import "UpdaterController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)checkForUpdate:(id)sender {
    
    //NSString *updateURL = @"http://127.0.0.1/update.json";
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
