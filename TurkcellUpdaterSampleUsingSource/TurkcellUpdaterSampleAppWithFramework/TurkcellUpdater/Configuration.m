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
//  Configuration.m
//  TurkcellUpdaterSampleApp
//
//  Created by Sonat Karakas on 1/11/13.
//  Copyright (c) 2013 Turkcell. All rights reserved.
//

#import "Configuration.h"
#import <sys/utsname.h>

/**
 * Package name of application.<br>
 * Example value: "com.sample.app"
 * <br>
 * <strong>Overriding value of this key is not recommended.</strong>
 */
NSString * const KEY_APP_PACKAGE_NAME = @"appPackageName";

/**
 * Version name of application which is defined in AndroidManifest.xml typically in Major.Minor.Revision or Major.Minor format.<br>
 * Example value: "1.0.0".
 */
NSString * const KEY_APP_VERSION_NAME = @"appVersionName";

/**
 * Name of operating system of device.<br>
 * Value: "Android".
 * <br>
 * <strong>Overriding value of this key is not recommended.</strong>
 */
NSString * const KEY_DEVICE_OS_NAME = @"deviceOsName";

/**
 * Version name of operating system of device.<br>
 * Example value: "2.3.3".
 */
NSString * const KEY_DEVICE_OS_VERSION = @"deviceOsVersion";

/**
 * Model name of device.<br>
 * Example value: "HTC Wildfire S A510e" for HTC Wildfire S.
 */
NSString * const KEY_DEVICE_MODEL = @"deviceModel";

/**
 * "true" if devices is a tablet, otherwise "false". Since there is no clear evidence to determine if an Android device
 * is tablet or not, devices with minimum screen size wider than 600 dpi are considered as tablets.<br>
 * Example values: "true", "false".
 */
NSString * const KEY_DEVICE_IS_TABLET = @"deviceIsTablet";

/**
 * Two letter language code of device
 * (see: <a href="http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes">ISO 639-1</a>).<br>
 * Example values: "en", "tr", "fr".
 */
NSString * const KEY_DEVICE_LANGUAGE = @"deviceLanguage";

/**
 * A unique  alphanumeric identifier for device.<br>
 * Example value: "5e5aC2coeO0UuPY/nH/C3DdelqE4MuTkywh2aB9PT84"
 */
NSString * const KEY_DEVICE_ID = @"deviceId";

@implementation Configuration

+ (NSDictionary *) getCurrentConfiguration{
    
    NSMutableDictionary *propertyDictionary = [[NSMutableDictionary alloc] init];
    
    [propertyDictionary setValue:[[NSBundle mainBundle] bundleIdentifier] forKey:KEY_APP_PACKAGE_NAME];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    [propertyDictionary setValue:majorVersion forKey:KEY_APP_VERSION_NAME];
    [propertyDictionary setValue:[[UIDevice currentDevice] systemVersion] forKey:KEY_DEVICE_OS_VERSION];
    [propertyDictionary setValue:@"ios" forKey:KEY_DEVICE_OS_NAME];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine
                                               encoding:NSUTF8StringEncoding];
    
    [propertyDictionary setValue:deviceModel forKey:KEY_DEVICE_MODEL];
    
    BOOL deviceIsPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    if (deviceIsPad)
        [propertyDictionary setValue:@"true" forKey:KEY_DEVICE_IS_TABLET];
    else
        [propertyDictionary setValue:@"false" forKey:KEY_DEVICE_IS_TABLET];
    
    //Takes only the first two letter of language. For example en-US -> en
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if (language.length > 2)
        language = [language substringToIndex:2];
    
    [propertyDictionary setValue:language forKey:KEY_DEVICE_LANGUAGE];
    
    return propertyDictionary;
    
/*
    NSMutableDictionary *currentConfiguration = [[NSMutableDictionary alloc] init];
    
    //appVersionName
    NSString *appVersionName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if ( appVersionName == nil) {
        appVersionName = @"1.0";
    }
    
    [currentConfiguration setObject:appVersionName
                             forKey:@"appVersionName"];
    
    //packageName
    NSString *packageName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    if (packageName == nil) {
        packageName = @"com.turkcell.TurkcellUpdaterSampleApp";
    }
    [currentConfiguration setObject:packageName
                             forKey:@"packageName"];
    
    //deviceModel
    struct utsname systemInfo;
    uname(&systemInfo);

    [currentConfiguration setObject:[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding]
                             forKey:@"deviceModel"];

    //deviceOSVersion
    if ([[currentConfiguration objectForKey:@"deviceModel"] rangeOfString:@"i386"].length > 0 ){
        
        [currentConfiguration setObject:[[UIDevice currentDevice] systemVersion]
                                 forKey:@"deviceOsVersion"];
        
    }

    //deviceIsTablet
    NSString *isTablet;
    if ([[currentConfiguration objectForKey:@"deviceModel"] rangeOfString:@"iPad"].length > 0 )
        isTablet = @"true";
    else
        isTablet = @"false";

    [currentConfiguration setObject:isTablet
                             forKey:@"deviceIsTablet"];
    
    //deviceLanguage
    [currentConfiguration setObject:[[NSLocale preferredLanguages] objectAtIndex:0]
                             forKey:@"deviceLanguage"];
    
    return currentConfiguration;
*/
}

@end
