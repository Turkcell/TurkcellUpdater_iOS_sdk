//
//  UpdateCheck.h
//  TurkcellUpdaterSampleApp
//
//  Created by Sonat Karakas on 1/10/13.
//  Copyright (c) 2013 Sonat Karakas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UpdateCheckDelegate.h"

@interface UpdateCheck : NSObject

@property (atomic, retain) NSString *updateServerURL;
@property (atomic, retain) id<UpdateCheckDelegate> updateCheckDelegate;
@property (nonatomic, assign) BOOL postProperties;

+ (UpdateCheck *) initWithUpdateServerURL:(NSString *)url
                                 delegate:(id<UpdateCheckDelegate>)delegate
                           postProperties:(BOOL)postProperties;


- (void) update;
- (void) updateCallback:(NSDictionary *) updateDataDictionary
                 errror:(NSError *) error;

@end
