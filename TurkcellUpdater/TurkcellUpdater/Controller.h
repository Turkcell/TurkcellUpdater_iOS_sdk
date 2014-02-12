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
//  Controller.h
//  TurkcellUpdaterSampleApp
//
//  Created by Sonat Karakas on 1/4/13.
//  Copyright (c) 2013 Sonat Karakas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Controller : NSObject

+ (BOOL) bundleIDControlCurrentConfiguration:(NSDictionary *)currentConfigurationDictionary
                              withUpdateData:(NSDictionary *)updateDataDictionary;

+ (NSString *) getForceUpdateFromUpdate:(NSDictionary *)updateDataDictionary;
+ (NSString *) getForceExitFromUpdate:(NSDictionary *)updateDataDictionary;
+ (NSString *) getTargetPackageURLFromUpdate:(NSDictionary *)updateDataDictionary;
+ (NSDictionary *) getDescriptionsForLanguage:(NSString *)language
                                   fromUpdate:(NSDictionary *)updateDataDictionary;
+ (NSString *) getTargetPackageURLFromUpdateOfPostPropertiesResponse:(NSDictionary *)updateDataDictionary;
+ (NSDictionary *) getDescriptionsForLanguageOfPostPropertiesResponse:(NSString *)language
                                   fromUpdate:(NSDictionary *)updateDataDictionary;
+ (NSNumber *) getIdFromMessage:(NSDictionary *)messageDataDictionary;
+ (NSNumber *) generateIdForMessage:(NSDictionary *)messageDataDictionary;
+ (NSString *) getTargetWebsiteUrlFromMessage:(NSDictionary *)messageDataDictionary;
+ (NSNumber *) getMaxDisplayCountFromMessage:(NSDictionary *)messageDataDictionary;
+ (NSDate *) getDisplayBeforeDateFromMessage:(NSDictionary *)messageDataDictionary;
+ (NSDate *) getDisplayAfterDateFromMessage:(NSDictionary *)messageDataDictionary;
+ (NSNumber *) getDisplayPeriodInHoursFromMessage:(NSDictionary *)messageDataDictionary;
+ (NSDictionary *) getMessageDictionaryFromMessage:(NSDictionary *)messageDataDictionary;

@end
