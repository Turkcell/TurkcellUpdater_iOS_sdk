//
//  TestUpdateCheck.m
//  TurkcellUpdaterSampleApp
//
//  Created by Sonat Karakas on 2/11/13.
//  Copyright (c) 2013 Sonat Karakas. All rights reserved.
//

#import "TestUpdateCheck.h"
#import "UpdateCheck.h"

BOOL postProperties = NO;

@implementation TestUpdateCheck

@synthesize alertViewDictionary, flagUpdateNotFound, updateCheckFailedError, messageViewDictionary;

- (void) testUpdateCheckUpdateNotFound
{
    //Create Update Data Dictionary Mock Object
    NSDictionary *updateDataDictionary = [self createUpdateDataDictionaryForUpdateNotFound];
    
    UpdateCheck *updateCheck = [UpdateCheck initWithUpdateServerURL:nil delegate:self postProperties:postProperties];
    [updateCheck updateCallback:updateDataDictionary errror:nil];
    
    NSDate *fiveSecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:5.0];
    [[NSRunLoop currentRunLoop] runUntilDate:fiveSecondsFromNow];

    STAssertTrue(flagUpdateNotFound, @"Update Not Found is false!");
}

- (void) testUpdateCheckUpdateFound
{

    //Create Update Data Dictionary Mock Object
    NSDictionary *updateDataDictionary = [self createUpdateDataDictionaryForUpdateFound];
    
    UpdateCheck *updateCheck = [UpdateCheck initWithUpdateServerURL:nil delegate:self postProperties:postProperties];
    [updateCheck updateCallback:updateDataDictionary errror:nil];
    
    NSDate *fiveSecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:5.0];
    [[NSRunLoop currentRunLoop] runUntilDate:fiveSecondsFromNow];
    
    NSDictionary *alertOrMessageDictionary;
    if (alertViewDictionary != nil) {
        alertOrMessageDictionary = alertViewDictionary;
    }else{
        alertOrMessageDictionary = messageViewDictionary;
    }
    
    STAssertNotNil(alertOrMessageDictionary, @"Update Found object is null!");
}

- (void) testMessageForMaxDisplayCount
{
    
    //Create Update Data Dictionary Mock Object    
    NSString *dictionaryString = @"{ "
    " \"packageName\": \"com.turkcell.TurkcellUpdaterSampleApp\", "
    " \"messages\":[                                                  "
    "              {                                                  "
    "                 \"descriptions\": {                             "
    "                     \"*\": {                                    "
    "                         \"title\": \"any - title\",             "
    "                         \"message\": \"any - message\",         "
    "                         \"imageUrl\": \"any - imageurl\"        "
    "                     }                                           "
    "                 },                                              "
    "                 \"maxDisplayCount\": \"500\",                   "
    "                 \"id\": \"1\"                                   "
    "              },                                                 "
    "             ]                                                   "
    "   } ";

    
    NSData *data = [dictionaryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *messageDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    //Set NSUserDefaults as a Mock Object
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+02:00"]];
    NSDate *date = [dateFormat dateFromString:@"2013-02-01 14:00"];
    [updateDictionary setObject:date forKey:@"messageLastShownDate"];
    [updateDictionary setObject:[NSNumber numberWithInteger:499]  forKey:@"displayCount"];
    
    [userDefaults setObject:updateDictionary forKey:@"1"];
    [userDefaults synchronize];
    
    messageViewDictionary = nil;
    
    UpdateCheck *updateCheck = [UpdateCheck initWithUpdateServerURL:nil delegate:self postProperties:postProperties];
    
    //1st Call
    [updateCheck updateCallback:messageDataDictionary errror:nil];
    
    NSDate *fiveSecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:5.0];
    [[NSRunLoop currentRunLoop] runUntilDate:fiveSecondsFromNow];
    
    STAssertNotNil(messageViewDictionary, @"Message object is null!");
    
    //2nd Call
    messageViewDictionary = nil;
    [updateCheck updateCallback:messageDataDictionary errror:nil];
    
    fiveSecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:5.0];
    [[NSRunLoop currentRunLoop] runUntilDate:fiveSecondsFromNow];
    
    STAssertNil(messageViewDictionary, @"Message object is null!");
}

/*
- (void) testMessageForDisplayBeforeDate
{
    
    //Create Update Data Dictionary Mock Object
    NSString *dictionaryString = @"{ "
    " \"packageName\": \"com.turkcell.TurkcellUpdaterSampleApp\", "
    " \"messages\":[                                                  "
    "              {                                                  "
    "                 \"descriptions\": {                             "
    "                     \"*\": {                                    "
    "                         \"title\": \"any - title\",             "
    "                         \"message\": \"any - message\",         "
    "                         \"imageUrl\": \"any - imageurl\"        "
    "                     }                                           "
    "                 },                                              "
    "                 \"displayBeforeDate\": \"2020-01-01\",          "
    "                 \"id\": \"1\"                                   "
    "              },                                                 "
    "             ]                                                   "
    "   } ";
    
    
    NSData *data = [dictionaryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *messageDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    //Set NSUserDefaults as a Mock Object
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+02:00"]];
    NSDate *date = [dateFormat dateFromString:@"2013-02-01 14:00"];
    [updateDictionary setObject:date forKey:@"messageLastShownDate"];
    [updateDictionary setObject:[NSNumber numberWithInteger:1]  forKey:@"displayCount"];
    
    [userDefaults setObject:updateDictionary forKey:@"1"];
    [userDefaults synchronize];
    
    messageViewDictionary = nil;
    
    UpdateCheck *updateCheck = [UpdateCheck initWithUpdateServerURL:nil delegate:self postProperties:postProperties];
    
    [updateCheck updateCallback:messageDataDictionary errror:nil];
    
    NSDate *fiveSecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:5.0];
    [[NSRunLoop currentRunLoop] runUntilDate:fiveSecondsFromNow];
    
    STAssertNotNil(messageViewDictionary, @"Message object is null!");
}
*/
 
