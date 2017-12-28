//
//  AppUtils.h
//  HomeControl
//
//  Created by Odie Edo-Osagie on 10/09/2017.
//  Copyright © 2017 Odie Edo-Osagie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef enum DeviceStoreStatusTypes
{
    DEVICE_STORE_STATUS_UPDATED,
    DEVICE_STORE_STATUS_UNCHANGED,
    DEVICE_STORE_STATUS_NEW
} DeviceStoreStatus;

@interface AppUtils : NSObject

extern NSString *const K_SAVED_DEVICE_STORE;
extern NSString *const K_DEVICE_ADDED_NOTIFICATION;

+ (void) showAlertWithTitle:(NSString *)title
                       body:(NSString *)message
           inViewController:(UIViewController *)vc;

+ (BOOL) isUUIDInServiceList:(CBUUID *)uuid;
+ (BOOL) isUUIDReadCharacteristic:(CBUUID *)uuid;
+ (BOOL) isUUIDWriteCharacteristic:(CBUUID *)uuid;

+ (DeviceStoreStatus) isDeviceAlreadySaved:(NSDictionary *)device;

+ (UIColor *) colorWithHexString: (NSString *) hexString;

@end
