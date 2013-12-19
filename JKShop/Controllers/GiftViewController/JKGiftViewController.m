//
//  JKGiftViewController.m
//  JKShop
//
//  Created by Toan Slan on 12/19/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKGiftViewController.h"

static int const NOTIF_VIEW_HEIGHT = 40;
static NSString * const kGiftUserDefault = @"kGiftUserDefault";

@interface JKGiftViewController ()
<
CLLocationManagerDelegate
>

@property (weak, nonatomic) IBOutlet UIView *shakeNotificationView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray *giftArray;

@end

@implementation JKGiftViewController

- (NSArray *)giftArray{
    if (self.giftArray == nil) {
        self.giftArray = [[NSArray alloc] init];
        self.giftArray = @[@"You got discount 10% on T-Shirt",
                           @"You got discount 10% on Belt",
                           @"You got discount 10% on Jean",
                           @"You got discount 10% on Shoes"];
    }
    return self.giftArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Lucky Gift";
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
//    CLLocation *currentLocation = newLocation;
    
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:10.778445 longitude:106.666297];
    
    if (currentLocation != nil) {
        CLLocation *shopLocation = [[CLLocation alloc] initWithLatitude:SETTINGS_JK_SHOP_LATITUDE longitude:SETTINGS_JK_SHOP_LONGITUDE];
        CLLocationDistance dist = [currentLocation distanceFromLocation:shopLocation];
        CGFloat kilometers = dist/1000.0;
        [self.locationManager stopUpdatingLocation];
        
        if (kilometers <= 0.5f && ![[NSUserDefaults standardUserDefaults] valueForKey:kGiftUserDefault]) {
            [self showNotificationView];
            return;
        }
        if (kilometers > 0.5f) {
            [SVProgressHUD showErrorWithStatus:@"You are so far from JK Shop!"];
            return;
        }
        
        [SVProgressHUD showErrorWithStatus:@"You have a gift for today already!"];
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
        
        NSInteger rand = [self randomIntegerFrom:0 to:3];
        [self showAlertViewWithContent:self.giftArray[rand]];
        
        [[NSUserDefaults standardUserDefaults] setValue:self.giftArray[rand] forKey:kGiftUserDefault];
    }
    
}

- (void)showAlertViewWithContent:(NSString *)content
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulation!"
                                                    message:[NSString stringWithFormat:@"%@ for today",content]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (NSInteger)randomIntegerFrom:(NSInteger)min to:(NSInteger)max{
    return ((arc4random() % (max-min+1)) + min);
}

@end
