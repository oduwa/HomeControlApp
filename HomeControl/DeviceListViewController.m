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
#import "LightControlViewController.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "AppUtils.h"

//#define LightServiceUUID @"1e0ca4ea-299d-4335-93eb-27fcfe7fa848"
#define LIGHT_SERVICE_UUID @"ff51b30e-d7e2-4d93-8842-a7c4a57dfb07"


@interface DeviceListViewController (){
    NSArray *services;
    BOOL isBluetoothOn;
    UIColor *collectionViewTintColor;
    CBPeripheral *currentlySelectedPeripheral;
    CBCharacteristic *writeCharacteristic;
    CBCharacteristic *readCharacteristic;
}

@property (strong, nonatomic) ConnectionSelectViewController *connectionSelectVC;

@end

@implementation DeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.discoveredPeripherals = [NSMutableArray new];
    
    /* Nav bar title */
    UILabel *titleView = [[UILabel alloc] init];
    titleView.text = @"HomeControl";
    titleView.textColor = [AppUtils colorWithHexString:@"545677"];//310A31
    titleView.font = [UIFont fontWithName:@"Sacramento-Regular" size:34.0];
    [titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    
    // Style
    self.view.backgroundColor = self.collectionView.backgroundColor = [AppUtils colorWithHexString:@"#29272f"];
    self.navigationController.navigationBar.barTintColor = [AppUtils colorWithHexString:@"#7EF98C"];//[AppUtils colorWithHexString:@"#FFC857"];
    self.navigationController.navigationBar.translucent = NO;
    collectionViewTintColor = [AppUtils colorWithHexString:@"#7EF98C"];
    self.segmentedControl.tintColor = [AppUtils colorWithHexString:@"#7EF98C"];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    services = @[[CBUUID UUIDWithString:LIGHT_SERVICE_UUID]];
    
    
    // Pull to refresh
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.alwaysBounceVertical = YES;
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.tintColor = collectionViewTintColor;
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    
    // Content
    [self.centralManager scanForPeripheralsWithServices:services options:nil];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDeviceAddedNotification) name:K_DEVICE_ADDED_NOTIFICATION object:nil];
    
    /* Make sure that this VC is the delegate for all its discovered peripherals */
    for(CBPeripheral *peripheral in self.discoveredPeripherals){
        peripheral.delegate = self;
    }
    readCharacteristic = nil;
    writeCharacteristic = nil;
    if(currentlySelectedPeripheral) [self.centralManager cancelPeripheralConnection:currentlySelectedPeripheral];
}


# pragma mark - Actions

- (void) refresh
{
//    [self fetchSavedDevices];
//
//    // Monitor device's reachability so that its not shown when its off.
//    __block int numberFinished = 0;
//    for(NSMutableDictionary *device in self.savedDevices){
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//        NSString *urlString = [NSString stringWithFormat:@"http://%@/",device[@"deviceAddress"]];
//        [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                device[@"isReachable"] = @YES;
//                [self.collectionView reloadData];
//                numberFinished++;
//                if(numberFinished == self.savedDevices.count){
//                    [self.refreshControl endRefreshing];
//                }
//            });
//        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                device[@"isReachable"] = @NO;
//                [self.collectionView reloadData];
//                numberFinished++;
//                if(numberFinished == self.savedDevices.count){
//                    [self.refreshControl endRefreshing];
//                }
//            });
//        }];
//    }
    
    self.discoveredPeripherals = [NSMutableArray new];
    
    if(isBluetoothOn){
        [self.centralManager scanForPeripheralsWithServices:services options:nil];
    }
    else{
        [AppUtils showAlertWithTitle:@"HomeControl" body:@"An error occured. Please ensure that bluetooth is on" inViewController:self];
    }
}

