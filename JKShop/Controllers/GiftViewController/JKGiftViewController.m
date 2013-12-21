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
    if (_giftArray == nil) {
        _giftArray = @[@"You got discount 10% on T-Shirt",
                           @"You got discount 10% on Belt",
                           @"You got discount 10% on Jean",
                           @"You got discount 10% on Shoes"];
    }
    return _giftArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Lucky Gift";
    NSString *gift = [[NSUserDefaults standardUserDefaults] valueForKey:kGiftUserDefault];
    if (gift) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"You have a gift for today already! \n\"%@\"",gift]];
        return;
    }
    [self setUpLocationManager];
}

- (void)viewDidAppear:(BOOL)animated{
    [self becomeFirstResponder];
}

- (void)setUpLocationManager{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
//    CLLocation *currentLocation = [locations lastObject];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:SETTINGS_JK_SHOP_LATITUDE longitude:SETTINGS_JK_SHOP_LONGITUDE];
    
    if (currentLocation != nil) {
        CLLocation *shopLocation = [[CLLocation alloc] initWithLatitude:SETTINGS_JK_SHOP_LATITUDE longitude:SETTINGS_JK_SHOP_LONGITUDE];
        CLLocationDistance dist = [currentLocation distanceFromLocation:shopLocation];
        CGFloat kilometers = dist/1000.0;
        [self.locationManager stopUpdatingLocation];
        
        if (kilometers <= 0.5f) {
            [TSMessage showNotificationInViewController:self
                                                  title:@"Shaking your phone to get special gift"
                                               subtitle:nil
                                                  image:nil
                                                   type:TSMessageNotificationTypeMessage
                                               duration:TSMessageNotificationDurationEndless
                                               callback:nil
                                            buttonTitle:nil
                                         buttonCallback:nil
                                             atPosition:TSMessageNotificationPositionBottom
                                    canBeDismisedByUser:NO];
            return;
        }
        [SVProgressHUD showErrorWithStatus:@"You are so far from JK Shop!"];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    DLog(@"%@", error);
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        [TSMessage dismissActiveNotification];
        
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
