/*******************************************************************************
 *
 *  Copyright (C) 2014 Turkcell
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *******************************************************************************/

//
//  UpdaterController.m
//  TurkcellUpdaterSampleApp
//
//  Created by Sonat Karakas on 1/14/13.
//  Copyright (c) 2013 Turkcell. All rights reserved.
//

#import "UpdaterController.h"
#import "UpdateCheck.h"
#import "UIAlertViewCustom.h"
#import "Message.h"

#define MESSAGEVIEW_WIDTH 290.0
#define MESSAGEVIEW_HEIGHT 200.0
#define LABEL_HEIGHT MESSAGEVIEW_HEIGHT / 10.0
#define LABEL_FONTSIZE 14.0

@interface UpdaterController() <UpdateCheckDelegate>

@end


@implementation UpdaterController{
    NSString* _targetWebSiteURL;
}

@synthesize updateServerURL,updaterControllerDelegate,postProperties,parentViewController;

+ (UpdaterController *) initWithUpdateURL:(NSString *)URL
                                 delegate:(id<UpdaterControllerDelegate>)delegate
                           postProperties:(BOOL)postProperties
                     parentViewController: (UIViewController *)vc
{
    
    static BOOL showVersionString = YES;
    
    if (showVersionString){
        showVersionString = FALSE;
    }
    
    UpdaterController *updaterController = [[UpdaterController alloc] init];
    
    updaterController.postProperties = postProperties;
    [updaterController setUpdateServerURL:URL];
    [updaterController setUpdaterControllerDelegate:delegate];
    [updaterController setParentViewController:vc];
    //[updaterController setFrame:CGRectMake(0, 0, 0, 0)];
    return updaterController;
}

+ (UpdaterController *) initWithUpdateURL:(NSString *)URL
                        preferredLanguage:(NSString *)preferredLanguage
                                 delegate:(id<UpdaterControllerDelegate>)delegate
                           postProperties:(BOOL)postProperties
                     parentViewController: (UIViewController *)vc
{
    UpdaterController *updaterController = [UpdaterController initWithUpdateURL:URL delegate:delegate postProperties:postProperties parentViewController:vc];
    [Message sharedInstance].preferredLanguage = preferredLanguage;
    return updaterController;
}

- (void) getUpdateInformation{
    
    UpdateCheck *updateCheck = [UpdateCheck initWithUpdateServerURL:[self updateServerURL] delegate:self postProperties:self.postProperties];
    [updateCheck update];
}

