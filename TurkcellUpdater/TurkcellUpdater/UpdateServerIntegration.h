//
//  UpdateServerIntegration.h
//  TurkcellUpdaterSampleApp
//
//  Created by Sonat Karakas on 1/4/13.
//  Copyright (c) 2013 Sonat Karakas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateServerIntegration : NSObject

@property (atomic, retain) NSMutableData *receivedData;
@property (atomic, retain) id delegate;
@property (atomic) SEL postSelector;

+ (UpdateServerIntegration *) initWithDelegate:(id)delegate
                                  postSelector:(SEL)postSelector;

- (void) getJsonFromServer:(NSString *)serverURL;
- (void) getJsonFromServerByPostingProperties:(NSString *)serverURL;
- (void) getJsonFromServerWithoutParameters:(NSString *)serverURL;

@end
