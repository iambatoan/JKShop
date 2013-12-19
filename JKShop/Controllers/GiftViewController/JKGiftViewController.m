//
//  JKGiftViewController.m
//  JKShop
//
//  Created by Toan Slan on 12/19/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKGiftViewController.h"

static int const NOTIF_VIEW_HEIGHT = 40;

@interface JKGiftViewController ()
<
CLLocationManagerDelegate
>

@property (weak, nonatomic) IBOutlet UIView *shakeNotificationView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation JKGiftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Lucky Gift";
    [self showNotificationView];
    [self setUpLocationManager];
}

- (void)setUpLocationManager{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        CLLocation *shopLocation = [[CLLocation alloc] initWithLatitude:SETTINGS_JK_SHOP_LATITUDE longitude:SETTINGS_JK_SHOP_LONGITUDE];
        CLLocationDistance dist = [currentLocation distanceFromLocation:shopLocation];
        int kilometers = dist/1000;
        DLog(@"%i",kilometers);
    }
}

- (void)showNotificationView{
    CGRect frame = self.shakeNotificationView.frame;
    frame.origin.y -= NOTIF_VIEW_HEIGHT;
    [UIView animateWithDuration:0.3f
                          delay:0.5
                        options:UIViewAnimationOptionCurveLinear
                     animations:^
    {
        self.shakeNotificationView.frame = frame;
    }
                     completion:nil];
}

- (void)hideNotificationView
{
    CGRect frame = self.shakeNotificationView.frame;
    frame.origin.y += NOTIF_VIEW_HEIGHT;
    [UIView animateWithDuration:0.3f
                     animations:^
     {
         self.shakeNotificationView.frame = frame;
     }
                     completion:nil];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        [self hideNotificationView];
    }
    
}

@end
