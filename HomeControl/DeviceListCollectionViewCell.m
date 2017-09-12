//
//  DeviceListCollectionViewCell.m
//  HomeControl
//
//  Created by Odie Edo-Osagie on 09/09/2017.
//  Copyright © 2017 Odie Edo-Osagie. All rights reserved.
//

#import "DeviceListCollectionViewCell.h"

@interface DeviceListCollectionViewCell ()
@end


@implementation DeviceListCollectionViewCell

- (void) initialize
{
    self.deactivatedCellColor = [UIColor lightGrayColor];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    [self initialize];

}

- (void) setCellAsDeactivated:(BOOL)isDeactivated
{
    if(isDeactivated){
        self.deviceImageView.image = [self.deviceImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.deviceImageView setTintColor:self.deactivatedCellColor];
        self.deviceTitleLabel.textColor = self.deactivatedCellColor;
    }
    else{
        self.deviceImageView.image = [self.deviceImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.deviceImageView setTintColor:self.activatedCellColor];
        self.deviceTitleLabel.textColor = self.activatedCellColor;
    }
}

@end
