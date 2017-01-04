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
//  Controller.m
//  TurkcellUpdaterSampleApp
//
//  Created by Sonat Karakas on 1/4/13.
//  Copyright (c) 2013 Turkcell. All rights reserved.
//

#import "Controller.h"
#import "Configuration.h"

@implementation Controller

+ (BOOL) bundleIDControlCurrentConfiguration:(NSDictionary *)currentConfigurationDictionary
                              withUpdateData:(NSDictionary *)updateDataDictionary{
    
    if ([[currentConfigurationDictionary objectForKey:KEY_APP_PACKAGE_NAME] isEqual:[updateDataDictionary objectForKey:@"packageName"]])
        return YES;
    else
        return NO;
    
}

+ (NSString *) getForceUpdateFromUpdate:(NSDictionary *)updateDataDictionary{
    
    if (([updateDataDictionary objectForKey:@"forceUpdate"] == nil) ||
        (!([[[updateDataDictionary objectForKey:@"forceUpdate"] description] isEqualToString:@"true"]) &&
         !([[[updateDataDictionary objectForKey:@"forceUpdate"] description] isEqualToString:@"false"]) &&
         !([[[updateDataDictionary objectForKey:@"forceUpdate"] description] isEqualToString:@"1"]) &&
         !([[[updateDataDictionary objectForKey:@"forceUpdate"] description] isEqualToString:@"0"])
         )){
            return @"false";
        }
    
    return [[updateDataDictionary objectForKey:@"forceUpdate"] description];
}

+ (NSString *) getForceExitFromUpdate:(NSDictionary *)updateDataDictionary{
    
    if (([updateDataDictionary objectForKey:@"forceExit"] == nil) ||
        (!([[[updateDataDictionary objectForKey:@"forceExit"] description] isEqualToString:@"true"]) &&
         !([[[updateDataDictionary objectForKey:@"forceExit"] description] isEqualToString:@"false"]) &&
         !([[[updateDataDictionary objectForKey:@"forceExit"] description] isEqualToString:@"1"]) &&
         !([[[updateDataDictionary objectForKey:@"forceExit"] description] isEqualToString:@"0"])
         )){
            return @"false";
        }
    
    return [[updateDataDictionary objectForKey:@"forceExit"] description];
}

+ (NSString *) getTargetPackageURLFromUpdate:(NSDictionary *)updateDataDictionary{
    
    return [[updateDataDictionary objectForKey:@"targetWebsiteUrl"] description];
}

+ (NSDictionary *) getDescriptionsForLanguage:(NSString *)language
                                   fromUpdate:(NSDictionary *)updateDataDictionary{
    
    NSDictionary *descriptions = [[updateDataDictionary objectForKey:@"descriptions"] objectForKey:language];
    
    if (descriptions == nil) {
        descriptions = [[updateDataDictionary objectForKey:@"descriptions"] objectForKey:@"*"];
    }
    
    //message is required
    if ([descriptions objectForKey:@"message"] == nil) {
        descriptions = nil;
    }
    
    return descriptions;
}

+ (NSString *) getTargetPackageURLFromUpdateOfPostPropertiesResponse:(NSDictionary *)updateDataDictionary{
    
    return [[[updateDataDictionary objectForKey:@"updates"] objectForKey:@"targetWebsiteUrl"] description];
}

+ (NSDictionary *) getDescriptionsForLanguageOfPostPropertiesResponse:(NSString *)language
                                                           fromUpdate:(NSDictionary *)updateDataDictionary{
    
    NSDictionary *descriptions = [[[updateDataDictionary objectForKey:@"updates"] objectForKey:@"descriptions"] objectForKey:language];
    
    if (descriptions == nil) {
        descriptions = [[[updateDataDictionary objectForKey:@"updates"] objectForKey:@"descriptions"] objectForKey:@"*"];
    }
    
    //message is required
    if ([descriptions objectForKey:@"message"] == nil) {
        descriptions = nil;
    }
    
    return descriptions;
}

+ (NSNumber *) getIdFromMessage:(NSDictionary *)messageDataDictionary{
    
    if ([messageDataDictionary objectForKey:@"id"] == nil)
        return [self generateIdForMessage:messageDataDictionary];
    
    if ([[messageDataDictionary objectForKey:@"id"] intValue] == 0) {
        return [self generateIdForMessage:messageDataDictionary];
    }
    
    return [NSNumber numberWithInteger:[[messageDataDictionary objectForKey:@"id"] intValue]];
}

+ (NSNumber *) generateIdForMessage:(NSDictionary *)messageDataDictionary{
    
    NSUInteger generatedId = 1;
    NSUInteger prime = 31;
    NSDictionary *descriptions = [self getDescriptionsForLanguage:[[Configuration getCurrentConfiguration] objectForKey:@"deviceLanguage"]
                                                       fromUpdate:messageDataDictionary];
    
    NSString *targetWebsiteUrl = [self getTargetWebsiteUrlFromMessage:messageDataDictionary];
    
    if (descriptions != nil) {
        generatedId = prime * generatedId + [[descriptions description] hash];
    }
    
    if (targetWebsiteUrl != nil){
        generatedId = prime * generatedId + [targetWebsiteUrl hash];
    }
    
    return [NSNumber numberWithInteger:generatedId];
}

+ (NSString *) getTargetWebsiteUrlFromMessage:(NSDictionary *)messageDataDictionary{
    
    return [[messageDataDictionary objectForKey:@"targetWebsiteUrl"] description];
}

+ (NSNumber *) getMaxDisplayCountFromMessage:(NSDictionary *)messageDataDictionary{
    
    if ([messageDataDictionary objectForKey:@"maxDisplayCount"] == nil)
        return [NSNumber numberWithInteger:2147483647];
    
    return [NSNumber numberWithInteger:[[messageDataDictionary objectForKey:@"maxDisplayCount"] intValue]];
    
}

