//
//  MainViewController.h
//  TurkcellUpdater
//
//  Created by Abdulbasıt Tanhan on 7/12/13.
//  Copyright (c) 2013 Turkcell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TurkcellUpdater/UpdaterControllerDelegate.h>

@interface MainViewController : UIViewController <UpdaterControllerDelegate>
{

}

@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end
