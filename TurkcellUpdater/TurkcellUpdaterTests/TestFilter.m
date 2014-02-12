//
//  TestFilter.m
//  TurkcellUpdaterSampleApp
//
//  Created by Sonat Karakas on 2/11/13.
//  Copyright (c) 2013 Sonat Karakas. All rights reserved.
//

#import "TestFilter.h"
#import "Filter.h"

@implementation TestFilter

- (void) testFilterForTablet
{
    
    //Create Update Data Dictionary Mock Object
    NSString *dictionaryString = @"{ "
    " \"packageName\": \"com.sonatkarakas.TurkcellUpdaterSampleApp\", "
    " \"updates\":[                                                   "
    "              {                                                  "
    "                 \"filters\": {                                  "
    "                      \"deviceIsTablet\": \"true\",              "
    "                  },                                             "
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
    "                 \"forceUpdate\": \"false\"                      "
    "              },                                                 "
    "             ]                                                   "
    "   } ";
    
    NSData *data = [dictionaryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *updateDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSDictionary *currentConfiguration = [self getCurrentConfigurationWithPackageName:@""
                                                                               tablet:@"true"
                                                                       appVersionName:@""
                                                                      deviceOsVersion:@""
                                                                          deviceModel:@""
                                                                       deviceLanguage:@""];
    
    NSDictionary *returnUpdateDictionary = [Filter getMatchedUpdateFromUpdateDataDictionary:updateDataDictionary withCurrentConfiguration:currentConfiguration];
    
    STAssertNotNil(returnUpdateDictionary, @"Return object is null!");
    
}

- (void) testFilterForPhone
{

    //Create Update Data Dictionary Mock Object
    NSString *dictionaryString = @"{ "
    " \"packageName\": \"com.sonatkarakas.TurkcellUpdaterSampleApp\", "
    " \"updates\":[                                                   "
    "              {                                                  "
    "                 \"filters\": {                                  "
    "                      \"deviceIsTablet\": \"false\",             "
    "                      \"deviceLanguage\": \"en\"                 "
    "                  },                                             "
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
    "                 \"forceUpdate\": \"false\"                      "
    "              },                                                 "
    "             ]                                                  "
    "   } ";
    
    NSData *data = [dictionaryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *updateDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];

    NSDictionary *currentConfiguration = [self getCurrentConfigurationWithPackageName:@""
                                                                               tablet:@"false"
                                                                       appVersionName:@""
                                                                      deviceOsVersion:@""
                                                                          deviceModel:@""
                                                                       deviceLanguage:@"en"];
    
    NSDictionary *returnUpdateDictionary = [Filter getMatchedUpdateFromUpdateDataDictionary:updateDataDictionary withCurrentConfiguration:currentConfiguration];
    
    STAssertNotNil(returnUpdateDictionary, @"Return object is null!");

}

- (void) testFilterForDeviceLanguage
{
    
    //Create Update Data Dictionary Mock Object
    NSString *dictionaryString = @"{ "
    " \"packageName\": \"com.sonatkarakas.TurkcellUpdaterSampleApp\", "
    " \"updates\":[                                                   "
    "              {                                                  "
    "                 \"filters\": {                                  "
    "                      \"deviceIsTablet\": \"false\",             "
    "                      \"deviceLanguage\": \"en\"                 "
    "                  },                                             "
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
    "                 \"forceUpdate\": \"false\"                      "
    "              },                                                 "
    "             ]                                                  "
    "   } ";
    
    NSData *data = [dictionaryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *updateDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];

    NSDictionary *currentConfiguration = [self getCurrentConfigurationWithPackageName:@""
                                                                               tablet:@"false"
                                                                       appVersionName:@""
                                                                      deviceOsVersion:@""
                                                                          deviceModel:@""
                                                                       deviceLanguage:@"en"];
    
    NSDictionary *returnUpdateDictionary = [Filter getMatchedUpdateFromUpdateDataDictionary:updateDataDictionary withCurrentConfiguration:currentConfiguration];
    
    STAssertNotNil(returnUpdateDictionary, @"Return object is null!");
    
}

- (void) testFilterForDeviceLanguageWithAsterik
{
    
    //Create Update Data Dictionary Mock Object
    NSString *dictionaryString = @"{ "
    " \"packageName\": \"com.sonatkarakas.TurkcellUpdaterSampleApp\", "
    " \"updates\":[                                                   "
    "              {                                                  "
    "                 \"filters\": {                                  "
    "                      \"deviceIsTablet\": \"false\",             "
    "                      \"deviceLanguage\": \"*\"                  "
    "                  },                                             "
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
    "                 \"forceUpdate\": \"false\"                      "
    "              },                                                 "
    "             ]                                                  "
    "   } ";
    
    NSData *data = [dictionaryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *updateDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];

    NSDictionary *currentConfiguration = [self getCurrentConfigurationWithPackageName:@""
                                                                               tablet:@"false"
                                                                       appVersionName:@""
                                                                      deviceOsVersion:@""
                                                                          deviceModel:@""
                                                                       deviceLanguage:@"en"];
    
    NSDictionary *returnUpdateDictionary = [Filter getMatchedUpdateFromUpdateDataDictionary:updateDataDictionary withCurrentConfiguration:currentConfiguration];
    
    STAssertNotNil(returnUpdateDictionary, @"Return object is null!");
    
}

- (void) testFilterForDeviceModelNotMatch
{
    
    /*
     @"i386"      on the simulator
     @"iPod1,1"   on iPod Touch
     @"iPod2,1"   on iPod Touch Second Generation
     @"iPod3,1"   on iPod Touch Third Generation
     @"iPod4,1"   on iPod Touch Fourth Generation
     @"iPhone1,1" on iPhone
     @"iPhone1,2" on iPhone 3G
     @"iPhone2,1" on iPhone 3GS
     @"iPad1,1"   on iPad
     @"iPad2,1"   on iPad 2
     @"iPad3,1"   on iPad 3 (aka new iPad)
     @"iPhone3,1" on iPhone 4
     @"iPhone4,1" on iPhone 4S
     @"iPhone5,1" on iPhone 5
     @"iPhone5,2" on iPhone 5
    */
    
    //Create Update Data Dictionary Mock Object
    NSString *dictionaryString = @"{ "
    " \"packageName\": \"com.sonatkarakas.TurkcellUpdaterSampleApp\", "
    " \"updates\":[                                                   "
    "              {                                                  "
    "                 \"filters\": {                                  "
    "                      \"deviceIsTablet\": \"false\",             "
    "                      \"deviceLanguage\": \"en\",                "
    "                      \"deviceModel\": \"iPod2*\"                 "
    "                  },                                             "
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
    "                 \"forceUpdate\": \"false\"                      "
    "              },                                                 "
    "             ]                                                  "
    "   } ";
    
    NSData *data = [dictionaryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *updateDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSDictionary *currentConfiguration = [self getCurrentConfigurationWithPackageName:@""
                                                                               tablet:@"false"
                                                                       appVersionName:@""
                                                                      deviceOsVersion:@""
                                                                          deviceModel:@"iPad2,1"
                                                                       deviceLanguage:@"en"];
    
    NSDictionary *returnUpdateDictionary = [Filter getMatchedUpdateFromUpdateDataDictionary:updateDataDictionary withCurrentConfiguration:currentConfiguration];
    
    STAssertNil(returnUpdateDictionary, @"Return object is not null!");
    
}

- (void) testFilterForOsVersion
{
    
    //Create Update Data Dictionary Mock Object
    NSString *dictionaryString = @"{ "
    " \"packageName\": \"com.sonatkarakas.TurkcellUpdaterSampleApp\", "
    " \"updates\":[                                                   "
    "              {                                                  "
    "                 \"filters\": {                                  "
    "                      \"deviceIsTablet\": \"false\",             "
    "                      \"deviceLanguage\": \"*\",                 "
    "                      \"deviceOsVersion\": \"5.1,6.0,6.1\"       "
    "                  },                                             "
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
    "                 \"forceUpdate\": \"false\"                      "
    "              },                                                 "
    "             ]                                                  "
    "   } ";
    
    NSData *data = [dictionaryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *updateDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSDictionary *currentConfiguration = [self getCurrentConfigurationWithPackageName:@""
                                                                               tablet:@"false"
                                                                       appVersionName:@""
                                                                      deviceOsVersion:@"6.0"
                                                                          deviceModel:@"iPod2,1"
                                                                       deviceLanguage:@"en"];
    
    NSDictionary *returnUpdateDictionary = [Filter getMatchedUpdateFromUpdateDataDictionary:updateDataDictionary withCurrentConfiguration:currentConfiguration];
    
    STAssertNotNil(returnUpdateDictionary, @"Return object is null!");
    
}

- (void) testFilterForOsVersionWithAsterik
{
    
    //Create Update Data Dictionary Mock Object
    NSString *dictionaryString = @"{ "
    " \"packageName\": \"com.sonatkarakas.TurkcellUpdaterSampleApp\", "
    " \"updates\":[                                                   "
    "              {                                                  "
    "                 \"filters\": {                                  "
    "                      \"deviceIsTablet\": \"false\",             "
    "                      \"deviceLanguage\": \"*\",                 "
    "                      \"deviceOsVersion\": \"5.1,6.*\"           "
    "                  },                                             "
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
    "                 \"forceUpdate\": \"false\"                      "
    "              },                                                 "
    "             ]                                                  "
    "   } ";
    
    NSData *data = [dictionaryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *updateDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSDictionary *currentConfiguration = [self getCurrentConfigurationWithPackageName:@""
                                                                               tablet:@"false"
                                                                       appVersionName:@""
                                                                      deviceOsVersion:@"6.0"
                                                                          deviceModel:@"iPod2,1"
                                                                       deviceLanguage:@"en"];
    
    NSDictionary *returnUpdateDictionary = [Filter getMatchedUpdateFromUpdateDataDictionary:updateDataDictionary withCurrentConfiguration:currentConfiguration];
    
    STAssertNotNil(returnUpdateDictionary, @"Return object is null!");
    
}

- (void) testFilterForOsVersionNotMatch
{
    
    //Create Update Data Dictionary Mock Object
    NSString *dictionaryString = @"{ "
    " \"packageName\": \"com.sonatkarakas.TurkcellUpdaterSampleApp\", "
    " \"updates\":[                                                   "
    "              {                                                  "
    "                 \"filters\": {                                  "
    "                      \"deviceIsTablet\": \"false\",             "
    "                      \"deviceLanguage\": \"*\",                 "
    "                      \"deviceOsVersion\": \"5.1,6.*\"           "
    "                  },                                             "
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
    "                 \"forceUpdate\": \"false\"                      "
    "              },                                                 "
    "             ]                                                  "
    "   } ";
    
    NSData *data = [dictionaryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *updateDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSDictionary *currentConfiguration = [self getCurrentConfigurationWithPackageName:@""
                                                                               tablet:@"false"
                                                                       appVersionName:@""
                                                                      deviceOsVersion:@"4.3"
                                                                          deviceModel:@"iPod2,1"
                                                                       deviceLanguage:@"en"];
    
    NSDictionary *returnUpdateDictionary = [Filter getMatchedUpdateFromUpdateDataDictionary:updateDataDictionary withCurrentConfiguration:currentConfiguration];
    
    STAssertNil(returnUpdateDictionary, @"Return object is null!");
    
}

- (void) testFilterForAppVersionName
{
    
    //Create Update Data Dictionary Mock Object
    NSString *dictionaryString = @"{ "
    " \"packageName\": \"com.sonatkarakas.TurkcellUpdaterSampleApp\", "
    " \"updates\":[                                                   "
    "              {                                                  "
    "                 \"filters\": {                                  "
    "                      \"deviceIsTablet\": \"false\",             "
    "                      \"deviceLanguage\": \"*\",                 "
    "                      \"deviceOsVersion\": \"5.1,6.*\",          "
    "                      \"appVersionName\": \"*\"                "
    "                  },                                             "
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
    "                 \"forceUpdate\": \"false\"                      "
    "              },                                                 "
    "             ]                                                  "
    "   } ";
    
    NSData *data = [dictionaryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *updateDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSDictionary *currentConfiguration = [self getCurrentConfigurationWithPackageName:@""
                                                                               tablet:@"false"
                                                                       appVersionName:@"1.0"
                                                                      deviceOsVersion:@"6.3"
                                                                          deviceModel:@"iPod2,1"
                                                                       deviceLanguage:@"en"];
    
    NSDictionary *returnUpdateDictionary = [Filter getMatchedUpdateFromUpdateDataDictionary:updateDataDictionary withCurrentConfiguration:currentConfiguration];
    
    STAssertNotNil(returnUpdateDictionary, @"Return object is null!");
    
}

- (void) testFilterForWrongFilterKey
{
    
    //Create Update Data Dictionary Mock Object
    NSString *dictionaryString = @"{ "
    " \"packageName\": \"com.sonatkarakas.TurkcellUpdaterSampleApp\", "
    " \"updates\":[                                                   "
    "              {                                                  "
    "                 \"filters\": {                                  "
    "                      \"wrongFilterKey\": \"false\",             "
    "                      \"deviceLanguage\": \"*\",                 "
    "                  },                                             "
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
    "                 \"forceUpdate\": \"false\"                      "
    "              },                                                 "
    "             ]                                                  "
    "   } ";
    
    NSData *data = [dictionaryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *updateDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSDictionary *currentConfiguration = [self getCurrentConfigurationWithPackageName:@""
                                                                               tablet:@"false"
                                                                       appVersionName:@"2.3"
                                                                      deviceOsVersion:@"6.3"
                                                                          deviceModel:@"iPod2,1"
                                                                       deviceLanguage:@"en"];
    
    NSDictionary *returnUpdateDictionary = [Filter getMatchedUpdateFromUpdateDataDictionary:updateDataDictionary withCurrentConfiguration:currentConfiguration];
    
    STAssertNil(returnUpdateDictionary, @"Return object is not null!");
    
}

- (void) testFilterForWrongFilterValue
{
    
    //Create Update Data Dictionary Mock Object
    NSString *dictionaryString = @"{ "
    " \"packageName\": \"com.sonatkarakas.TurkcellUpdaterSampleApp\", "
    " \"updates\":[                                                   "
    "              {                                                  "
    "                 \"filters\": {                                  "
    "                      \"appVersionName\": \"wrongKey\",              "
    "                      \"deviceLanguage\": \"*\",                 "
    "                  },                                             "
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
    "                 \"forceUpdate\": \"false\"                      "
    "              },                                                 "
    "             ]                                                  "
    "   } ";
    
    NSData *data = [dictionaryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *updateDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSDictionary *currentConfiguration = [self getCurrentConfigurationWithPackageName:@""
                                                                               tablet:@"false"
                                                                       appVersionName:@"2.3"
                                                                      deviceOsVersion:@"6.3"
                                                                          deviceModel:@"iPod2,1"
                                                                       deviceLanguage:@"en"];
    
    NSDictionary *returnUpdateDictionary = [Filter getMatchedUpdateFromUpdateDataDictionary:updateDataDictionary withCurrentConfiguration:currentConfiguration];
    
    STAssertNil(returnUpdateDictionary, @"Return object is not null!");
    
}

- (void) testFilterForNotFilter
{
    
    //Create Update Data Dictionary Mock Object
    NSString *dictionaryString = @"{ "
    " \"packageName\": \"com.sonatkarakas.TurkcellUpdaterSampleApp\", "
    " \"updates\":[                                                   "
    "              {                                                  "
    "                 \"filters\": {                                  "
    "                      \"appVersionName\": \"1.0,!1.0,2.0\",     "
    "                      \"deviceLanguage\": \"!tr\",               "
    "                  },                                             "
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
    "                 \"forceUpdate\": \"false\"                      "
    "              },                                                 "
    "             ]                                                  "
    "   } ";
    
    NSData *data = [dictionaryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *updateDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSDictionary *currentConfiguration = [self getCurrentConfigurationWithPackageName:@""
                                                                               tablet:@"false"
                                                                       appVersionName:@"3.0"
                                                                      deviceOsVersion:@"6.3"
                                                                          deviceModel:@"iPod2,1"
                                                                       deviceLanguage:@"en"];
    
    NSDictionary *returnUpdateDictionary = [Filter getMatchedUpdateFromUpdateDataDictionary:updateDataDictionary withCurrentConfiguration:currentConfiguration];
    
    STAssertNotNil(returnUpdateDictionary, @"Return object is null!");
    
}

- (void) testFilterForEmptyString
{
    
    //Create Update Data Dictionary Mock Object
    NSString *dictionaryString = @"{ "
    " \"packageName\": \"com.sonatkarakas.TurkcellUpdaterSampleApp\", "
    " \"updates\":[                                                   "
    "              {                                                  "
    "                 \"filters\": {                                  "
    "                      \"appVersionName\": \"3.0\",                 "
    "                      \"deviceLanguage\": \"''\",                "
    "                  },                                             "
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
    "                 \"forceUpdate\": \"false\"                      "
    "              },                                                 "
    "             ]                                                  "
    "   } ";
    
    NSData *data = [dictionaryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *updateDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSDictionary *currentConfiguration = [self getCurrentConfigurationWithPackageName:@""
                                                                               tablet:@"false"
                                                                       appVersionName:@"3.0"
                                                                      deviceOsVersion:@"6.3"
                                                                          deviceModel:@"iPod2,1"
                                                                       deviceLanguage:@""];
    
    NSDictionary *returnUpdateDictionary = [Filter getMatchedUpdateFromUpdateDataDictionary:updateDataDictionary withCurrentConfiguration:currentConfiguration];
    
    STAssertNotNil(returnUpdateDictionary, @"Return object is null!");
    
}

- (void) testFilterForNotEmptyString
{
    
    //Create Update Data Dictionary Mock Object
    NSString *dictionaryString = @"{ "
    " \"packageName\": \"com.sonatkarakas.TurkcellUpdaterSampleApp\", "
    " \"updates\":[                                                   "
    "              {                                                  "
    "                 \"filters\": {                                  "
    "                      \"appVersionName\": \"3.0\",                 "
    "                      \"deviceLanguage\": \"!''\",                "
    "                  },                                             "
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
    "                 \"forceUpdate\": \"false\"                      "
    "              },                                                 "
    "             ]                                                  "
    "   } ";
    
    NSData *data = [dictionaryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *updateDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSDictionary *currentConfiguration = [self getCurrentConfigurationWithPackageName:@""
                                                                               tablet:@"false"
                                                                       appVersionName:@"3.0"
                                                                      deviceOsVersion:@"6.3"
                                                                          deviceModel:@"iPod2,1"
                                                                       deviceLanguage:@"en"];
    
    NSDictionary *returnUpdateDictionary = [Filter getMatchedUpdateFromUpdateDataDictionary:updateDataDictionary withCurrentConfiguration:currentConfiguration];
    
    STAssertNotNil(returnUpdateDictionary, @"Return object is null!");
    
}

//--------------------------------------------------------------------------------------------------------
//                              PRIVATE METHODS
//--------------------------------------------------------------------------------------------------------
- (NSDictionary *) getCurrentConfigurationWithPackageName:(NSString *)packageName
                                                   tablet:(NSString *)tablet   
                                      appVersionName:(NSString *)versionName
                                     deviceOsVersion:(NSString *)osVersion
                                         deviceModel:(NSString *)model
                                      deviceLanguage:(NSString *)language{
    
    NSMutableDictionary *currentConfiguration = [[NSMutableDictionary alloc] init];
    
    //appVersionName
    [currentConfiguration setObject:versionName forKey:@"appVersionName"];
    
    //packageName
    [currentConfiguration setObject:packageName forKey:@"packageName"];
    
    //deviceOSVersion
    [currentConfiguration setObject:osVersion forKey:@"deviceOsVersion"];
    
    //deviceModel
    [currentConfiguration setObject:model forKey:@"deviceModel"];
    
    //deviceIsTablet
    [currentConfiguration setObject:tablet forKey:@"deviceIsTablet"];
    
    //deviceLanguage
    [currentConfiguration setObject:language forKey:@"deviceLanguage"];
    
    return currentConfiguration;
}

@end
