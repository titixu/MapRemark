//
//  MRMapViewController.m
//  MapRemark
//
//  Created by SamXu on 18/7/17.
//  Copyright © 2017 AnXu. All rights reserved.
//

#import "MRMapViewController.h"
#import "MRNote.h"
#import "MRNoteFactory.h"
#import "MRDBInteractor.h"
#import "MRNoteAnnotation.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MRNoteViewController.h"
#import "UIAlertController+MRAlerts.h"

@import Firebase;
@import FirebaseAuth;

static NSString *MRShowNoteViewControllerSegueIdentifier = @"MRShowNoteViewControllerSegueIdentifier";

@interface MRMapViewController () <UISearchBarDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MRDBInteractor *DBInteractor;

@property (nonatomic, strong) MRNoteAnnotation *selectedNoteAnnotation;

@end

@implementation MRMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [FIRAuth auth].currentUser.displayName;
    
    //start updating user current location
    [self.locationManager startUpdatingLocation];
    
    //show the user current location
    [self showMyLocation];
    
    //default show user's notes
    [self loadAnnotationsForKeyword:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //passing the "note" instance into MRNoteViewController before show it
    if ([segue.identifier isEqualToString:MRShowNoteViewControllerSegueIdentifier]) {
        MKPinAnnotationView *view = sender;
        if ([view isKindOfClass:[MKPinAnnotationView class]]) {
            MRNoteAnnotation *annotation = view.annotation;
            MRNoteViewController *controller = segue.destinationViewController;
            controller.note = annotation.note;
        }
    }
}

#pragma mark- Getters
//location manager to show current user location
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 500;
        [_locationManager requestWhenInUseAuthorization];
    }
    return _locationManager;
}

//This interactor is "calling" the APIs and update the data base at backend
- (MRDBInteractor *)DBInteractor {
    if (!_DBInteractor) {
        _DBInteractor = [[MRDBInteractor alloc] init];
    }
    return _DBInteractor;
}

#pragma mark- IBActions
//zoom to move to current user location
- (IBAction)myLocationButtonClicked:(UIButton *)sender {
    [self showMyLocation];
}

//The only way for user to add an pin to the map view
- (IBAction)longPress:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateRecognized) {
        //if search is active deacivate the search bar
        if ([self.searchBar isFirstResponder]) {
            [self.searchBar resignFirstResponder];
        } else if(self.searchBar.text.length > 0) {
            //Only allow adding a pin when no in search mode
            UIAlertController *alertController = [UIAlertController defaultAlertWithTitle:nil message:@"Please, remove all search text before add an new pin to the map"];
            [self presentViewController:alertController animated:YES completion:^{
                [self.searchBar becomeFirstResponder];
            }];
        } else {
            //add pin and update the DB
            CGPoint point = [sender locationInView:self.mapView];
            CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
            MRNote *note = [MRNoteFactory noteForCurrentUserWithCoordinate:coordinate];
            [self.DBInteractor postNote:note];
        }
    }
}

#pragma mark- Private

//show and zoom to user current location
- (void)showMyLocation {
    CLLocation *location = self.locationManager.location;
    if (location) {
        MKCoordinateRegion region  = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500);
        [self.mapView setRegion:region animated:YES];
    }
}

- (void)loadAnnotationsForKeyword:(NSString * _Nullable)keyword {
    [self.DBInteractor fetchAllNotesHandler:^(FIRDataSnapshot * snapshot) {
        //clean out all the existing annotation pins
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *child;
        while (child = [children nextObject]) {
            MRNote *note = [MRNoteFactory noteWithDataSnapshot:child];
            
            //load user's own notes
            if (keyword == nil || [keyword isEqualToString:@""]) {
                if ([note.userid isEqualToString:[FIRAuth auth].currentUser.uid]) {
                    [self.mapView addAnnotation:[MRNoteAnnotation noteAnnotationWithNote:note]];
                }
                
            }
            //search for a note with keyword based on contained text or user-name
            //first get all the note that contain the keyword or user-name match the keyword
            else if ([note.displayName.lowercaseString isEqualToString:keyword.lowercaseString ]
                       ||
                       [note.body.lowercaseString containsString:keyword.lowercaseString]) {
                
                //only show the match notes when it is public or it is belong to the user
                if (note.pricacy == MRNotesPrivacyPublic || [note.userid isEqualToString:[FIRAuth auth].currentUser.uid]) {
                    [self.mapView addAnnotation:[MRNoteAnnotation noteAnnotationWithNote:note]];
                }
            }
        }
    }];
}

#pragma mark- MKMapView Delegates

//Go to the MENoteViewControoler for viewing or editing the note
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:MRShowNoteViewControllerSegueIdentifier sender:view];
}

//show pin on the map view
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MRNoteAnnotation *noteAnnotation = annotation;
    
    if ([noteAnnotation isKindOfClass:[MRNoteAnnotation class]]) {
        static NSString *annotationViewIdentifier = @"MRNoteAnnotationIdnetifier";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewIdentifier];
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:noteAnnotation reuseIdentifier:annotationViewIdentifier];
            annotationView.animatesDrop = YES;
            annotationView.canShowCallout = YES;
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.rightCalloutAccessoryView = rightButton;
        }
        return annotationView;
    }
    
    return nil;
}

//dismiss the search bar when user moving around the mapview
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //if the search bar was active and the text is empty which mean user had clean the text
    //show default pins
    if (self.searchBar.isFirstResponder && [self.searchBar.text isEqualToString:@""]) {
        [self loadAnnotationsForKeyword:self.searchBar.text];
    }
    [self.searchBar resignFirstResponder];
}

#pragma mark- Search Bar Delegate
//search button clicked start search for notes
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self loadAnnotationsForKeyword:searchBar.text];
}

@end
