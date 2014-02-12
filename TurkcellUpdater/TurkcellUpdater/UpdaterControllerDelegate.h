//
//  UpdaterControllerDelegate.h
//  TurkcellUpdaterSampleApp
//
//  Created by Sonat Karakas on 1/16/13.
//  Copyright (c) 2013 Sonat Karakas. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UpdaterControllerDelegate <NSObject>

- (void) exitApplication;
- (void) updateCheckCompleted;

@end
