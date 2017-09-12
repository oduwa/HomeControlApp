//
//  ConnectionSelectViewController.m
//  HomeControl
//
//  Created by Odie Edo-Osagie on 10/09/2017.
//  Copyright © 2017 Odie Edo-Osagie. All rights reserved.
//

#import "ConnectionSelectViewController.h"
#import "AppUtils.h"

@interface ConnectionSelectViewController (){
    NSIndexPath *selectedIndexPath;
}

@end

@implementation ConnectionSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Public

- (void) addDiscoveredPeripheral:(CBPeripheral *)peripheral withLocalName:(NSString *)localName
{
    [self.discoveredPeripherals addObject:@{localName:peripheral}];
    peripheral.delegate = self;
    [self.tableView reloadData];
}

# pragma mark - Helper

- (NSString *) getDeviceAddressFromCharacteristic:(CBCharacteristic *)characteristic
{
    NSString *address = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];  // 1
    return address;
}

#pragma mark - CBPeripheralDelegate

// CBPeripheralDelegate - Invoked when you discover the peripheral's available services.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service: %@", service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if([AppUtils isUUIDInServiceList:service.UUID])  {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            // Request device address
            if([AppUtils isUUIDInServiceList:aChar.UUID]) {
                [peripheral readValueForCharacteristic:aChar];
                NSLog(@"Found body sensor location characteristic");
            }
        }
    }
}

// Invoked when you retrieve a specified characteristic's value, or when the peripheral device notifies your app that the characteristic's value has changed.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    // Updated value for heart rate measurement received
    if([AppUtils isUUIDInServiceList:characteristic.UUID]) {
        // Get the device address
        NSString *addr = [self getDeviceAddressFromCharacteristic:characteristic];;
        NSLog(@"Found device ip address: %@", addr);
        
        // Save address if necessary
        NSDictionary *peripheralDict = self.discoveredPeripherals[selectedIndexPath.row];
        NSMutableDictionary *newDevice = [NSMutableDictionary dictionaryWithDictionary:@{@"deviceName":peripheral.name,
                                                                                         @"deviceServiceName":[peripheralDict allKeys][0],
                                                                                         @"deviceAddress":addr}];
        
        DeviceStoreStatus status = [AppUtils isDeviceAlreadySaved:newDevice];
        
        if(status == DEVICE_STORE_STATUS_NEW || status == DEVICE_STORE_STATUS_UPDATED){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSMutableArray *savedDevices = (NSMutableArray *) [defaults arrayForKey:K_SAVED_DEVICE_STORE];
            if(!savedDevices){
                savedDevices = [NSMutableArray new];
            }
            
            [savedDevices addObject:newDevice];
            [defaults setObject:savedDevices forKey:K_SAVED_DEVICE_STORE];
            [defaults synchronize];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:K_DEVICE_ADDED_NOTIFICATION object:nil userInfo:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

# pragma mark - UITableView DataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.discoveredPeripherals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"connectionSelectCell"];
 
    NSDictionary *peripheralDict = self.discoveredPeripherals[indexPath.row];
    cell.textLabel.text = [(CBPeripheral *)[peripheralDict allValues][0] name];
    cell.detailTextLabel.text = [peripheralDict allKeys][0];
    
    return cell;
}

# pragma mark - UITableView Delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selectedIndexPath = indexPath;
    
    NSDictionary *peripheralDict = self.discoveredPeripherals[indexPath.row];
    [self.centralManager connectPeripheral:[peripheralDict allValues][0] options:nil];
}

@end
