//
//  AppUtils.m
//  HomeControl
//
//  Created by Odie Edo-Osagie on 10/09/2017.
//  Copyright © 2017 Odie Edo-Osagie. All rights reserved.
//

#import "AppUtils.h"

#define LightServiceUUID_LOWER @"ff51b30e-d7e2-4d93-8842-a7c4a57dfb07"
#define LightServiceUUID_UPPER @"FF51B30E-D7E2-4D93-8842-A7C4A57DFB09"

@implementation AppUtils

NSString *const K_SAVED_DEVICE_STORE = @"devices";
NSString *const K_DEVICE_ADDED_NOTIFICATION = @"DEVICE_ADDED_NOTIFICATION";

+ (void) showAlertWithTitle:(NSString *)title
                       body:(NSString *)message
           inViewController:(UIViewController *)vc
{
    [self showAlertWithTitle:title body:message tag:000 inViewController:vc];
}

+ (void) showAlertWithTitle:(NSString *)title
                       body:(NSString *)message
                        tag:(NSInteger)tag
           inViewController:(UIViewController *)vc
{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:title message:message delegate:vc cancelButtonTitle:NSLocalizedString(@"BtnTitle_OK", nil) otherButtonTitles:nil];
    alert.tag = tag;
    [alert show];
}

+ (BOOL) isUUIDInServiceList:(CBUUID *)uuid
{
    NSArray *services = @[[CBUUID UUIDWithString:LightServiceUUID_LOWER],[CBUUID UUIDWithString:LightServiceUUID_UPPER]];
    
    for(CBUUID *servUuid in services){
        if([uuid isEqual:servUuid]){
            return YES;
        }
    }
    
    return NO;
}

+ (DeviceStoreStatus) isDeviceAlreadySaved:(NSDictionary *)device
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *savedDevices = (NSMutableArray *) [defaults arrayForKey:K_SAVED_DEVICE_STORE];
    if(!savedDevices){
        savedDevices = [NSMutableArray new];
    }
    
    for(NSDictionary *savedDevice in savedDevices){
        if([(NSString *)savedDevice[@"deviceName"] isEqualToString:device[@"deviceName"]]){
            if([(NSString *)savedDevice[@"deviceAddress"] isEqualToString:device[@"deviceAddress"]]){
                return DEVICE_STORE_STATUS_UNCHANGED;
            }
            else{
                return DEVICE_STORE_STATUS_UPDATED;
            }
        }
    }
    
    return DEVICE_STORE_STATUS_NEW;
}

@end
