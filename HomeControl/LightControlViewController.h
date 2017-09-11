//
//  LightControlViewController.h
//  HomeControl
//
//  Created by Odie Edo-Osagie on 10/09/2017.
//  Copyright © 2017 Odie Edo-Osagie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StepSlider.h"
@import ChromaColorPicker;

@interface LightControlViewController : UIViewController

@property (weak, nonatomic) IBOutlet ChromaColorPicker *colorPicker;
@property (weak, nonatomic) IBOutlet StepSlider *stepSlider;
@property (weak, nonatomic) IBOutlet UISwitch *lightSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *lightImageView;


@property (strong, nonatomic) NSString *deviceAddress;

@end
