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
#import "AppUtils.h"

//#define LightServiceUUID @"1e0ca4ea-299d-4335-93eb-27fcfe7fa848"
#define LightServiceUUID_LOWER @"ff51b30e-d7e2-4d93-8842-a7c4a57dfb07"
#define LightServiceUUID_UPPER @"FF51B30E-D7E2-4D93-8842-A7C4A57DFB09"


@interface DeviceListViewController (){
    NSArray *services;
    BOOL isBluetoothOn;
    UIColor *collectionViewTintColor;
}

@property (strong, nonatomic) ConnectionSelectViewController *connectionSelectVC;

@end

@implementation DeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    services = @[[CBUUID UUIDWithString:LightServiceUUID_LOWER],[CBUUID UUIDWithString:LightServiceUUID_UPPER]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self fetchSavedDevices];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDeviceAddedNotification) name:K_DEVICE_ADDED_NOTIFICATION object:nil];
}

- (void) didReceiveDeviceAddedNotification
{
    [self fetchSavedDevices];
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


# pragma mark - Helper

- (void) fetchSavedDevices
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.savedDevices = [defaults arrayForKey:K_SAVED_DEVICE_STORE];
    if(!self.savedDevices){
        self.savedDevices = [NSMutableArray new];
    }
    
    [self.collectionView reloadData];
}

# pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([self.savedDevices count] == 0){
        return [self.savedDevices count]+1+1;
    }
    else{
        return [self.savedDevices count]+1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addDeviceCell" forIndexPath:indexPath];
    
    
    if([self.savedDevices count] == 0){
        if(indexPath.row == 0){
            cell.deviceImageView.image = [UIImage imageNamed:@"plus_math"];
            cell.deviceTitleLabel.text = @"";
            cell.isAddCell = YES;
            cell.hidden = NO;
            cell.deviceImageView.image = [cell.deviceImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.deviceImageView setTintColor:collectionViewTintColor];
        }
        else{
            cell.deviceImageView.image = [UIImage imageNamed:@"plus_math"];
            cell.deviceTitleLabel.text = @"";
            cell.isAddCell = NO;
            cell.hidden = YES;
            cell.deviceImageView.image = [cell.deviceImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.deviceImageView setTintColor:collectionViewTintColor];
        }
    }
    else{
        if(indexPath.row < [self.savedDevices count]){
            NSDictionary *device = self.savedDevices[indexPath.row];
            cell.deviceImageView.image = [UIImage imageNamed:@"light_on"];
            cell.deviceTitleLabel.text = device[@"deviceServiceName"];
            cell.isAddCell = NO;
            cell.hidden = NO;
            cell.deviceImageView.image = [cell.deviceImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.deviceImageView setTintColor:collectionViewTintColor];
        }
        else{
            cell.deviceImageView.image = [UIImage imageNamed:@"plus_math"];
            cell.deviceTitleLabel.text = @"";
            cell.isAddCell = YES;
            cell.hidden = NO;
            cell.deviceImageView.image = [cell.deviceImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.deviceImageView setTintColor:collectionViewTintColor];
        }
    }
    
    
    return cell;
}

# pragma mark - UICollectionView Delegate

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    DeviceListCollectionViewCell *cell = [self collectionView:self.collectionView cellForItemAtIndexPath:indexPath];
    
    if(cell.isAddCell){
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
    else{
        LightControlViewController *lcvc = [self.storyboard instantiateViewControllerWithIdentifier:@"LightControlViewController"];
        NSDictionary *device = self.savedDevices[indexPath.row];
        lcvc.deviceAddress = device[@"deviceAddress"];
        [self.navigationController pushViewController:lcvc animated:YES];
    }
}


@end
