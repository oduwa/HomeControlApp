//
//  LightControlViewController.m
//  HomeControl
//
//  Created by Odie Edo-Osagie on 10/09/2017.
//  Copyright © 2017 Odie Edo-Osagie. All rights reserved.
//

#import "LightControlViewController.h"

@interface LightControlViewController (){
    float r;
    float g;
    float b;
    float brightness;
}

@end

@implementation LightControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Color picker
    self.colorPicker.padding = 5;
    self.colorPicker.stroke = 3;
    self.colorPicker.hexLabel.textColor = [UIColor whiteColor];
    self.colorPicker.hexLabel.hidden = YES;
    self.colorPicker.addButton.plusIconLayer.hidden = YES;
    [self.colorPicker addTarget:self action:@selector(colorPickerDidChangeColor) forControlEvents:UIControlEventEditingDidEnd];
    
    // Brightness picker
    [self.stepSlider addTarget:self action:@selector(sliderDidChangeValue) forControlEvents:UIControlEventValueChanged];
    
    // Defaults
    r = 255.0;
    g = 255.0;
    b = 255.0;
    brightness = 6.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Controls

- (void) colorPickerDidChangeColor
{
    NSLog(@"%@", self.colorPicker.hexLabel.text);
    NSString *hexStr = self.colorPicker.hexLabel.text;
    /* Convert colour from hex to rgb. First convert hex string to an integer */
    unsigned int hexint = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet
                                       characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexint];
    
    // Get colours
    r = (CGFloat) ((hexint & 0xFF0000) >> 16);
    g = (CGFloat) ((hexint & 0xFF00) >> 8);
    b = ((CGFloat) (hexint & 0xFF));
    
    NSLog(@"Selected Colour: (%f,%f,%f)", r,g,b);
}

- (void) sliderDidChangeValue
{
    NSLog(@"Slider value: %lu", self.stepSlider.index+1);
    brightness = (float) self.stepSlider.index+1;
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
