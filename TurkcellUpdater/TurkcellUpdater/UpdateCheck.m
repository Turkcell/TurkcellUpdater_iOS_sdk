//
//  UpdateCheck.m
//  TurkcellUpdaterSampleApp
//
//  Created by Sonat Karakas on 1/10/13.
//  Copyright (c) 2013 Sonat Karakas. All rights reserved.
//

#import "UpdateCheck.h"
#import "UpdateServerIntegration.h"
#import "Configuration.h"
#import "Controller.h"
#import "Message.h"
#import "Filter.h"

// --------------------------------------------------------------------------------------------------------------------------------------------------
//                                      Private Methods (Interface)
// --------------------------------------------------------------------------------------------------------------------------------------------------
@interface UpdateCheck (PrivateMethods)

- (void) computeJson:(NSDictionary *)dictionary;
//- (void) computeJsonOfPostPropertiesResponse:(NSDictionary *)dictionary;
- (void) computeMessageDictionary:(NSDictionary *)dictionary;

@end
// --------------------------------------------------------------------------------------------------------------------------------------------------

@implementation UpdateCheck

@synthesize updateServerURL,updateCheckDelegate,postProperties;

+ (UpdateCheck *) initWithUpdateServerURL:(NSString *)url
                                 delegate:(id<UpdateCheckDelegate>)delegate
                            postProperties:(BOOL)postProperties{
    
    UpdateCheck *updateCheck = [[UpdateCheck alloc] init];
    updateCheck.postProperties = postProperties;
    [updateCheck setUpdateServerURL:url];
    [updateCheck setUpdateCheckDelegate:delegate];
    
    return updateCheck;
    
}

- (void) update{
    UpdateServerIntegration *updateServerIntegration = [UpdateServerIntegration initWithDelegate:self postSelector:@selector(updateCallback:errror:)];
    if (postProperties)
        [updateServerIntegration getJsonFromServerByPostingProperties:[self updateServerURL]];
    else
        [updateServerIntegration getJsonFromServer:[self updateServerURL]];
    
}

- (void) updateCallback:(NSDictionary *) updateDataDictionary
                 errror:(NSError *) error{
    
    if (error != nil)
        [[self updateCheckDelegate] updateCheckFailed:error];
    else
        [self computeJson:updateDataDictionary];
}

@end

// --------------------------------------------------------------------------------------------------------------------------------------------------
//                                      Private Methods (Implementation)
// --------------------------------------------------------------------------------------------------------------------------------------------------
@implementation UpdateCheck (PrivateMethods)

