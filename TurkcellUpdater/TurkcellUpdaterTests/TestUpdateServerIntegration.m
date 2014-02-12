//
//  TestUpdateServerIntegration.m
//  TurkcellUpdaterSampleApp
//
//  Created by Sonat Karakas on 2/7/13.
//  Copyright (c) 2013 Sonat Karakas. All rights reserved.
//

#import "TestUpdateServerIntegration.h"
#import "UpdateServerIntegration.h"

@implementation TestUpdateServerIntegration

@synthesize updateDataJSON;

- (void)setUp
{
    [super setUp];
    DLog(@"setup");
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
    DLog(@"teardown");
}

- (void)testUpdateServerIntegration
{

    UpdateServerIntegration *updateServerIntegration = [UpdateServerIntegration initWithDelegate:self postSelector:@selector(updateCallback:errror:)];
    
    [updateServerIntegration getJsonFromServerWithoutParameters:@"http://10.210.210.132:8082/device/getConfiguration?appPackageName=com.sonatkarakas.TurkcellUpdaterSampleApp&deviceOsName=ios"];
    
    NSDate *fiveSecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:5.0];
    [[NSRunLoop currentRunLoop] runUntilDate:fiveSecondsFromNow];
    
    STAssertNotNil(updateDataJSON, @"JSON from server is null");
}

- (void) updateCallback:(NSDictionary *) updateDataDictionary
                 errror:(NSError *) error
{
    
    updateDataJSON = updateDataDictionary;
}

@end