- (void) testMessageForDisplayAfterDate
{
    
    //Create Update Data Dictionary Mock Object
    NSString *dictionaryString = @"{ "
    " \"packageName\": \"com.turkcell.TurkcellUpdaterSampleApp\", "
    " \"messages\":[                                                  "
    "              {                                                  "
    "                 \"descriptions\": {                             "
    "                     \"*\": {                                    "
    "                         \"title\": \"any - title\",             "
    "                         \"message\": \"any - message\",         "
    "                         \"imageUrl\": \"any - imageurl\"        "
    "                     }                                           "
    "                 },                                              "
    "                 \"displayAfterDate\": \"2020-01-01\",           "
    "                 \"id\": \"1\"                                   "
    "              },                                                 "
    "             ]                                                   "
    "   } ";
    
    
    NSData *data = [dictionaryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *messageDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    //Set NSUserDefaults as a Mock Object
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+02:00"]];
    NSDate *date = [dateFormat dateFromString:@"2013-02-01 14:00"];
    [updateDictionary setObject:date forKey:@"messageLastShownDate"];
    [updateDictionary setObject:[NSNumber numberWithInteger:1]  forKey:@"displayCount"];
    
    [userDefaults setObject:updateDictionary forKey:@"1"];
    [userDefaults synchronize];
    
    messageViewDictionary = nil;
    
    UpdateCheck *updateCheck = [UpdateCheck initWithUpdateServerURL:nil delegate:self postProperties:postProperties];
    
    [updateCheck updateCallback:messageDataDictionary errror:nil];
    
    NSDate *fiveSecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:5.0];
    [[NSRunLoop currentRunLoop] runUntilDate:fiveSecondsFromNow];
    
    STAssertNil(messageViewDictionary, @"Message object is null!");
}

- (void) testMessageForDisplayPeriodInHoursDontShow
{
    
    //Create Update Data Dictionary Mock Object
    NSString *dictionaryString = @"{ "
    " \"packageName\": \"com.turkcell.TurkcellUpdaterSampleApp\", "
    " \"messages\":[                                                  "
    "              {                                                  "
    "                 \"descriptions\": {                             "
    "                     \"*\": {                                    "
    "                         \"title\": \"any - title\",             "
    "                         \"message\": \"any - message\",         "
    "                         \"imageUrl\": \"any - imageurl\"        "
    "                     }                                           "
    "                 },                                              "
    "                 \"displayPeriodInHours\": \"2\",                "
    "                 \"id\": \"1\"                                   "
    "              },                                                 "
    "             ]                                                   "
    "   } ";
    
    
    NSData *data = [dictionaryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *messageDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    //Set NSUserDefaults as a Mock Object
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    NSDate *date = [NSDate date];
    [updateDictionary setObject:date forKey:@"messageLastShownDate"];
    [updateDictionary setObject:[NSNumber numberWithInteger:1]  forKey:@"displayCount"];
    
    [userDefaults setObject:updateDictionary forKey:@"1"];
    [userDefaults synchronize];

    messageViewDictionary = nil;
    
    UpdateCheck *updateCheck = [UpdateCheck initWithUpdateServerURL:nil delegate:self postProperties:postProperties];
    
    [updateCheck updateCallback:messageDataDictionary errror:nil];
    
    NSDate *fiveSecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:5.0];
    [[NSRunLoop currentRunLoop] runUntilDate:fiveSecondsFromNow];
    
    STAssertNil(messageViewDictionary, @"Message object is not null!");
}

