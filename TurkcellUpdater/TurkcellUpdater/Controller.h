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