// --------------------------------------------------------------------------------------------------------------------------------------------------
//                                      UpdateCheckDelegate
// --------------------------------------------------------------------------------------------------------------------------------------------------
- (void) updateFound:(NSDictionary *)updateDictionary{
    
    
    NSLog(@"updateDictionary: %@", updateDictionary.description);
    
    UIAlertViewCustom * alert;
    
    if ([[updateDictionary objectForKey:@"forceExit"] isEqualToString:@"true"] || [[updateDictionary objectForKey:@"forceExit"] isEqualToString:@"1"]) {
        
        alert =   [UIAlertViewCustom
                   alertControllerWithTitle:[updateDictionary objectForKey:@"alertViewTitle"]
                   message:[updateDictionary objectForKey:@"message"]
                   preferredStyle:UIAlertControllerStyleAlert];
        
        if ([updateDictionary objectForKey:@"okButtonTitle"]) {
            UIAlertAction* install = [UIAlertAction
                                      actionWithTitle:[updateDictionary objectForKey:@"okButtonTitle"] ? [updateDictionary objectForKey:@"okButtonTitle"] : @""
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action)
                                      {
                                          NSString *forceUpdate = [(UIAlertViewCustom *)alert forceUpdate];
                                          NSString *targetPackageURL = [(UIAlertViewCustom *)alert targetPackageURL];
                                          
                                          if ([forceUpdate isEqualToString:@"true"] || [forceUpdate isEqualToString:@"1"]){
                                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:targetPackageURL]];
                                              [updaterControllerDelegate updateActionChosen];
                                          }
                                          else {
                                              [updaterControllerDelegate updateCheckCompleted];
                                          }
                                      }];
            
            [alert addAction:install];
        }
        
    } else {
        
        alert =   [UIAlertViewCustom
                   alertControllerWithTitle:[updateDictionary objectForKey:@"alertViewTitle"]
                   message:[updateDictionary objectForKey:@"message"]
                   preferredStyle:UIAlertControllerStyleAlert];
        
        if ([updateDictionary objectForKey:@"okButtonTitle"]) {
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:[updateDictionary objectForKey:@"okButtonTitle"]
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [updaterControllerDelegate updateActionChosen];
                                     NSString *targetPackageURL = [(UIAlertViewCustom *)alert targetPackageURL];
                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:targetPackageURL]];
                                 }];
            
            [alert addAction:ok];
        }
        
        
        if ([updateDictionary objectForKey:@"cancelButtonTitle"]) {
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:[updateDictionary objectForKey:@"cancelButtonTitle"] ? [updateDictionary objectForKey:@"cancelButtonTitle"] : @""
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [updaterControllerDelegate updateCheckCompleted];
                                     }];
            
            [alert addAction:cancel];
        }
    }
    
    [alert setTargetPackageURL:[updateDictionary objectForKey:@"targetPackageURL"]];
    [alert setForceUpdate:[updateDictionary objectForKey:@"forceUpdate"]];
    [alert setForceExit:[updateDictionary objectForKey:@"forceExit"]];
    [self.parentViewController presentViewController:alert animated:YES completion:nil];
}

- (void) updateCheckFailed:(NSError *)error
{
    NSLog(@"updateCheckFailed %@", [error description]);
    [updaterControllerDelegate updateCheckCompleted];
}

- (void) updateNotFound{
    NSLog(@"updateNotFound");
    [updaterControllerDelegate updateCheckCompleted];
}

- (UILabel*)createLabelWithFrame:(CGRect)frame title:(NSString*)title fontSize:(CGFloat)fontSize isBold:(BOOL)isBold alignment:(NSTextAlignment)alignment{
    UILabel *customLabel = [[UILabel alloc] initWithFrame:frame];
    [customLabel setBackgroundColor:[UIColor clearColor]];
    [customLabel setTextColor:[UIColor blackColor]];
    
    if (isBold)
        [customLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize]];
    else
        [customLabel setFont:[UIFont fontWithName:@"Helvetica" size:fontSize]];
    
    [customLabel setText:title];
    [customLabel setTextAlignment:alignment];
    return customLabel;
}

- (UITextView*)createTextViewWithFrame:(CGRect)frame title:(NSString*)title fontSize:(CGFloat)fontSize{
    UITextView *customTextView = [[UITextView alloc] initWithFrame:frame];
    [customTextView setTextColor:[UIColor blackColor]];
    [customTextView setBackgroundColor:[UIColor clearColor]];
    [customTextView setTextAlignment:NSTextAlignmentLeft];
    [customTextView setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    [customTextView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    //[customTextView setUserInteractionEnabled:NO];
    [customTextView setScrollEnabled:YES];
    [customTextView setShowsHorizontalScrollIndicator:YES];
    [customTextView setShowsVerticalScrollIndicator:YES];
    [customTextView setText:title];
    return customTextView;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------
//                                      MessageViewDelegate
// --------------------------------------------------------------------------------------------------------------------------------------------------
- (void) OKButtonClicked{
    
    //[[messageView view] removeFromSuperview];
    [updaterControllerDelegate updateCheckCompleted];
    
}

- (void) viewButtonClicked{
    
    //[[messageView view] removeFromSuperview];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_targetWebSiteURL]];
    [updaterControllerDelegate updateActionChosen];
    
}


@end
