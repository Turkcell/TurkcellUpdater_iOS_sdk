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
//  Filter.m
//  TurkcellUpdaterSampleApp
//
//  Created by Sonat Karakas on 1/16/13.
//  Copyright (c) 2013 Turkcell. All rights reserved.
//

#import "Filter.h"
#import "Configuration.h"

// --------------------------------------------------------------------------------------------------------------------------------------------------
//                                      Private Methods (Interface)
// --------------------------------------------------------------------------------------------------------------------------------------------------
@interface Filter (PrivateMethods)

+ (NSDictionary *) getUpdates:(NSDictionary *)updateDataDictionary;
+ (NSDictionary *) getMessages:(NSDictionary *)updateDataDictionary;
+ (NSDictionary *) getFiltersFromUpdatesMessages:(NSDictionary *) updatesMessages;
+ (BOOL) isFilterMatchedWith:(NSDictionary *) updatesMessages
               currentConfiguration:(NSDictionary *) currentConfigurationDictionary;
+ (BOOL) isFilterPart:(NSString *)filterPart matchesWithValue:(NSString *)value;

@end
// --------------------------------------------------------------------------------------------------------------------------------------------------

@implementation Filter

+ (NSDictionary *) getMatchedUpdateFromUpdateDataDictionary:(NSDictionary *)updateDataDictionary
                                   withCurrentConfiguration:(NSDictionary *)currentConfiguration;{
    
    NSDictionary *updates = [self getUpdates:updateDataDictionary];
    BOOL matchedUpdateFound = NO;
    BOOL hasFilter = NO;
    NSDictionary *update;
    
    for (update in updates) {
        
        if ([update isKindOfClass:[NSDictionary class]]){
            if ([update objectForKey:@"filters"])
                hasFilter = YES;
                
            if ([self isFilterMatchedWith:update currentConfiguration:currentConfiguration]) {
                matchedUpdateFound = YES;
                break;
            }
        }
    }
    
    if (matchedUpdateFound)
        return update;
    else if (hasFilter)
        return nil;
    else if (updates)
        return updates;

    return nil;
}

+ (NSDictionary *) getMatchedMessageFromUpdateDataDictionary:(NSDictionary *)updateDataDictionary
                                    withCurrentConfiguration:(NSDictionary *)currentConfiguration{
    
    NSDictionary *messages = [self getMessages:updateDataDictionary];
    BOOL matchedMessageFound = NO;
    BOOL hasMessages = NO;
    NSDictionary *message;
    
    for (message in messages) {
        
        if ([message isKindOfClass:[NSDictionary class]]){
            if ([message objectForKey:@"messages"])
                hasMessages = YES;
            
            if ([self isFilterMatchedWith:message currentConfiguration:currentConfiguration]) {
                matchedMessageFound = YES;
                break;
            }

        }
        
    }
    
    if (matchedMessageFound)
        return message;
    else if (hasMessages)
        return nil;
    else if (messages)
        return messages;
    
    return nil;
    
}


@end

// --------------------------------------------------------------------------------------------------------------------------------------------------
//                                      Private Methods (Implementation)
// --------------------------------------------------------------------------------------------------------------------------------------------------
@implementation Filter (PrivateMethods)

+ (NSDictionary *) getUpdates:(NSDictionary *)updateDataDictionary{
    
    NSDictionary *updates = [updateDataDictionary objectForKey:@"updates"];
    
    return updates;
}

+ (NSDictionary *) getFiltersFromUpdatesMessages:(NSDictionary *) updatesMessages{
    
    NSDictionary *filters = [updatesMessages objectForKey:@"filters"];
    
    return filters;
    
}

+ (NSDictionary *) getMessages:(NSDictionary *)updateDataDictionary{
    
    NSDictionary *messages = [updateDataDictionary objectForKey:@"messages"];
    
    return messages;
}

