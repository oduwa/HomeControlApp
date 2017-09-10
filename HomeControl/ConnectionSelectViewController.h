//
//  ConnectionSelectViewController.h
//  HomeControl
//
//  Created by Odie Edo-Osagie on 10/09/2017.
//  Copyright © 2017 Odie Edo-Osagie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ConnectionSelectViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CBPeripheralDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) NSMutableArray<NSDictionary<NSString *,CBPeripheral *> *> *discoveredPeripherals;

- (void) addDiscoveredPeripheral:(CBPeripheral *)peripheral withLocalName:(NSString *)localName;

@end
