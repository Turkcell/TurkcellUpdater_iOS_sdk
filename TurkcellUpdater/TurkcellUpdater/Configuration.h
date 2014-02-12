//
//  Configuration.h
//  TurkcellUpdaterSampleApp
//
//  Created by Sonat Karakas on 1/11/13.
//  Copyright (c) 2013 Sonat Karakas. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Package name of application.<br>
 * Example value: "com.sample.app"
 * <br>
 * <strong>Overriding value of this key is not recommended.</strong>
 */
extern NSString * const KEY_APP_PACKAGE_NAME;

/**
 * Version name of application which is defined in AndroidManifest.xml typically in Major.Minor.Revision or Major.Minor format.<br>
 * Example value: "1.0.0".
 */
extern NSString * const KEY_APP_VERSION_NAME;

/**
 * Name of operating system of device.<br>
 * Value: "Android".
 * <br>
 * <strong>Overriding value of this key is not recommended.</strong>
 */
extern NSString * const KEY_DEVICE_OS_NAME;

/**
 * Version name of operating system of device.<br>
 * Example value: "2.3.3".
 */
extern NSString * const KEY_DEVICE_OS_VERSION;

/**
 * Model name of device.<br>
 * Example value: "HTC Wildfire S A510e" for HTC Wildfire S.
 */
extern NSString * const KEY_DEVICE_MODEL;

/**
 * "true" if devices is a tablet, otherwise "false". Since there is no clear evidence to determine if an Android device
 * is tablet or not, devices with minimum screen size wider than 600 dpi are considered as tablets.<br>
 * Example values: "true", "false".
 */
extern NSString * const KEY_DEVICE_IS_TABLET;

/**
 * Two letter language code of device
 * (see: <a href="http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes">ISO 639-1</a>).<br>
 * Example values: "en", "tr", "fr".
 */
extern NSString * const KEY_DEVICE_LANGUAGE;

/**
 * A unique  alphanumeric identifier for device.<br>
 * Example value: "5e5aC2coeO0UuPY/nH/C3DdelqE4MuTkywh2aB9PT84"
 */
extern NSString * const KEY_DEVICE_ID;

@interface Configuration : NSObject

+ (NSDictionary *) getCurrentConfiguration;

@end