+ (BOOL) isFilterMatchedWith:(NSDictionary *) updatesMessages
        currentConfiguration:(NSDictionary *) currentConfigurationDictionary{
    
    BOOL filterValueSingleLoop;
    BOOL filterValueExcludeFilterFound;
    BOOL flagTrue;
    
    NSDictionary *filters = [self getFiltersFromUpdatesMessages:updatesMessages];
    
    for (NSString *key in [filters allKeys]) {
        
        filterValueSingleLoop = YES;
        filterValueExcludeFilterFound = NO;
        flagTrue = NO;
        
        NSString *allFilterValues = [filters objectForKey:key];
        NSArray *filterValueArray = [allFilterValues componentsSeparatedByString:@","];
        
        NSString *filterValue, *currentConfigurationValue;
        
        //Find if there is a Exclude Filter
        for (filterValue in filterValueArray) {
            if ([filterValue rangeOfString:@"!"].location == 0) {
                filterValueExcludeFilterFound = YES;
            }
        }
        
        for (filterValue in filterValueArray) {
            
            BOOL filterValueSingleLoopExcludeFilterFound = NO;
            
            filterValue = [filterValue stringByReplacingOccurrencesOfString:@" " withString:@""];
            currentConfigurationValue = [currentConfigurationDictionary objectForKey:key];
            
            if ([filterValue rangeOfString:@"!"].location == 0){
                filterValueSingleLoopExcludeFilterFound = YES;
                filterValue = [filterValue substringFromIndex:1];
            }
            
            filterValueSingleLoop = [self isFilterPart:filterValue matchesWithValue:currentConfigurationValue];
            
            if (filterValueSingleLoopExcludeFilterFound)
                filterValueSingleLoop = !filterValueSingleLoop;

            if (filterValueSingleLoop) {
                flagTrue = YES;
            }

            if (filterValueSingleLoop && filterValueExcludeFilterFound == NO) {
                break;
            }
            
            if (filterValueSingleLoop == NO && filterValueSingleLoopExcludeFilterFound) {
                break;
            }
            
            if (flagTrue) {
                filterValueSingleLoop = YES;
            }
        }
        
        if (filterValueSingleLoop == NO) {
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL) isFilterPart:(NSString *)filterPart matchesWithValue:(NSString *)value{
    
    if (value == nil) {
        return NO;
    }

    if ([filterPart isEqualToString:@"''"]) {
        if ([value isEqualToString:@"''"] || [value length] == 0)
            return YES;
        else
            return NO;
    }
    
    if ([filterPart rangeOfString:@"<>"].location == 0) {
        
        NSComparisonResult result = [[filterPart substringFromIndex:2] compare:value];
        
        if (result != NSOrderedSame) {
            return YES;
        } else {
            return NO;
        }
        
//old version of comparison. which was not suitable for 3 digit versions
/*
        double currentConfigurationValueDouble = [value doubleValue];
        double filterValueDouble = [[filterPart substringFromIndex:2] doubleValue];
        
        if  (!(currentConfigurationValueDouble != filterValueDouble))
            return NO;
        else
            return YES;
*/
    }
    
    if ([filterPart rangeOfString:@"<="].location == 0) {
        
        NSComparisonResult result = [[filterPart substringFromIndex:2] compare:value];
        
        if (result == NSOrderedSame || result == NSOrderedDescending) {
            return YES;
        } else {
            return NO;
        }
        
//old version of comparison. which was not suitable for 3 digit versions
/*
        double currentConfigurationValueDouble = [value doubleValue];
        double filterValueDouble = [[filterPart substringFromIndex:2] doubleValue];
        
        if (!(currentConfigurationValueDouble <= filterValueDouble))
            return NO;
        else
            return YES;
*/
    }
    
    if ([filterPart rangeOfString:@">="].location == 0) {
        
        NSComparisonResult result = [[filterPart substringFromIndex:2] compare:value];
        
        if (result == NSOrderedSame || result == NSOrderedAscending) {
            return YES;
        } else {
            return NO;
        }
       
//old version of comparison. which was not suitable for 3 digit versions
/*
        double currentConfigurationValueDouble = [value doubleValue];
        double filterValueDouble = [[filterPart substringFromIndex:2] doubleValue];
        
        if (!(currentConfigurationValueDouble >= filterValueDouble))
            return NO;
        else
            return YES;
*/
    }
    
    if ([filterPart rangeOfString:@"<"].location == 0) {
        
        NSComparisonResult result = [[filterPart substringFromIndex:1] compare:value];
        
        if (result == NSOrderedDescending) {
            return YES;
        } else {
            return NO;
        }
        
//old version of comparison. which was not suitable for 3 digit versions
/*
        double currentConfigurationValueDouble = [value doubleValue];
        double filterValueDouble = [[filterPart substringFromIndex:1] doubleValue];
        
        if (!(currentConfigurationValueDouble < filterValueDouble))
            return NO;
        else
            return YES;
*/
    }
    
    if ([filterPart rangeOfString:@">"].location == 0) {
        NSComparisonResult result = [[filterPart substringFromIndex:1] compare:value];
        
        if (result == NSOrderedAscending) {
            return YES;
        } else {
            return NO;
        }

//old version of comparison. which was not suitable for 3 digit versions
/*
        double currentConfigurationValueDouble = [value doubleValue];
        double filterValueDouble = [[filterPart substringFromIndex:1] doubleValue];
        
        if (!(currentConfigurationValueDouble > filterValueDouble))
            return NO;
        else
            return YES;
*/
    }
    
    if ([filterPart rangeOfString:@"*"].length > 0) {
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"SELF LIKE %@",filterPart];
        BOOL result = [predicate evaluateWithObject:value];
        if (!result)
            return NO;
        else
            return YES;
    }
    
    if (!([value isEqualToString:filterPart]))
        return NO;
    else
        return YES;

}

@end