- (void) transitionToLightControlVC
{
    LightControlViewController *lcvc = [self.storyboard instantiateViewControllerWithIdentifier:@"LightControlViewController"];
    lcvc.periphal = currentlySelectedPeripheral;
    lcvc.writeCharacteristic = writeCharacteristic;
    lcvc.readCharacteristic = readCharacteristic;
    lcvc.periphal.delegate = lcvc;
    [self.navigationController pushViewController:lcvc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CBCentralManagerDelegate

// method called whenever you have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [peripheral discoverServices:nil];
    NSString *result = [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
    NSLog(@"%@", result);
}

// CBCentralManagerDelegate - This is called with the CBPeripheral class as its main input parameter. This contains most of the information there is to know about a BLE peripheral.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if ([localName length] > 0 && [localName containsString:@"HomeControl"]) {
        NSLog(@"Found BLuetooth Peripheral: %@", localName);
        [self.centralManager stopScan];
        // TODO: DONT STOP SCAN HERE. STOP TIMER AFTER A SPECIFIED TIME LIKE IN ANDROID
        //[self.connectionSelectVC addDiscoveredPeripheral:peripheral withLocalName:localName];
        self.peripheral = peripheral;
        [self.discoveredPeripherals addObject:peripheral];
        peripheral.delegate = self;
        [self.collectionView reloadData];
        [self.refreshControl endRefreshing];
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
    // Check if peripheral has a supported service
    if([AppUtils isUUIDInServiceList:service.UUID])  {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            if([AppUtils isUUIDReadCharacteristic:aChar.UUID]) {
                readCharacteristic = aChar;
            }
            
            if([AppUtils isUUIDWriteCharacteristic:aChar.UUID]) {
                writeCharacteristic = aChar;
                [self transitionToLightControlVC];
            }
        }
    }
}

// Invoked when you retrieve a specified characteristic's value, or when the peripheral device notifies your app that the characteristic's value has changed.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{

}


# pragma mark - Helper


# pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([self.discoveredPeripherals count] == 0){
        return 1;
    }
    else{
        return [self.discoveredPeripherals count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addDeviceCell" forIndexPath:indexPath];
    cell.activatedCellColor = collectionViewTintColor;
    
    
    if([self.discoveredPeripherals count] == 0){
        if(indexPath.row == 0){
            cell.deviceImageView.image = [UIImage imageNamed:@"plus_math"];
            cell.deviceTitleLabel.text = @"";
            cell.isAddCell = YES;
            cell.hidden = NO;
            cell.deviceImageView.image = [cell.deviceImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.deviceImageView setTintColor:collectionViewTintColor];
        }
    }
    else{
        CBPeripheral *peripheral = self.discoveredPeripherals[indexPath.row];
        cell.deviceImageView.image = [UIImage imageNamed:@"light_on"];
        cell.deviceTitleLabel.text = peripheral.name;
        cell.isAddCell = NO;
        cell.hidden = NO;
        cell.deviceImageView.image = [cell.deviceImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cell.deviceImageView setTintColor:collectionViewTintColor];
    }
    
    
    return cell;
}

# pragma mark - UICollectionView Delegate

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    DeviceListCollectionViewCell *cell = [self collectionView:self.collectionView cellForItemAtIndexPath:indexPath];
    
    if(cell.isAddCell){
        [self refresh];
        
//        self.connectionSelectVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ConnectionSelectViewController"];
//        self.connectionSelectVC.discoveredPeripherals = [NSMutableArray new];
//        self.connectionSelectVC.centralManager = self.centralManager;
//        MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:self.connectionSelectVC];
//        formSheetController.presentationController.contentViewSize = CGSizeMake(250, 250); // or pass in UILayoutFittingCompressedSize to size automatically with auto-layout
//        formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
//        formSheetController.presentationController.shouldCenterVertically = YES;
//        formSheetController.presentationController.shouldApplyBackgroundBlurEffect = YES;
//        [self presentViewController:formSheetController animated:YES completion:nil];
    }
    else{
//        NSDictionary *device = self.savedDevices[indexPath.row];
//
//        if([device[@"isReachable"] boolValue] == YES){
//            LightControlViewController *lcvc = [self.storyboard instantiateViewControllerWithIdentifier:@"LightControlViewController"];
//            lcvc.deviceAddress = device[@"deviceAddress"];
//            [self.navigationController pushViewController:lcvc animated:YES];
//        }
//        else{
//            [AppUtils showAlertWithTitle:@"HomeControl" body:@"That device is currently unavailable. Please ensure that it is powered on" inViewController:self];
//        }
        
        CBPeripheral *peripheral = self.discoveredPeripherals[indexPath.row];
        currentlySelectedPeripheral = peripheral;
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}


@end
