//
//  MainViewController.m
//  TurkcellUpdater
//
//  Created by Abdulbasıt Tanhan on 7/12/13.
//  Copyright (c) 2013 Sonat Karakas. All rights reserved.
//

#import "MainViewController.h"
#import <TurkcellUpdater/UpdaterController.h>

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end

@implementation MainViewController

@synthesize resultLabel = _resultLabel;
@synthesize urlTextField = _urlTextField;
@synthesize switchButton = _switchButton;

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
    
    self.urlTextField.text = @"http://localhost:8080/test2.json";
    self.switchButton.on = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)checkForUpdate:(id)sender {
    self.resultLabel.text = @"";
    
    NSString *updateServerURL = self.urlTextField.text;
    
    UpdaterController *updaterController = [UpdaterController initWithUpdateURL:updateServerURL delegate:self postProperties:self.switchButton.on];
    [self.view addSubview:updaterController];
    [updaterController getUpdateInformation];

}

- (void) exitApplication{
    DLog(@"exit app");
}

- (void) updateCheckCompleted{
    DLog(@"update check completed");
    self.resultLabel.text = @"Update check completed";
}

- (void)viewDidUnload {
    [self setUrlTextField:nil];
    [self setResultLabel:nil];
    [super viewDidUnload];
}
@end