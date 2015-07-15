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
//  Message.m
//  TurkcellUpdaterSampleApp
//
//  Created by SonatKarakas on 1/9/13.
//  Copyright (c) 2013 Turkcell. All rights reserved.
//

#import "Message.h"

@implementation Message

+(instancetype)sharedInstance
{
    static id shared;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shared = [[self alloc] init];
    });
    return shared;
}


- (NSString *) getMessage:(NSString *)messageType{
    return [self getLocalisedStringForKey:messageType preferredLanguage:self.preferredLanguage];
}

#pragma mark - Localisation Support

/**
 *  Localisation support. Gets localised string from language bundle.
 *
 *  @param key key of localised string
 *
 *  @return localised string
 */
-(NSString *)getLocalisedStringForKey:(NSString *)key preferredLanguage:(NSString *)preferredLanguage{

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Localizable" ofType:@"strings" inDirectory:[NSString stringWithFormat:@"%@.lproj",preferredLanguage]];
    
    if (filePath){
        NSDictionary *dictionary = [[NSDictionary alloc ] initWithContentsOfFile:filePath];
        NSString *localizedString = [dictionary objectForKey:key];
        if (localizedString) {
            return  localizedString;
        }
    }
    
    return NSLocalizedString(key, nil);
}

@end
