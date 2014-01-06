//
//  WhereamiViewController.m
//  Whereami
//
//  Created by Tim Brandt on 1/5/14.
//  Copyright (c) 2014 Tim Brandt. All rights reserved.
//

#import "WhereamiViewController.h"
#import "BNRMapPoint.h"

@interface WhereamiViewController ()

@end

@implementation WhereamiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"InitWithNibName");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.view.hidden = NO;
    
    if (self) {
        // Create location manager object
        locationManager = [[CLLocationManager alloc] init];
        
        // There will be a warning from this line of code; ignore it for now
        [locationManager setDelegate:self];
        
        // And we want it to be as accurate as possible
        // regardless of how much time/power it takeds
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        // Tell our manager to start looking for its location immediately
        //        [locationManager startUpdatingLocation];
    }
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    CLLocation *oldLocation;
    
    if (locations.count > 1) {
        oldLocation = [locations objectAtIndex:locations.count-2];
    } else {
        oldLocation = nil;
    }
    
    // How many seconds ago was this new location created?
    NSTimeInterval t = [[newLocation timestamp] timeIntervalSinceNow];
    
    // CLLocationmanagers will return the last found location of the
    // device first, you don't want that data in this case.
    // If this location was made more than 3 minutes ago, ignore it
    if (t < -180) {
        // This is cached data, you don't want it, keep looking
        return;
    }
    
    [self foundLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@", error);
}

- (void)dealloc
{
    //Tell the locaiton manager to stop sending messages
    [locationManager setDelegate:Nil];
}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    [worldView setShowsUserLocation:TRUE];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MKMapView Delegate Functions
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    [worldView setRegion:region animated:TRUE];
}

// UITextField Delegate Functions
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self findLocation];
    
    // remove keyboard from screen, active UITextField is no longer first repsponder
    [textField resignFirstResponder];
    
    return TRUE;
}

- (void)findLocation
{
    NSLog(@"findLocation");
    [locationManager startUpdatingLocation];
    [activityIndicator startAnimating];
    [locationTitleField setHidden:TRUE];
}

- (void)foundLocation:(CLLocation *)loc
{
    NSLog(@"foundLocation");
    CLLocationCoordinate2D coord = [loc coordinate];
    
    // Create an instance of BNRMapPoint with the current data
    BNRMapPoint *mp = [[BNRMapPoint alloc] initWithCoordinate:coord title:[locationTitleField text]];
    
    // Add it to the map view
    [worldView addAnnotation:mp];
    
    // Zooom region to this location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    [worldView setRegion:region animated:TRUE];
    
    // Reset the UI
    [locationTitleField setText:@""];
    [activityIndicator stopAnimating];
    [locationTitleField setHidden:FALSE];
    [locationManager stopUpdatingLocation];
}

@end
