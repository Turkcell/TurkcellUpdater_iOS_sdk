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
    
    //self.urlTextField.text = @"https://dl.dropboxusercontent.com/u/26644626/update.json";
    
    self.urlTextField.text = @"https://adeposw.turkcell.com.tr/v1/AUTH_996ea8f6f2714f66bde588cf19fca512/CONTAINER_MAIN/bbac822f-9208-4623-9f2d-047bf18be89a?temp_url_sig=618757660816491752b0ed8086b5a81fbfcd2715&amp;temp_url_expires=1450467338&amp;filename=update.json";
    
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
    
    UpdaterController *updaterController = [UpdaterController initWithUpdateURL:updateServerURL delegate:self postProperties:self.switchButton.on parentViewController:self];
    //UpdaterController *updaterController = [UpdaterController initWithUpdateURL:updateServerURL preferredLanguage:@"tr" delegate:self postProperties:self.switchButton.on];
    //[self.view addSubview:updaterController];
    [updaterController getUpdateInformation];
    
}

- (void) updateActionChosen
{
    
}

- (void) updateCheckCompleted{
    self.resultLabel.text = @"Update check completed";
}

@end
