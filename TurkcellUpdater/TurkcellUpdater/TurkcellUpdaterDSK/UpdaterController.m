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
#import "Controller.h"

#define MESSAGEVIEW_WIDTH 290.0
#define MESSAGEVIEW_HEIGHT 200.0
#define LABEL_HEIGHT MESSAGEVIEW_HEIGHT / 10.0
#define LABEL_FONTSIZE 14.0

@implementation UpdateResult @end

@interface UpdaterController() <UpdateCheckDelegate>

@end


@implementation UpdaterController{
    NSString* _targetWebSiteURL;
}

@synthesize updateServerURL,parentViewController;

+(instancetype)sharedInstance
{
    static id shared;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)checkUpdateURL:(NSString *)URL
preferredLanguageForTitles:(NSString *)preferredLanguage
  parentViewController: (UIViewController *)vc
     completionHandler:(void(^)(UpdateAction updateAction))completionBlock
{
    self.updateServerURL = URL;
    self.completionBlock = completionBlock;
    self.parentViewController = vc;
    [Message sharedInstance].preferredLanguage = preferredLanguage;
    [self getUpdateInformation];
}

- (void)checkUpdateURL:(NSString *)URL
preferredLanguageForTitles:(NSString *)preferredLanguage
  parentViewController: (UIViewController *)vc
            completion:(void(^)(UpdateResult *updateResult))completionBlock{
    self.updateServerURL = URL;
    self.completionBlock = nil;
    self.completion = completionBlock;
    self.parentViewController = vc;
    [Message sharedInstance].preferredLanguage = preferredLanguage;
    [self getUpdateInformation];
    
}

- (void) getUpdateInformation{
    
    UpdateCheck *updateCheck = [UpdateCheck initWithUpdateServerURL:self.updateServerURL delegate:self postProperties:false];
    [updateCheck update];
}

// --------------------------------------------------------------------------------------------------------------------------------------------------
//                                      UpdateCheckDelegate
// --------------------------------------------------------------------------------------------------------------------------------------------------
- (void) updateFound:(NSDictionary *)updateDictionary{
    
    
    if (self.parentViewController == nil) {
        if (self.completionBlock) {
            self.completionBlock(UpdateActionUpdateFound);
        }
        
        if (self.completion) {
            UpdateResult *result = [[UpdateResult alloc] init];
            result.targetURL = [NSURL URLWithString:[updateDictionary objectForKey:@"targetPackageURL"]];
            result.isShow = ([Controller displayDateIsValidFromDictionary:updateDictionary] && [Controller displayPeriodIsValidFromDictionary:updateDictionary]);
            result.isForceUpdate = [Controller checkForceUpdateFromDictionary:updateDictionary];
            self.completion(result);
        }
        return;
    }
    
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
                                              if (self.completionBlock) {
                                                  self.completionBlock(UpdateActionUpdateChosen);
                                              }
                                          }
                                          else {
                                              if (self.completionBlock) {
                                                  self.completionBlock(UpdateActionUpdateCheckCompleted);
                                              }
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
                                     if (self.completionBlock) {
                                         self.completionBlock(UpdateActionUpdateChosen);
                                     }
                                     
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
                                         if (self.completionBlock) {
                                             self.completionBlock(UpdateActionUpdateCheckCompleted);
                                         }
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
    if (self.completionBlock) {
        self.completionBlock(UpdateActionUpdateCheckCompleted);
    }
}

- (void) updateNotFound{
    NSLog(@"updateNotFound");
    if (self.completionBlock) {
        self.completionBlock(UpdateActionUpdateCheckCompleted);
    }
}

@end
