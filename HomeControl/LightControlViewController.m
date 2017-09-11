//
//  LightControlViewController.m
//  HomeControl
//
//  Created by Odie Edo-Osagie on 10/09/2017.
//  Copyright © 2017 Odie Edo-Osagie. All rights reserved.
//

#import "LightControlViewController.h"
#import "AppUtils.h"
#import "AFNetworking.h"

@interface LightControlViewController (){
    float r;
    float g;
    float b;
    float brightness;
    NSString *mode;
}

@end

@implementation LightControlViewController

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
    
    /* Nav bar back button */
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [backButton setImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    backButton.tintColor = titleView.textColor;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // Style
    self.view.backgroundColor = [AppUtils colorWithHexString:@"#29272f"];
    //self.navigationController.navigationBar.barTintColor = [AppUtils colorWithHexString:@"#7ef98c"];
    self.lightImageView.image = [self.lightImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.lightImageView setTintColor:[AppUtils colorWithHexString:@"#ffffff"]];
    
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
    brightness = 6.0/10.0;
    mode = @"on";
    // TODO: Check whats in vars.txt and set defaults
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) done
{
    [self.navigationController popViewControllerAnimated:YES];
}

# pragma mark - Controls

- (IBAction)lightSwitchDidChange:(id)sender
{
    if(self.lightSwitch.isOn){
        mode = @"default";
        [self sliderDidChangeValue];
    }
    else{
        brightness = 0;
        [self updateLight];
    }
}

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
    
    if(self.lightSwitch.isOn){
        [self updateLight];
    }
}

- (void) sliderDidChangeValue
{
    NSLog(@"Slider value: %lu", self.stepSlider.index+1);
    brightness = (float) (self.stepSlider.index+1)/10.0;
    
    if(self.lightSwitch.isOn){
        [self updateLight];
    }
}

- (void) updateLight
{
    /* Upload file */
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/NightLight/nightlight.php?r=%d&g=%d&b=%d&mode=%@&brightness=%.1f", self.deviceAddress, (int)r, (int)g, (int)b, @"default", brightness];
    NSLog(@"REQUEST: %@", urlString);
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Sent POST update with response:\n %@", responseString);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
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
