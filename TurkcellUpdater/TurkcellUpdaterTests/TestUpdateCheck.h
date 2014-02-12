//
//  TestUpdateCheck.h
//  TurkcellUpdaterSampleApp
//
//  Created by Sonat Karakas on 2/11/13.
//  Copyright (c) 2013 Sonat Karakas. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UpdateCheckDelegate.h"

@interface TestUpdateCheck : SenTestCase <UpdateCheckDelegate>

@property (nonatomic, retain) NSDictionary *alertViewDictionary;
@property (nonatomic, assign) BOOL flagUpdateNotFound;
@property (nonatomic, retain) NSError *updateCheckFailedError;
@property (nonatomic, retain) NSDictionary *messageViewDictionary;

@end
