//
//  Filter.h
//  TurkcellUpdaterSampleApp
//
//  Created by Sonat Karakas on 1/16/13.
//  Copyright (c) 2013 Sonat Karakas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Filter : NSObject

+ (NSDictionary *) getMatchedUpdateFromUpdateDataDictionary:(NSDictionary *)updateDataDictionary
                                   withCurrentConfiguration:(NSDictionary *)currentConfiguration;

+ (NSDictionary *) getMatchedMessageFromUpdateDataDictionary:(NSDictionary *)updateDataDictionary
                                   withCurrentConfiguration:(NSDictionary *)currentConfiguration;

@end
