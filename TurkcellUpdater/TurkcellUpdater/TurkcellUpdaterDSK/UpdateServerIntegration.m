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
//  UpdateServerIntegration.m
//  TurkcellUpdaterSampleApp
//
//  Created by Sonat Karakas on 1/4/13.
//  Copyright (c) 2013 Turkcell. All rights reserved.
//

#import "UpdateServerIntegration.h"
#import "Configuration.h"

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation UpdateServerIntegration

@synthesize delegate,postSelector,receivedData;

+ (UpdateServerIntegration *) initWithDelegate:(id)delegate
                                  postSelector:(SEL)postSelector{
    
    UpdateServerIntegration *updateServerIntegration = [[UpdateServerIntegration alloc] init];
    
    [updateServerIntegration setDelegate:delegate];
    [updateServerIntegration setPostSelector:postSelector];
    [updateServerIntegration setReceivedData:[[NSMutableData alloc] init]];
    
    return updateServerIntegration;
}

- (void) getJsonFromServer:(NSString *)serverURL{
    
    NSDictionary *propertyDictionary = [Configuration getCurrentConfiguration];
    
    NSString *url = [NSString stringWithFormat:@"%@?appPackageName=%@&deviceOsName=%@",serverURL,[propertyDictionary valueForKey:KEY_APP_PACKAGE_NAME],[propertyDictionary valueForKey:KEY_DEVICE_OS_NAME]];
    
    //NSString *url = @"http://localhost/phptest/redirect.php";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                            timeoutInterval:20];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    if (!connection) {
        [delegate performSelector:postSelector withObject:nil withObject:nil];
    }
}

- (void) getJsonFromServerWithoutParameters:(NSString *)serverURL{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:serverURL]
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                            timeoutInterval:20];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    if (!connection) {
        [delegate performSelector:postSelector withObject:nil withObject:nil];
    }
}

- (void) getJsonFromServerByPostingProperties:(NSString *)serverURL{
    NSDictionary *propertyDictionary = [Configuration getCurrentConfiguration];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:@{
                                             KEY_APP_PACKAGE_NAME: [propertyDictionary valueForKey:KEY_APP_PACKAGE_NAME],
                                             KEY_APP_VERSION_NAME: [propertyDictionary valueForKey:KEY_APP_VERSION_NAME],
                                             KEY_DEVICE_OS_VERSION: [propertyDictionary valueForKey:KEY_DEVICE_OS_VERSION],
                                             KEY_DEVICE_OS_NAME: [propertyDictionary valueForKey:KEY_DEVICE_OS_NAME],
                                             KEY_DEVICE_MODEL: [propertyDictionary valueForKey:KEY_DEVICE_MODEL],
                                             KEY_DEVICE_IS_TABLET: [propertyDictionary valueForKey:KEY_DEVICE_IS_TABLET],
                                             KEY_DEVICE_LANGUAGE: [propertyDictionary valueForKey:KEY_DEVICE_LANGUAGE]
                                             }
                        options:0
                        error:&error];
    if (!jsonData)
        return;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:serverURL]
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                            timeoutInterval:20];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ld", (long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    if (!connection) {
        [delegate performSelector:postSelector withObject:nil withObject:nil];
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse {
    
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [delegate performSelector:postSelector withObject:nil withObject:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *error;
    
#ifdef DEBUG
    NSString *jsonString =    @"{"
        "\"packageName\":\"com.turkcell.TurkcellUpdater\","
        "\"successMsg\":\"Ok\","
        "\"updates\":["
                   "{"
                       "\"filters\": {"
                           "\"appVersionName\":\"<=2.7\""
                       "},"
                       "\"forceUpdate\":\"true\","
                       "\"forceExit\":\"false\","
                       "\"targetWebsiteUrl\": \"https://itunes.apple.com/tr/app/turkcell-online-kamera/id724524441?mt=8\","
                       "\"descriptions\":{"
                           "\"en\":{"
                               "\"message\":\"There is a new version.\","
                               "\"warnings\":\"Please update your application.\""
                           "},"
                           "\"*\":{  "
                               "\"message\":\"Yeni versiyon tespit edildi.\","
                               "\"warnings\":\"Lütfen. Güncelleme yapınız.\""
                           "}"
                       "}"
                   "}"
                   "]"
    "}";
    
    receivedData = [[jsonString dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
#endif
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&error];
    
    NSLog(@"dict %@", json.description);
    
    if (json == nil) {
        
        //NSLog(@"dict %@", json.description);
        
        error = [[NSError alloc] initWithDomain:@"JSON_DATA_SERIALIZATION" code:-1 userInfo:nil];
        [delegate performSelector:postSelector withObject:nil withObject:error];
    }else{
        [delegate performSelector:postSelector withObject:json withObject:nil];
    }
    
}

@end