/*
- (void) testMessageForDisplayPeriodInHoursShow
{
    
    //Create Update Data Dictionary Mock Object
    NSString *dictionaryString = @"{ "
    " \"packageName\": \"com.turkcell.TurkcellUpdaterSampleApp\", "
    " \"messages\":[                                                  "
    "              {                                                  "
    "                 \"descriptions\": {                             "
    "                     \"*\": {                                    "
    "                         \"title\": \"any - title\",             "
    "                         \"message\": \"any - message\",         "
    "                         \"imageUrl\": \"any - imageurl\"        "
    "                     }                                           "
    "                 },                                              "
    "                 \"displayPeriodInHours\": \"2\",                "
    "                 \"id\": \"1\"                                   "
    "              },                                                 "
    "             ]                                                   "
    "   } ";
    
    
    NSData *data = [dictionaryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *messageDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    //Set NSUserDefaults as a Mock Object
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    NSDate *date = [NSDate date];
    NSTimeInterval secondsInHours = 3 * 60 * 60 * -1;
    date = [date dateByAddingTimeInterval:secondsInHours];
    
    [updateDictionary setObject:date forKey:@"messageLastShownDate"];
    [updateDictionary setObject:[NSNumber numberWithInteger:1]  forKey:@"displayCount"];
    
    [userDefaults setObject:updateDictionary forKey:@"1"];
    [userDefaults synchronize];
    
    messageViewDictionary = nil;
    
    UpdateCheck *updateCheck = [UpdateCheck initWithUpdateServerURL:nil delegate:self postProperties:postProperties];
    
    [updateCheck updateCallback:messageDataDictionary errror:nil];
    
    NSDate *fiveSecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:5.0];
    [[NSRunLoop currentRunLoop] runUntilDate:fiveSecondsFromNow];
    
    STAssertNotNil(messageViewDictionary, @"Message object is null!");
}
*/
 
- (void) testMessageForDescriptionWithoutMessage
{
    
    //Create Update Data Dictionary Mock Object
    NSString *dictionaryString = @"{ "
    " \"packageName\": \"com.turkcell.TurkcellUpdaterSampleApp\", "
    " \"messages\":[                                                  "
    "              {                                                  "
    "                 \"descriptions\": {                             "
    "                     \"*\": {                                    "
    "                         \"title\": \"any - title\",             "
    "                         \"imageUrl\": \"any - imageurl\"        "
    "                     }                                           "
    "                 },                                              "
    "                 \"maxDisplayCount\": \"500\",                   "
    "                 \"id\": \"1\"                                   "
    "              },                                                 "
    "             ]                                                   "
    "   } ";
    
    
    NSData *data = [dictionaryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *messageDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    //Set NSUserDefaults as a Mock Object
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+02:00"]];
    NSDate *date = [dateFormat dateFromString:@"2013-02-01 14:00"];
    [updateDictionary setObject:date forKey:@"messageLastShownDate"];
    [updateDictionary setObject:[NSNumber numberWithInteger:1]  forKey:@"displayCount"];
    
    [userDefaults setObject:updateDictionary forKey:@"1"];
    [userDefaults synchronize];
    
    messageViewDictionary = nil;
    
    UpdateCheck *updateCheck = [UpdateCheck initWithUpdateServerURL:nil delegate:self postProperties:postProperties];
    
    [updateCheck updateCallback:messageDataDictionary errror:nil];
    
    NSDate *fiveSecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:5.0];
    [[NSRunLoop currentRunLoop] runUntilDate:fiveSecondsFromNow];
    
    STAssertNil(messageViewDictionary, @"Message object is not null!");
    
}

- (void) updateFound:(NSDictionary *)updateDictionary
{
    [self setAlertViewDictionary:updateDictionary];
}

- (void) updateCheckFailed:(NSError *)error
{
    updateCheckFailedError = error;
}

- (void) updateNotFound
{
    flagUpdateNotFound = YES;
}

- (void) displayMessageFound:(NSDictionary *)messageDictionary
{
    [self setMessageViewDictionary:messageDictionary];
}

//--------------------------------------------------------------------------------------------------------
//                              PRIVATE METHODS
//--------------------------------------------------------------------------------------------------------
- (NSDictionary *) createUpdateDataDictionaryForUpdateNotFound
{
    
    NSString *dictionaryString = @"{ "
        " \"packageName\": \"com.turkcell.TurkcellUpdaterSampleApp\", "
        "   } ";
    
    NSData *data = [dictionaryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    return dictionary;
    
}

- (NSDictionary *) createUpdateDataDictionaryForUpdateFound
{
    
    NSString *dictionaryString = @"{ "
    " \"packageName\": \"com.turkcell.TurkcellUpdaterSampleApp\", "
    " \"updates\":[                                                   "
    "              {                                                  "
    "                 \"descriptions\": {                             "
    "                     \"tr\": {                                   "
    "                         \"message\": \"tr - message\",          "
    "                         \"whatIsNew\": \"tr - what is new\",    "
    "                         \"warnings\": \"tr - warnings\"         "
    "                     },                                          "
    "                     \"en\": {                                   "
    "                         \"message\": \"en - message\",          "
    "                         \"whatIsNew\": \"en - what is new\",    "
    "                         \"warnings\": \"en - warnings\"         "
    "                     },                                          "
    "                     \"*\": {                                    "
    "                         \"message\": \"any - message\",         "
    "                         \"whatIsNew\": \"any - what is new\",   "
    "                         \"warnings\": \"any - warnings\"        "
    "                     }                                           "
    "                 },                                              "
    "                 \"forceUpdate\": \"false\",                      "
    "                 \"targetWebsiteUrl\": \"http://www.google.com\" "
    "              },                                                 "
    "             ]                                                  "
    "   } ";
  
    NSData *data = [dictionaryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    return dictionary;
    
}

@end
