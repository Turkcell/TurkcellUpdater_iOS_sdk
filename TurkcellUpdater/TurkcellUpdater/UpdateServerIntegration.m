//
//  UpdateServerIntegration.m
//  TurkcellUpdaterSampleApp
//
//  Created by Sonat Karakas on 1/4/13.
//  Copyright (c) 2013 Sonat Karakas. All rights reserved.
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
    
    DLog(@"RequestUrl:\n%@", url);
    
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
                        KEY_DEVICE_LANGUAGE: [propertyDictionary valueForKey:KEY_DEVICE_LANGUAGE],
                        KEY_DEVICE_ID: [propertyDictionary valueForKey:KEY_DEVICE_ID]
                        }
                        options:0
                        error:&error];
    if (!jsonData) {
        DLog(@"JSON error: %@", error);
        return;
    }
    
    DLog(@"RequestBody:\n%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:serverURL]
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                            timeoutInterval:20];
        
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
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
    
    DLog(@"ResponseBody:\n%@", [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&error];
    
    if (json == nil) {
        error = [[NSError alloc] initWithDomain:@"JSON_DATA_SERIALIZATION" code:-1 userInfo:nil];
        [delegate performSelector:postSelector withObject:nil withObject:error];
    }else{
        [delegate performSelector:postSelector withObject:json withObject:nil];
    }
    
}

@end
