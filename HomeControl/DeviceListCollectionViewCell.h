//
//  DeviceListCollectionViewCell.h
//  HomeControl
//
//  Created by Odie Edo-Osagie on 09/09/2017.
//  Copyright © 2017 Odie Edo-Osagie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceListCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceTitleLabel;

@property (assign, nonatomic) BOOL isAddCell;

@end