- (void) computeJson:(NSDictionary *)updateDataDictionary{

    NSDictionary *currentConfigurationDictionary = [Configuration getCurrentConfiguration];
    
    if ([Controller bundleIDControlCurrentConfiguration:currentConfigurationDictionary
                                         withUpdateData:updateDataDictionary]){
        
        NSString *alertViewTitle, *cancelButtonTitle, *okButtonTitle;
        
        NSDictionary *updateDictionary = [Filter getMatchedUpdateFromUpdateDataDictionary:updateDataDictionary
                                                       withCurrentConfiguration:[Configuration getCurrentConfiguration]];
        
        NSDictionary *messageDictionary = [Filter getMatchedMessageFromUpdateDataDictionary:updateDataDictionary
                                                        withCurrentConfiguration:[Configuration getCurrentConfiguration]];
        
        if (updateDictionary == nil) {
            
            if (messageDictionary == nil) {
                [[self updateCheckDelegate] updateNotFound];
            }else{
                [self computeMessageDictionary:[Controller getMessageDictionaryFromMessage:messageDictionary]];
            }
            
            return;
        }
        
        NSString *forceUpdateString = [Controller getForceUpdateFromUpdate:updateDictionary];
        
        if ([forceUpdateString isEqualToString:@"true"] == YES || [forceUpdateString isEqualToString:@"1"]){
            
            alertViewTitle = [Message getMessage:@"update_required"];
            cancelButtonTitle = [Message getMessage:@"exit_application"];
            
        }else{
            
            alertViewTitle = [Message getMessage:@"update_found"];
            cancelButtonTitle = [Message getMessage:@"remind_me_later"];
            
        }
        
        okButtonTitle = [Message getMessage:@"install_"];
        
        NSDictionary *descriptions = [Controller getDescriptionsForLanguage:[currentConfigurationDictionary objectForKey:@"deviceLanguage"] fromUpdate:updateDictionary];
        
        if (([descriptions objectForKey:@"message"] == nil) || (!([[[descriptions objectForKey:@"message"] description] length] > 0))) {
            
            [[self updateCheckDelegate] updateNotFound];
            
        }else{
        
            NSString *message = [NSString stringWithString:[descriptions objectForKey:@"message"]];
            
            if (([descriptions objectForKey:@"warnings"] != nil) && ([[[descriptions objectForKey:@"warnings"] description] length] > 0)) {
                message = [message stringByAppendingString:@"\n"];
                message = [message stringByAppendingString:[descriptions objectForKey:@"warnings"]];
            }
            
            if (([descriptions objectForKey:@"whatIsNew"] != nil) && ([[[descriptions objectForKey:@"whatIsNew"] description] length] > 0)) {
                message = [message stringByAppendingString:@"\n"];
                message = [message stringByAppendingString:[descriptions objectForKey:@"whatIsNew"]];
            }
            
            NSMutableDictionary *alertViewDictionary = [[NSMutableDictionary alloc] init];
            [alertViewDictionary setValue:alertViewTitle forKey:@"alertViewTitle"];
            [alertViewDictionary setValue:message forKey:@"message"];
            [alertViewDictionary setValue:cancelButtonTitle forKey:@"cancelButtonTitle"];
            
            if ([forceUpdateString isEqualToString:@"true"] == YES || [forceUpdateString isEqualToString:@"1"]){
                [alertViewDictionary setValue:nil forKey:@"cancelButtonTitle"];
            }

            

            
            
            [alertViewDictionary setValue:okButtonTitle forKey:@"okButtonTitle"];
            
            if (([Controller getTargetPackageURLFromUpdate:updateDictionary] == nil || [[[Controller getTargetPackageURLFromUpdate:updateDictionary] description] length] == 0) &&
                ([[[Controller getForceExitFromUpdate:updateDictionary] description] isEqualToString:@"false"])){
            
                if (message == nil) {
                    [[self updateCheckDelegate] updateNotFound];
                }else{
                    [self computeMessageDictionary:[Controller getMessageDictionaryFromMessage:messageDictionary]];
                }

                return;
                
            }else{
                
                [alertViewDictionary setValue:[Controller getTargetPackageURLFromUpdate:updateDictionary]
                                   forKeyPath:@"targetPackageURL"];
                
                [alertViewDictionary setValue:[[Controller getForceUpdateFromUpdate:updateDictionary] description]
                                       forKey:@"forceUpdate"];
                
                [alertViewDictionary setValue:[[Controller getForceExitFromUpdate:updateDictionary] description]
                                       forKey:@"forceExit"];
                
                [[self updateCheckDelegate] updateFound:alertViewDictionary];
                
            }
            
        }
        
    }
    else{
        NSError *bundleIDError = [[NSError alloc] initWithDomain:@"BUNDLE_ID_INCORRECT" code:-1 userInfo:nil];
        [[self updateCheckDelegate] updateCheckFailed:bundleIDError];
    }
    
}

