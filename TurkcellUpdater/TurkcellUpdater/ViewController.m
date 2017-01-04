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
    
//    NSString *updateURL = @"https://dl.dropboxusercontent.com/u/26644626/update.json";
    NSString *updateURL = @"http://localhost/test.json";
    [[UpdaterController sharedInstance] checkUpdateURL:updateURL preferredLanguageForTitles:@"tr" parentViewController:self completion:^(UpdateAction updateAction, UpdateResult *updateResult) {
        if (updateAction == UpdateActionUpdateFound) {
            if (updateResult) {
                NSLog(@"%@", updateResult.message);
            }
        }
        else {
            if (!updateResult) {
                NSLog(@"NULL");
            }
        }
    }];
                                                
}

@end
