//
//  TestUpdateServerIntegration.h
//  TurkcellUpdaterSampleApp
//
//  Created by Sonat Karakas on 2/7/13.
//  Copyright (c) 2013 Sonat Karakas. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface TestUpdateServerIntegration : SenTestCase

@property (nonatomic, retain) NSDictionary *updateDataJSON;

- (void) updateCallback:(NSDictionary *) updateDataDictionary
                 errror:(NSError *) error;

@end
