//
//  UIAlertViewCustom.h
//  TurkcellUpdaterSampleApp
//
//  Created by Sonat Karakas on 1/11/13.
//  Copyright (c) 2013 Sonat Karakas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertViewCustom : UIAlertView

@property (nonatomic, retain) NSString *targetPackageURL;
@property (nonatomic, retain) NSString *forceUpdate;
@property (nonatomic, retain) NSString *forceExit;

@end
