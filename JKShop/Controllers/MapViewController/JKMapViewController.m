//
//  JKMapViewController.m
//  JKShop
//
//  Created by admin on 11/30/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKMapViewController.h"

@interface JKMapViewController ()
<
GMSMapViewDelegate
>

@property (strong, nonatomic) GMSMapView *mapView;

@end

@implementation JKMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [SVProgressHUD dismiss];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"Map";
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self initializeMapView];
}

- (void)initializeMapView
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:SETTINGS_JK_SHOP_LATITUDE
                                                            longitude:SETTINGS_JK_SHOP_LONGITUDE
                                                                 zoom:17];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.delegate = self;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(SETTINGS_JK_SHOP_LATITUDE, SETTINGS_JK_SHOP_LONGITUDE);
    marker.title = @"JK Shop";
    marker.snippet = JK_SHOP_MAP_SNIPPET;
    marker.map = self.mapView;
    self.mapView.mapType = kGMSTypeNormal;
    
    [self.mapView setSelectedMarker:marker];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = self.mapView;
}

@end
