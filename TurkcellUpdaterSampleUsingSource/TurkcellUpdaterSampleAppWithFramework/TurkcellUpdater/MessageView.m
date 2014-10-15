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
//  MesssageView.m
//  TurkcellUpdater
//
//  Created by Sonat Karakas on 3/26/13.
//  Copyright (c) 2013 Turkcell. All rights reserved.
//

#import "MessageView.h"
#import <QuartzCore/QuartzCore.h>
#import "Message.h"
#import <UIKit/UIKit.h>
#import "FLImageView.h"

@implementation UIImage (JTColor)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end


@implementation MessageView

@synthesize targetWebsiteUrl,view,delegate;

+ (MessageView *) initWithTitle:(NSString *)title
                         message:(NSString *)message
                        imageUrl:(NSString *)imageUrl
                targetWebsiteUrl:(NSString *)targetWebsiteUrl
                       delegate:(id<MessageViewDelegate>)delegate{
    
    MessageView *messageView = [[MessageView alloc] init];
    
    [messageView setTargetWebsiteUrl:targetWebsiteUrl];
    [messageView setDelegate:delegate];
    
    NSInteger viewHeight;
    
    if ([title length] > 0)
        viewHeight = 200;
    else
        viewHeight = 160;
    
    [messageView setView:[[UIView alloc] initWithFrame:CGRectMake(10, 150, 300, viewHeight)]];
    [[[messageView view] layer] setBorderColor:[UIColor darkGrayColor].CGColor];
    [[[messageView view] layer] setBorderWidth:3.0f];
    [[[messageView view] layer] setCornerRadius:10.0];
    
    NSInteger imageViewY;
    
    if ([title length] > 0) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
        [titleLabel setBackgroundColor:[UIColor blackColor]];
        [titleLabel setText:title];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [[titleLabel layer] setCornerRadius:10.0];
        [[messageView view] addSubview:titleLabel];
        imageViewY = 50;
        
    }else{
        imageViewY = 10;
    }
    
    NSInteger messageLabelX, messageLabelWidth;
    
    if ([imageUrl length] > 0) {
        

        FLImageView *imageView = [[FLImageView alloc] initWithFrame:CGRectMake(10, imageViewY, 100, 100)];
        [imageView loadImageAtURLString:imageUrl placeholderImage:[UIImage imageWithColor:[UIColor lightGrayColor]]];

        [[messageView view] addSubview:imageView];
        messageLabelX = 120;
        messageLabelWidth = 170;
    }else{
        messageLabelX = 10;
        messageLabelWidth = 300;
    }
    
    UITextView *messageLabel = [[UITextView alloc] initWithFrame:CGRectMake(messageLabelX, imageViewY, messageLabelWidth, 100)];
    [messageLabel setTextColor:[UIColor blackColor]];
    [messageLabel setTextAlignment:NSTextAlignmentLeft];
    [messageLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    [messageLabel setContentInset:UIEdgeInsetsMake(-12,-5, 5,0)];
    [messageLabel setEditable:NO];
    [messageLabel setScrollEnabled:YES];
    [messageLabel setShowsHorizontalScrollIndicator:YES];
    [messageLabel setShowsVerticalScrollIndicator:YES];
    [messageLabel setText:message];
    [[messageView view] addSubview:messageLabel];

    UIView *buttonBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight - 40, 300, 40)];
    [[buttonBackgroundView layer] setCornerRadius:10.0];
    [buttonBackgroundView setBackgroundColor:[UIColor lightGrayColor]];
    [[messageView view] addSubview:buttonBackgroundView];
    
    UIButton *buttonOK;
    NSInteger buttonOKWidth;
    
    if ([targetWebsiteUrl length] > 0) {
        
        UIButton *buttonView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [buttonView setFrame:CGRectMake(155, viewHeight - 35, 135, 30)];
        [buttonView setTitle:[Message getMessage:@"view"] forState:UIControlStateNormal];
        [buttonView addTarget:delegate action:@selector(viewButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [[messageView view] addSubview:buttonView];
        buttonOKWidth = 135;
    }else{
        buttonOKWidth = 300;
    }
    
    buttonOK = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonOK setFrame:CGRectMake(10, viewHeight - 35, buttonOKWidth, 30)];
    [buttonOK setTitle:[Message getMessage:@"close"] forState:UIControlStateNormal];
    [buttonOK addTarget:delegate action:@selector(OKButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [[messageView view] addSubview:buttonOK];
    
    return messageView;
}

- (void) showOnView:(UIView *)parentView{
    
    [parentView addSubview:view];
}

@end
