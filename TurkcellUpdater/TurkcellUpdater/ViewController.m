//
//  ViewController.m
//  TurkcellUpdater
//
//  Created by Abdulbasıt Tanhan on 26.10.2014.
//  Copyright (c) 2014 Abdulbasıt Tanhan. All rights reserved.
//

#import "ViewController.h"
#import "UpdaterControllerDelegate.h"
#import "UpdaterController.h"


@interface ViewController () <UpdaterControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.urlTextField.text = @"https://dl.dropboxusercontent.com/u/26644626/update.json";
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

- (void) updateActionChosen
{
    
}

- (void) updateCheckCompleted{
    self.resultLabel.text = @"Update check completed";
}

@end