/*
- (void) computeJsonOfPostPropertiesResponse:(NSDictionary *)updateDataDictionary{
    
    NSDictionary *currentConfigurationDictionary = [Configuration getCurrentConfiguration];
    
    if ([Controller bundleIDControlCurrentConfiguration:currentConfigurationDictionary
                                         withUpdateData:updateDataDictionary]){
        
        NSString *alertViewTitle, *cancelButtonTitle, *okButtonTitle;
        
        NSDictionary *updateDictionary = [Filter getMatchedUpdateFromUpdateDataDictionary:updateDataDictionary
                                                                 withCurrentConfiguration:[Configuration getCurrentConfiguration]];
        
        //NSDictionary *updateDictionary = [updateDataDictionary copy];
        
        NSDictionary *messageDictionary = [Filter getMatchedMessageFromUpdateDataDictionary:updateDataDictionary
                                                                   withCurrentConfiguration:[Configuration getCurrentConfiguration]];
        
        if (updateDictionary == nil) {
            
            if (messageDictionary == nil) {
                [[self updateCheckDelegate] updateNotFound];
            }else{
                [self computeMessageDictionary:[Controller getMessageDictionaryFromMessage:messageDictionary]];
            }
            
            return;
        }
        
        if ([[Controller getForceUpdateFromUpdate:updateDictionary] isEqualToString:@"true"] == YES){
            
            alertViewTitle = [Message getMessage:@"update_required"];
            cancelButtonTitle = [Message getMessage:@"exit_application"];
            
        }else{
            
            alertViewTitle = [Message getMessage:@"update_found"];
            cancelButtonTitle = [Message getMessage:@"remind_me_later"];
            
        }
        
        okButtonTitle = [Message getMessage:@"install_"];
        
        NSDictionary *descriptions = [Controller getDescriptionsForLanguageOfPostPropertiesResponse:[currentConfigurationDictionary objectForKey:@"deviceLanguage"] fromUpdate:updateDictionary];
        
        if (([descriptions objectForKey:@"message"] == nil) || (!([[[descriptions objectForKey:@"message"] description] length] > 0))) {
            
            [[self updateCheckDelegate] updateNotFound];
            
        }else{
            
            NSString *message = [NSString stringWithString:[descriptions objectForKey:@"message"]];
            
            if (([descriptions objectForKey:@"warnings"] != nil) && ([[[descriptions objectForKey:@"warnings"] description] length] > 0)) {
                message = [message stringByAppendingString:@"\n"];
                message = [message stringByAppendingString:[descriptions objectForKey:@"warnings"]];
            }
            
            if (([descriptions objectForKey:@"whatIsNew"] != nil) && ([[[descriptions objectForKey:@"whatIsNew"] description] length] > 0)) {
                message = [message stringByAppendingString:@"\n"];
                message = [message stringByAppendingString:[descriptions objectForKey:@"whatIsNew"]];
            }
            
            NSMutableDictionary *alertViewDictionary = [[NSMutableDictionary alloc] init];
            [alertViewDictionary setValue:alertViewTitle forKey:@"alertViewTitle"];
            [alertViewDictionary setValue:message forKey:@"message"];
            [alertViewDictionary setValue:cancelButtonTitle forKey:@"cancelButtonTitle"];
            [alertViewDictionary setValue:okButtonTitle forKey:@"okButtonTitle"];
            
            if (([Controller getTargetPackageURLFromUpdateOfPostPropertiesResponse:updateDictionary] == nil || [[[Controller getTargetPackageURLFromUpdateOfPostPropertiesResponse:updateDictionary] description] length] == 0) &&
                ([[[Controller getForceExitFromUpdate:updateDictionary] description] isEqualToString:@"false"])){
                
                if (message == nil) {
                    [[self updateCheckDelegate] updateNotFound];
                }else{
                    [self computeMessageDictionary:[Controller getMessageDictionaryFromMessage:messageDictionary]];
                }
                
                return;
                
            }else{
                
                [alertViewDictionary setValue:[Controller getTargetPackageURLFromUpdateOfPostPropertiesResponse:updateDictionary]
                                   forKeyPath:@"targetPackageURL"];
                
                [alertViewDictionary setValue:[[Controller getForceUpdateFromUpdate:updateDictionary] description]
                                       forKey:@"forceUpdate"];
                
                [alertViewDictionary setValue:[[Controller getForceExitFromUpdate:updateDictionary] description]
                                       forKey:@"forceExit"];
                
                [[self updateCheckDelegate] updateFound:alertViewDictionary];
                
            }
            
        }
        
    }
    else{
        NSError *bundleIDError = [[NSError alloc] initWithDomain:@"BUNDLE_ID_INCORRECT" code:-1 userInfo:nil];
        [[self updateCheckDelegate] updateCheckFailed:bundleIDError];
    }
    
}
*/

