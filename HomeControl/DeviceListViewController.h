//
//  DeviceListViewController.h
//  HomeControl
//
//  Created by Odie Edo-Osagie on 09/09/2017.
//  Copyright © 2017 Odie Edo-Osagie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface DeviceListViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,CBCentralManagerDelegate,CBPeripheralDelegate>


@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) NSMutableArray *savedDevices;

@property (nonatomic, strong) NSMutableArray<CBPeripheral *> *discoveredPeripherals;

@end
