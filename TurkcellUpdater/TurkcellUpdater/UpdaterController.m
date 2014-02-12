
//
//  UpdaterController.m
//  TurkcellUpdaterSampleApp
//
//  Created by Sonat Karakas on 1/14/13.
//  Copyright (c) 2013 Sonat Karakas. All rights reserved.
//

#import "UpdaterController.h"
#import "UpdateCheck.h"
#import "UIAlertViewCustom.h"
#import "Message.h"
#import "version.h"

@implementation UpdaterController

@synthesize updateServerURL,updaterControllerDelegate, messageView,postProperties;

+ (UpdaterController *) initWithUpdateURL:(NSString *)URL
                                 delegate:(id<UpdaterControllerDelegate>)delegate
                           postProperties:(BOOL)postProperties;
{
    
    static BOOL showVersionString = YES;
    
    if (showVersionString){
        showVersionString = FALSE;
        NSLog(@"Updtae SDK v%@ build date %@", PROJECT_VERSION, [NSDate date]);
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
                [updaterControllerDelegate exitApplication];
            }
            else
                [updaterControllerDelegate updateCheckCompleted];
            break;

        case 1: //OK button
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:targetPackageURL]];
            [updaterControllerDelegate exitApplication];
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

- (void) updateCheckFailed:(NSError *)error{
    
    DLog(@"TurkcellUpdater:");
    DLog(@"%@",[error localizedDescription]);
    [updaterControllerDelegate updateCheckCompleted];
    
}

- (void) updateNotFound{
    
    [updaterControllerDelegate updateCheckCompleted];
}

- (void) displayMessageFound:(NSDictionary *)messageDictionary{
        
    messageView = [MessageView initWithTitle:[messageDictionary objectForKey:@"title"]
                                     message:[messageDictionary objectForKey:@"message"]
                                    imageUrl:[messageDictionary objectForKey:@"imageUrl"]
                            targetWebsiteUrl:[messageDictionary objectForKey:@"targetWebsiteUrl"]
                                    delegate:self];
    
    [messageView showOnView:[self superview]];
    
}

// --------------------------------------------------------------------------------------------------------------------------------------------------
//                                      MessageViewDelegate
// --------------------------------------------------------------------------------------------------------------------------------------------------
- (void) OKButtonClicked{
    
    [[messageView view] removeFromSuperview];
    [updaterControllerDelegate updateCheckCompleted];
    
}

- (void) viewButtonClicked{
    
    [[messageView view] removeFromSuperview];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[messageView targetWebsiteUrl]]];
    [updaterControllerDelegate exitApplication];

}

@end
