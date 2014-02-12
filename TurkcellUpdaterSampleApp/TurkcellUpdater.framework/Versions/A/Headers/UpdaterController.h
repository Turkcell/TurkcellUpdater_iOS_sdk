//
//  UpdaterController.h
//  TurkcellUpdaterSampleApp
//
//  Created by Sonat Karakas on 1/14/13.
//  Copyright (c) 2013 Sonat Karakas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateCheckDelegate.h"
#import "UpdaterControllerDelegate.h"
#import "MessageViewDelegate.h"
#import "MessageView.h"

@interface UpdaterController : UIView <UpdateCheckDelegate, UIAlertViewDelegate, MessageViewDelegate>

@property (nonatomic, retain) NSString *updateServerURL;
@property (nonatomic, retain) id<UpdaterControllerDelegate> updaterControllerDelegate;
@property (nonatomic, retain) MessageView *messageView;
@property (nonatomic, assign) BOOL postProperties;

+ (UpdaterController *) initWithUpdateURL:(NSString *)URL
								 delegate:(id<UpdaterControllerDelegate>)delegate
                           postProperties:(BOOL)postProperties;

- (void) getUpdateInformation;

@end
