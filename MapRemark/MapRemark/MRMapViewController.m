//
//  MRMapViewController.m
//  MapRemark
//
//  Created by SamXu on 18/7/17.
//  Copyright © 2017 AnXu. All rights reserved.
//

#import "MRMapViewController.h"
@import MapKit;
@import CoreLocation;
@import Firebase;

@interface MRMapViewController () <UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) FIRDatabaseReference *DBRef;


@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation MRMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.locationManager startUpdatingLocation];
    [self showMyLocation];
}

#pragma mark- Getters
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 500;
        [_locationManager requestWhenInUseAuthorization];
    }
    return _locationManager;
}

- (FIRDatabaseReference *)DBRef {
    if (!_DBRef) {
        _DBRef = [[FIRDatabase database] reference];
    }
    return _DBRef;
}

#pragma mark- IBActions

- (IBAction)myLocationButtonClicked:(UIButton *)sender {
    [self showMyLocation];
}

#pragma mark- CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    NSDate *date = location.timestamp;
    if (fabs(date.timeIntervalSinceNow) < 20.0)  {
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
}

#pragma mark- Private

- (void)showMyLocation {
    CLLocation *location = self.locationManager.location;
    if (location) {
        MKCoordinateRegion region  = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500);
        [self.mapView setRegion:region animated:YES];
    }
}

@end
