//
//  MessageViewDelegate.h
//  TurkcellUpdater
//
//  Created by Sonat Karakas on 3/27/13.
//  Copyright (c) 2013 Sonat Karakas. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MessageViewDelegate <NSObject>

- (void) OKButtonClicked;
- (void) viewButtonClicked;

@end