+ (NSDate *) getDisplayBeforeDateFromMessage:(NSDictionary *)messageDataDictionary{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+02:00"]];
    NSDate *date = [dateFormat dateFromString:[messageDataDictionary objectForKey:@"displayBeforeDate"]];
    
    if (date == nil) {
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        date = [dateFormat dateFromString:[messageDataDictionary objectForKey:@"displayBeforeDate"]];
    }
    
    return date;
}

+ (NSDate *) getDisplayAfterDateFromMessage:(NSDictionary *)messageDataDictionary{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+02:00"]];
    NSDate *date = [dateFormat dateFromString:[messageDataDictionary objectForKey:@"displayAfterDate"]];
    
    if (date == nil) {
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        date = [dateFormat dateFromString:[messageDataDictionary objectForKey:@"displayAfterDate"]];
    }
    
    return date;
}

+ (NSNumber *) getDisplayPeriodInHoursFromMessage:(NSDictionary *)messageDataDictionary{
    
    if ([messageDataDictionary objectForKey:@"displayPeriodInHours"] == nil)
        return [NSNumber numberWithInteger:0];
    
    if ([[messageDataDictionary objectForKey:@"displayPeriodInHours"] intValue] == 0) {
        return [NSNumber numberWithInteger:0];
    }
    
    return [NSNumber numberWithInteger:[[messageDataDictionary objectForKey:@"displayPeriodInHours"] intValue]];
    
}

+ (NSDictionary *) getMessageDictionaryFromMessage:(NSDictionary *)messageDataDictionary{
    
    NSMutableDictionary *messageDictionary = [NSMutableDictionary dictionaryWithDictionary:
                                              [self getDescriptionsForLanguage:[[Configuration getCurrentConfiguration] objectForKey:@"deviceLanguage"]
                                                                    fromUpdate:messageDataDictionary]];
    
    NSLog(@"%@", messageDictionary);
    
    if ([messageDictionary count] > 0) {
        [messageDictionary setValue:[self getIdFromMessage:messageDataDictionary] forKey:@"id"];
        [messageDictionary setValue:[self getTargetWebsiteUrlFromMessage:messageDataDictionary] forKey:@"targetWebsiteUrl"];
        [messageDictionary setValue:[self getMaxDisplayCountFromMessage:messageDataDictionary] forKey:@"maxDisplayCount"];
        [messageDictionary setValue:[self getDisplayBeforeDateFromMessage:messageDataDictionary] forKey:@"displayBeforeDate"];
        [messageDictionary setValue:[self getDisplayAfterDateFromMessage:messageDataDictionary] forKey:@"displayAfterDate"];
        [messageDictionary setValue:[self getDisplayPeriodInHoursFromMessage:messageDataDictionary] forKey:@"displayPeriodInHours"];
    }else{
        messageDictionary = nil;
    }
    
    return messageDictionary;
}

+ (BOOL)displayDateIsValidFromDictionary:(NSDictionary *)dictionary {
    
    NSString *kStartDate = @"displayBeforeDate";
    NSString *kEndDate = @"displayAfterDate";
    
    if (![dictionary objectForKey:kStartDate] || ![dictionary objectForKey:kEndDate]) {
        return YES;
    }
    
    NSString *startDateString = dictionary[kStartDate];
    NSString *endDateString = dictionary[kEndDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    if ([startDateString rangeOfString:@":"].location != NSNotFound) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSDate *startDate = [dateFormatter dateFromString:startDateString];
    
    if ([endDateString rangeOfString:@":"].location != NSNotFound) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSDate *endDate = [dateFormatter dateFromString:endDateString];
    
    
    NSDate *currentDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
    
    if (([startDate compare:currentDate] == NSOrderedAscending || [startDate compare:currentDate] == NSOrderedSame) &&
        ([endDate compare:currentDate] == NSOrderedDescending || [endDate compare:currentDate] == NSOrderedSame)) {
        return YES;
    }
    return NO;
}

+ (BOOL)displayPeriodIsValidFromDictionary:(NSDictionary *)dictionary {
    
    NSString *kDisplayPeriod = @"displayPeriodInHours";
    if (![dictionary objectForKey:kDisplayPeriod]) {
        return YES;
    }
    
    NSInteger displayPeriod = [dictionary[kDisplayPeriod] integerValue];
    
    NSString *kDateOfLastShow = @"last_show_date";
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kDateOfLastShow]) {
        [Controller updateLastShowDate];
        return YES;
    }
    NSDate *dateOfLastShow = [[NSUserDefaults standardUserDefaults] objectForKey:kDateOfLastShow];
    
    NSTimeInterval displayPeriodInterval = displayPeriod * 60 * 60;
    
    dateOfLastShow = [dateOfLastShow dateByAddingTimeInterval:displayPeriodInterval];
    
    if ([dateOfLastShow compare:[NSDate date]] == NSOrderedAscending) {
        [Controller updateLastShowDate];
        return YES;
    }
    
    return NO;
}

+ (BOOL)checkForceUpdateFromDictionary:(NSDictionary *)dictionary {
    
    NSString *kForceUpdate = @"forceUpdate";
    
    if (![dictionary objectForKey:kForceUpdate]) {
        return NO;
    }
    
    BOOL forceUpdate = NO;
    
    if ([dictionary[kForceUpdate] isKindOfClass:[NSString class]]) {
        forceUpdate = [dictionary[kForceUpdate] boolValue];
    }
    else {
        forceUpdate = dictionary[kForceUpdate];
    }
    
    return forceUpdate;
}

+ (void)updateLastShowDate {
    NSString *kDateOfLastShow = @"last_show_date";
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:kDateOfLastShow];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