- (void) computeMessageDictionary:(NSDictionary *)messageDictionary{
    
    if (messageDictionary != nil) {
        
        BOOL showMessage = YES;
        
        NSDate *now = [NSDate date];
        NSNumber *storedId = [messageDictionary objectForKey:@"id"];
        NSDate *displayAfterDate = [messageDictionary objectForKey:@"displayAfterDate"];
        NSDate *displayBeforeDate = [messageDictionary objectForKey:@"displayBeforeDate"];
        NSNumber *maxDisplayCount = [messageDictionary objectForKey:@"maxDisplayCount"];
        NSNumber *displayPeriodInHours = [messageDictionary objectForKey:@"displayPeriodInHours"];
        
        if (displayAfterDate != nil) {
            if ([displayAfterDate compare:now] == NSOrderedDescending)
                showMessage = NO;
        }
        
        if (displayBeforeDate != nil) {
            if ([displayBeforeDate compare:now] == NSOrderedAscending)
                showMessage = NO;
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSMutableDictionary *updateDictionary;
        updateDictionary = [userDefaults objectForKey:[storedId description]];
        
        NSDate *messageLastShownDate = nil;
        NSNumber *displayCount = 0;
        
        if (updateDictionary != nil) {
            messageLastShownDate =  [updateDictionary objectForKey:@"messageLastShownDate"];
            displayCount = [NSNumber numberWithInteger:[[updateDictionary objectForKey:@"displayCount"] integerValue]];
            
            if ([displayCount intValue] >= [maxDisplayCount intValue]) {
                showMessage = NO;
            }
            
            NSTimeInterval secondsInHours = [displayPeriodInHours integerValue] * 60 * 60;
            NSDate *messageLastShownDatePlusThreeHours = [messageLastShownDate dateByAddingTimeInterval:secondsInHours];
            
            if ([messageLastShownDatePlusThreeHours compare:now] == NSOrderedDescending){
                showMessage = NO;
            }
            
        }
        
        if (showMessage) {
            
            if (updateDictionary != nil){
                updateDictionary = [[NSMutableDictionary alloc] initWithDictionary:updateDictionary];
                [updateDictionary setObject:now forKey:@"messageLastShownDate"];
                [updateDictionary setObject:[NSNumber numberWithInteger:[displayCount integerValue] + 1]  forKey:@"displayCount"];
            }else{
                updateDictionary = [[NSMutableDictionary alloc] init];
                [updateDictionary setObject:now forKey:@"messageLastShownDate"];
                [updateDictionary setObject:[NSNumber numberWithInteger:1]  forKey:@"displayCount"];
            }
            
            [userDefaults setObject:updateDictionary forKey:[storedId description]];
            [userDefaults synchronize];
            
            NSString *title, *message, *imageUrl, *targetWebsiteUrl;
            
            title = [messageDictionary objectForKey:@"title"];
            message = [messageDictionary objectForKey:@"message"];
            imageUrl = [messageDictionary objectForKey:@"imageUrl"];
            targetWebsiteUrl = [messageDictionary objectForKey:@"targetWebsiteUrl"];
            
            if (title == nil) title = @"";
            if (message == nil) message = @"";
            if (imageUrl == nil) imageUrl = @"";
            if (targetWebsiteUrl == nil) targetWebsiteUrl = @"";
            
            NSMutableDictionary *messageViewDictionary = [[NSMutableDictionary alloc] init];
            
            [messageViewDictionary setObject:title forKey:@"title"];
            [messageViewDictionary setObject:message forKey:@"message"];
            [messageViewDictionary setObject:imageUrl forKey:@"imageUrl"];
            [messageViewDictionary setObject:targetWebsiteUrl forKey:@"targetWebsiteUrl"];
            
            [[self updateCheckDelegate] displayMessageFound:messageViewDictionary];
            
        }else{
            [[self updateCheckDelegate] updateNotFound];
        }
        
    }else{
        
        [[self updateCheckDelegate] updateNotFound];
        
    }
    
}

@end