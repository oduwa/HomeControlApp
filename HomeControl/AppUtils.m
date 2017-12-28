//
//  AppUtils.m
//  HomeControl
//
//  Created by Odie Edo-Osagie on 10/09/2017.
//  Copyright © 2017 Odie Edo-Osagie. All rights reserved.
//

#import "AppUtils.h"

//#define LightServiceUUID_LOWER @"ff51b30e-d7e2-4d93-8842-a7c4a57dfb07"
//#define LightServiceUUID_UPPER @"FF51B30E-D7E2-4D93-8842-A7C4A57DFB09"

#define LIGHT_SERVICE_UUID_LOWER @"ff51b30e-d7e2-4d93-8842-a7c4a57dfb07"
#define LIGHT_SERVICE_UUID_UPPER @"FF51B30E-D7E2-4D93-8842-A7C4A57DFB07"
#define ADDRESS_CHARACTERISTIC_UUID @"ff51b30e-d7e2-4d93-8842-a7c4a57dfb09"
#define LIGHT_COMMAND_CHARACTERISTIC_UUID @"ff51b30e-d7e2-4d93-8842-a7c4a57dfb10"

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
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:title message:message delegate:vc cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.tag = tag;
    [alert show];
}

+ (BOOL) isUUIDInServiceList:(CBUUID *)uuid
{
    NSArray *services = @[[CBUUID UUIDWithString:LIGHT_SERVICE_UUID_LOWER],[CBUUID UUIDWithString:LIGHT_SERVICE_UUID_UPPER]];
    
    for(CBUUID *servUuid in services){
        if([uuid isEqual:servUuid]){
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL) isUUIDReadCharacteristic:(CBUUID *)uuid
{
    NSArray *services = @[[CBUUID UUIDWithString:ADDRESS_CHARACTERISTIC_UUID]];
    
    for(CBUUID *servUuid in services){
        if([uuid isEqual:servUuid]){
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL) isUUIDWriteCharacteristic:(CBUUID *)uuid
{
    NSArray *services = @[[CBUUID UUIDWithString:LIGHT_COMMAND_CHARACTERISTIC_UUID]];
    
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

+ (UIColor *) colorWithHexString: (NSString *) hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    
    if([hexString isEqualToString:@"nil"]){
        colorString = @"";
    }
    
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        case 0: // nil
            return [UIColor whiteColor];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@end
