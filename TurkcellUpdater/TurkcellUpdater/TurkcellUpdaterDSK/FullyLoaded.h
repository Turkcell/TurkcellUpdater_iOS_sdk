//
//  FullyLoaded.h
//  FullyLoaded
//
//  Created by Anoop Ranganath on 1/1/11.
//  Copyright 2011 Anoop Ranganath. All rights reserved.
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define FLImageLoadedNotification @"FLImageLoadedNotification"


@interface FullyLoaded : NSObject

+ (FullyLoaded *)sharedFullyLoaded;

- (void)clearMemoryCache;   // clear memory only, leave cache files
- (void)clearCache;         // clear memory and remove cache files
- (void)resume;
- (void)suspend;
- (void)cancelURL:(NSURL *)url;

- (void)imageForURL:(NSURL *)url completion:(void(^)(UIImage *image))completionBlock;
- (void)imageForURLString:(NSString *)urlString completion:(void(^)(UIImage *image))completionBlock;

- (void)cachedImageForURL:(NSURL *)url completion:(void(^)(UIImage *image))completionBlock;
- (void)cachedImageForURLString:(NSString *)urlString completion:(void(^)(UIImage *image))completionBlock;

- (void)cacheImage:(UIImage *)image forURL:(NSURL *)url;
- (void)cacheImage:(UIImage *)image forURLString:(NSString *)urlString;

@end
