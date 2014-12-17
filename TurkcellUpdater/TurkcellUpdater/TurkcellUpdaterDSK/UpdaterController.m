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
#import "FLImageView.h"
#import "CustomIOS7AlertView.h"


#define MESSAGEVIEW_WIDTH 290.0
#define MESSAGEVIEW_HEIGHT 200.0
#define LABEL_HEIGHT MESSAGEVIEW_HEIGHT / 10.0
#define LABEL_FONTSIZE 14.0

@interface UpdaterController() <UpdateCheckDelegate,CustomIOS7AlertViewDelegate>

@end


@implementation UpdaterController{
    NSString* _targetWebSiteURL;
}

@synthesize updateServerURL,updaterControllerDelegate,postProperties;

+ (UpdaterController *) initWithUpdateURL:(NSString *)URL
                                 delegate:(id<UpdaterControllerDelegate>)delegate
                           postProperties:(BOOL)postProperties;
{
    
    static BOOL showVersionString = YES;
    
    if (showVersionString){
        showVersionString = FALSE;
    }
    
    UpdaterController *updaterController = [[UpdaterController alloc] init];
    
    updaterController.postProperties = postProperties;
    [updaterController setUpdateServerURL:URL];
    [updaterController setUpdaterControllerDelegate:delegate];
    [updaterController setFrame:CGRectMake(0, 0, 0, 0)];
    
    return updaterController;
}

- (void) getUpdateInformation{
    
    UpdateCheck *updateCheck = [UpdateCheck initWithUpdateServerURL:[self updateServerURL] delegate:self postProperties:self.postProperties];
    [updateCheck update];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// --------------------------------------------------------------------------------------------------------------------------------------------------
//                                      AlertViewDelegate
// --------------------------------------------------------------------------------------------------------------------------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *forceUpdate = [(UIAlertViewCustom *)alertView forceUpdate];
    NSString *targetPackageURL = [(UIAlertViewCustom *)alertView targetPackageURL];
    
    switch (buttonIndex) {
        case 0: //Cancel button
            if ([forceUpdate isEqualToString:@"true"] || [forceUpdate isEqualToString:@"1"]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:targetPackageURL]];
                [updaterControllerDelegate updateActionChosen];
            }
            else
                [updaterControllerDelegate updateCheckCompleted];
            break;
            
        case 1: //OK button
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:targetPackageURL]];
            [updaterControllerDelegate updateActionChosen];
            break;
            
    }
}

// --------------------------------------------------------------------------------------------------------------------------------------------------
//                                      UpdateCheckDelegate
// --------------------------------------------------------------------------------------------------------------------------------------------------
- (void) updateFound:(NSDictionary *)updateDictionary{
    
    UIAlertViewCustom *alertView;
    
    if ([[updateDictionary objectForKey:@"forceExit"] isEqualToString:@"true"] || [[updateDictionary objectForKey:@"forceExit"] isEqualToString:@"1"]) {
        
        alertView  = [[UIAlertViewCustom alloc] initWithTitle:[updateDictionary objectForKey:@"alertViewTitle"]
                                                      message:[updateDictionary objectForKey:@"message"]
                                                     delegate:self
                                            cancelButtonTitle:[updateDictionary objectForKey:@"cancelButtonTitle"]
                                            otherButtonTitles:nil];
        
    }else{
        
        alertView = [[UIAlertViewCustom alloc] initWithTitle:[updateDictionary objectForKey:@"alertViewTitle"]
                                                     message:[updateDictionary objectForKey:@"message"]
                                                    delegate:self
                                           cancelButtonTitle:[updateDictionary objectForKey:@"cancelButtonTitle"]
                                           otherButtonTitles:[updateDictionary objectForKey:@"okButtonTitle"], nil];
    }
    
    [alertView setTargetPackageURL:[updateDictionary objectForKey:@"targetPackageURL"]];
    [alertView setForceUpdate:[updateDictionary objectForKey:@"forceUpdate"]];
    [alertView setForceExit:[updateDictionary objectForKey:@"forceExit"]];
    [alertView show];
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

- (void) displayMessageFound:(NSDictionary *)messageDictionary{
    /*
     
     messageView = [MessageView initWithTitle:[messageDictionary objectForKey:@"title"]
     message:[messageDictionary objectForKey:@"message"]
     imageUrl:[messageDictionary objectForKey:@"imageUrl"]
     targetWebsiteUrl:[messageDictionary objectForKey:@"targetWebsiteUrl"]
     delegate:self];
     
     [messageView showOnView:[self superview]];
     
     */
    
    // Here we need to pass a full frame
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self createMessageViewWithDictionary:messageDictionary]];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:[Message getMessage:@"install_"], [Message getMessage:@"remind_me_later"], nil]];
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, NSInteger buttonIndex) {
        //NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, [alertView tag]);
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
    
    
}

