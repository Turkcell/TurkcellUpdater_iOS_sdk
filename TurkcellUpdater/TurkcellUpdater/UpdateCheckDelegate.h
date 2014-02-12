//
//  UpdateCheckDelegate.h
//  TurkcellUpdaterSampleApp
//
//  Created by Sonat Karakas on 1/11/13.
//  Copyright (c) 2013 Sonat Karakas. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UpdateCheckDelegate <NSObject>

- (void) updateFound:(NSDictionary *)updateDictionary;
- (void) updateCheckFailed:(NSError *)error;
- (void) updateNotFound;
- (void) displayMessageFound:(NSDictionary *)messageDictionary;

@end
