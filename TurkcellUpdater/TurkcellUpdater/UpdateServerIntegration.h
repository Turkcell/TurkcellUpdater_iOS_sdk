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