- (UIView *)createMessageViewWithDictionary:(NSDictionary *)messageDictionary
{
    _targetWebSiteURL = [messageDictionary objectForKey:@"targetWebsiteUrl"];
    
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MESSAGEVIEW_WIDTH, MESSAGEVIEW_HEIGHT)];
    
    FLImageView *videoThumbImage = [[FLImageView alloc] initWithFrame:CGRectMake(demoView.frame.origin.x + demoView.frame.size.width / 20.0,
                                                                                 demoView.frame.origin.y + demoView.frame.size.height / 2.5,
                                                                                 demoView.frame.size.width / 3.5,
                                                                                 demoView.frame.size.width / 3.5)];
    videoThumbImage.showsLoadingActivity = YES;
    videoThumbImage.autoresizeEnabled = NO;
    [videoThumbImage loadImageAtURLString:[messageDictionary objectForKey:@"imageUrl"] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [demoView addSubview:videoThumbImage];
    
    [demoView addSubview:[self createLabelWithFrame:CGRectMake(demoView.frame.origin.x + 20, demoView.frame.origin.y + demoView.frame.size.height / 14.0, demoView.frame.size.width - 20, LABEL_HEIGHT)
                                              title:[messageDictionary objectForKey:@"title"]
                                           fontSize:LABEL_FONTSIZE + 2.0
                                             isBold:YES
                                          alignment:NSTextAlignmentCenter]];
    
    [demoView addSubview:[self createLabelWithFrame:CGRectMake(demoView.frame.origin.x + demoView.frame.size.width / 20.0, demoView.frame.origin.y + demoView.frame.size.height / 3.7, demoView.frame.size.width - 20, LABEL_HEIGHT)
                                              title:[messageDictionary objectForKey:@"whatIsNew"]
                                           fontSize:LABEL_FONTSIZE
                                             isBold:NO
                                          alignment:NSTextAlignmentLeft]];
    [demoView addSubview:[self createLabelWithFrame:CGRectMake(demoView.frame.origin.x + demoView.frame.size.width / 20.0, demoView.frame.size.height - demoView.frame.size.height / 7.0, demoView.frame.size.width - 20, LABEL_HEIGHT)
                                              title:[messageDictionary objectForKey:@"warnings"]
                                           fontSize:LABEL_FONTSIZE
                                             isBold:NO
                                          alignment:NSTextAlignmentLeft]];
    
    [demoView addSubview:[self createTextViewWithFrame:CGRectMake(demoView.frame.origin.x + demoView.frame.size.width / 3.0,
                                                                  demoView.frame.origin.y + demoView.frame.size.height / 2.5,
                                                                  demoView.frame.size.width / 1.5,
                                                                  demoView.frame.size.height / 2.5)
                                                 title:[messageDictionary objectForKey:@"message"]
                                              fontSize:14]];
    
    return demoView;
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    //NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", buttonIndex, [alertView tag]);
    
    if (buttonIndex == 0)
        [self viewButtonClicked];
    else
        [self OKButtonClicked];
    
    [alertView close];
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
    [customTextView setEditable:NO];
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
