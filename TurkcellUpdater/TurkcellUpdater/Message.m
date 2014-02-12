//
//  Message.m
//  TurkcellUpdaterSampleApp
//
//  Created by SonatKarakas on 1/9/13.
//  Copyright (c) 2013 Sonat Karakas. All rights reserved.
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
