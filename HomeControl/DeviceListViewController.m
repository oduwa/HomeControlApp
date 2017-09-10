//
//  DeviceListViewController.m
//  HomeControl
//
//  Created by Odie Edo-Osagie on 09/09/2017.
//  Copyright © 2017 Odie Edo-Osagie. All rights reserved.
//

#import "DeviceListViewController.h"
#import "DeviceListCollectionViewCell.h"
#import "ConnectionSelectViewController.h"
#import "MZFormSheetPresentationViewController.h"
#import "AppUtils.h"

//#define LightServiceUUID @"1e0ca4ea-299d-4335-93eb-27fcfe7fa848"
#define LightServiceUUID_LOWER @"ff51b30e-d7e2-4d93-8842-a7c4a57dfb07"
#define LightServiceUUID_UPPER @"FF51B30E-D7E2-4D93-8842-A7C4A57DFB09"


@interface DeviceListViewController (){
    NSArray *services;
    BOOL isBluetoothOn;
}

@property (strong, nonatomic) ConnectionSelectViewController *connectionSelectVC;

@end

@implementation DeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.view.backgroundColor = self.collectionView.backgroundColor;
    
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    services = @[[CBUUID UUIDWithString:LightServiceUUID_LOWER],[CBUUID UUIDWithString:LightServiceUUID_UPPER]];
    //CBUUID *x = [CBUUID UUIDWithString:LightServiceUUID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CBCentralManagerDelegate

// method called whenever you have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //[peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    NSString *result = [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
    NSLog(@"%@", result);
}

// CBCentralManagerDelegate - This is called with the CBPeripheral class as its main input parameter. This contains most of the informat ion there is to know about a BLE peripheral.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if ([localName length] > 0) {
        NSLog(@"Found BLuetooth Peripheral: %@", localName);
        [self.centralManager stopScan];
        [self.connectionSelectVC addDiscoveredPeripheral:peripheral withLocalName:localName];
        // TODO: Dont stop scan. Discover all peripherals with required service for a specified time
        self.peripheral = peripheral;
        //peripheral.delegate = self;
        //[self.centralManager connectPeripheral:peripheral options:nil];
    }
}

// method called whenever the device state changes.
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    // Determine the state of the peripheral
    if ([central state] == CBCentralManagerStatePoweredOff) {
        NSLog(@"CoreBluetooth BLE hardware is powered off");
    }
    else if ([central state] == CBCentralManagerStatePoweredOn) {
        NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
        isBluetoothOn = YES;
    }
    else if ([central state] == CBCentralManagerStateUnauthorized) {
        NSLog(@"CoreBluetooth BLE state is unauthorized");
    }
    else if ([central state] == CBCentralManagerStateUnknown) {
        NSLog(@"CoreBluetooth BLE state is unknown");
    }
    else if ([central state] == CBCentralManagerStateUnsupported) {
        NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
    }
}

//#pragma mark - CBPeripheralDelegate
//
//// CBPeripheralDelegate - Invoked when you discover the peripheral's available services.
//- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
//{
//    for (CBService *service in peripheral.services) {
//        NSLog(@"Discovered service: %@", service.UUID);
//        [peripheral discoverCharacteristics:nil forService:service];
//    }
//}
//
//// Invoked when you discover the characteristics of a specified service.
//- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
//{
//    if([self isUUIDInServiceList:service.UUID])  {
//        for (CBCharacteristic *aChar in service.characteristics)
//        {
//            // Request device address
//            if([self isUUIDInServiceList:aChar.UUID]) {
//                [self.peripheral readValueForCharacteristic:aChar];
//                NSLog(@"Found body sensor location characteristic");
//            }
//        }
//    }
//}
//
//// Invoked when you retrieve a specified characteristic's value, or when the peripheral device notifies your app that the characteristic's value has changed.
//- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
//{
//    // Updated value for heart rate measurement received
//    if([self isUUIDInServiceList:characteristic.UUID]) { // 1
//        // Get the device address
//        NSString *addr = [self getDeviceAddressFromCharacteristic:characteristic];;
//        NSLog(@"Found device ip address: %@", addr);
//    }
//}

# pragma mark - Helper

- (NSString *) getDeviceAddressFromCharacteristic:(CBCharacteristic *)characteristic
{
    NSString *address = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];  // 1
    return address;
}

- (BOOL) isUUIDInServiceList:(CBUUID *)uuid
{
    for(CBUUID *servUuid in services){
        if([uuid isEqual:servUuid]){
            return YES;
        }
    }
    
    return NO;
}

# pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addDeviceCell" forIndexPath:indexPath];
    
    cell.deviceTitleLabel.text = @"hello";
    
    return cell;
}

# pragma mark - UICollectionView Delegate

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if(isBluetoothOn){
        [self.centralManager scanForPeripheralsWithServices:services options:nil];
    }
    else{
        [AppUtils showAlertWithTitle:@"HomeControl" body:@"An error occured. Please ensure that bluetooth is on" inViewController:self];
    }
    
    self.connectionSelectVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ConnectionSelectViewController"];
    self.connectionSelectVC.discoveredPeripherals = [NSMutableArray new];
    self.connectionSelectVC.centralManager = self.centralManager;
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:self.connectionSelectVC];
    formSheetController.presentationController.contentViewSize = CGSizeMake(250, 250); // or pass in UILayoutFittingCompressedSize to size automatically with auto-layout
    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
    formSheetController.presentationController.shouldCenterVertically = YES;
    formSheetController.presentationController.shouldApplyBackgroundBlurEffect = YES;
    [self presentViewController:formSheetController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
