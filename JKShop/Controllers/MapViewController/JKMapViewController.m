//
//  JKMapViewController.m
//  JKShop
//
//  Created by admin on 11/30/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKMapViewController.h"
#import "GMDirectionService.h"

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

- (void)viewWillAppear:(BOOL)animated{
    [self.mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context: nil];
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

- (void)drawPolyline
{
    NSString *myLocationString = [NSString stringWithFormat:@"%f,%f",self.mapView.myLocation.coordinate.latitude,self.mapView.myLocation.coordinate.longitude];
    DLog(@"%@",myLocationString);
    NSString *shopLocationString = [NSString stringWithFormat:@"%f,%f",SETTINGS_JK_SHOP_LATITUDE,SETTINGS_JK_SHOP_LONGITUDE];
    
    [[GMDirectionService sharedInstance] getDirectionsFrom:myLocationString
                                                        to:shopLocationString
                                                 succeeded:^(GMDirection *directionResponse)
    {
        if ([directionResponse statusOK]) {
            NSArray *routes = [[directionResponse directionResponse] objectForKey:@"routes"];
            
            GMSPath *path = [GMSPath pathFromEncodedPath:routes[0][@"overview_polyline"][@"points"]];
            GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
            polyline.strokeColor = [UIColor titleColor];
            polyline.strokeWidth = 10.f;
            polyline.geodesic = YES;
            
            polyline.map = self.mapView;

        }
    }
                                                    failed:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"myLocation"] && [object isKindOfClass:[GMSMapView class]])
    {
        [self drawPolyline];
    }
}
@end
