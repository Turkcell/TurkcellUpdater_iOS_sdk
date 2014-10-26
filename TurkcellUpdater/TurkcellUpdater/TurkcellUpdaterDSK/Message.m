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
//  Message.m
//  TurkcellUpdaterSampleApp
//
//  Created by SonatKarakas on 1/9/13.
//  Copyright (c) 2013 Turkcell. All rights reserved.
//

#import "Message.h"

@implementation Message

+ (NSString *) getMessage:(NSString *)messageType{
    
    NSString *message;
    
    if ([messageType isEqualToString:@"update_required"]) {
        message = @"Güncelleme gerekli";
    }
    
    if ([messageType isEqualToString:@"update_found"]) {
        message = @"Güncelleme bulundu";
    }

    if ([messageType isEqualToString:@"install_"]) {
        message = @"Kur";
    }

    if ([messageType isEqualToString:@"downloading_new_version"]) {
        message = @"Yeni versiyon indiriliyor...";
    }

    if ([messageType isEqualToString:@"exit_application"]) {
        message = @"Uygulamadan çık";
    }

    if ([messageType isEqualToString:@"remind_me_later"]) {
        message = @"Daha sonra hatırlat";
    }

    if ([messageType isEqualToString:@"error_occured"]) {
        message = @"Hata oluştu";
    }

    if ([messageType isEqualToString:@"update_couldn_t_be_completed"]) {
        message = @"Güncelleme tamamlanamadı";
    }

    if ([messageType isEqualToString:@"continue_"]) {
        message = @"Devam et";
    }

    if ([messageType isEqualToString:@"view"]) {
        message = @"Görüntüle";
    }

    if ([messageType isEqualToString:@"close"]) {
        message = @"Kapat";
    }

	if ([messageType isEqualToString:@"service_is_not_available"]) {
        message = @"Hizmet kullanılamıyor";
    }

    if ([messageType isEqualToString:@"launch"]) {
        message = @"Çalıştır";
    }

    if (message == nil)
        return nil;
    else
        return message;
    
}

@end
