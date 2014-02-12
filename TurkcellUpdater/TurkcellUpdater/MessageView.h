//
//  MesssageView.h
//  TurkcellUpdater
//
//  Created by Sonat Karakas on 3/26/13.
//  Copyright (c) 2013 Sonat Karakas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MessageViewDelegate.h"

@interface MessageView : NSObject

@property (nonatomic, retain) NSString *targetWebsiteUrl;
@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) id<MessageViewDelegate> delegate;

+ (MessageView *) initWithTitle:(NSString *)title
                         message:(NSString *)message
                        imageUrl:(NSString *)imageUrl
                targetWebsiteUrl:(NSString *)targetWebsiteUrl
                       delegate:(id<MessageViewDelegate>)delegate;

- (void) showOnView:(UIView *)parentView;

@end
