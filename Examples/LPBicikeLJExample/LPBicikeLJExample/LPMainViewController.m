//
//  LPMainViewController.m
//  LPBicikeLJExample
//
//  Created by Luka Penger on 8/21/13.
//  Copyright (c) 2013 Luka Penger. All rights reserved.
//

// This code is distributed under the terms and conditions of the MIT license.
//
// Copyright (c) 2013 Luka Penger
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "LPMainViewController.h"


@interface LPMainViewController ()

@end


@implementation LPMainViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleName = [NSString stringWithFormat:@"%@", [info objectForKey:@"CFBundleDisplayName"]];
    self.title = bundleName;
    
    // Init
    
    [self initMapView];
    
    [self initBicikeljStationsFunctions];
    
    [self initRefreshButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self moveCameraToCenterAnimated:NO];
}

- (void)initRefreshButton
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshClicked:)];
    [button setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = button;
}

- (void)refreshClicked:(id)sender
{
    [self.bicikeljStationsFunctions loadStations];
}

- (IBAction)currentLocationButtonClicked:(id)sender
{
    [self moveCameraToCurrentLocationAnimated:YES];
}

#pragma mark - LPBicikeljStationsFunctions

- (void)initBicikeljStationsFunctions
{
    self.bicikeljStationsFunctions = [LPBicikeljStationsFunctions new];
    self.bicikeljStationsFunctions.delegate = self;
    
    //Load saved stations
    [self.bicikeljStationsFunctions loadSavedStations];
    
    if(self.bicikeljStationsFunctions.stationsList.count == 0) {
        NSLog(@"BicikeLJ Loaded Stations = 0");
    }
    
    [self.bicikeljStationsFunctions loadStations];
}

#pragma mark - MKMapView

- (void)initMapView
{
    if(!self.mapView) {
        self.mapView = [MKMapView new];
        self.mapView.delegate = self;
        self.mapView.frame = self.view.frame;
        [self.view addSubview:self.mapView];
        
        self.mapView.zoomEnabled = YES;
        self.mapView.showsUserLocation = YES;
        self.mapView.showsBuildings = YES;
        self.mapView.rotateEnabled = YES;
    }
}


- (void)moveCameraToCenterAnimated:(BOOL)animated
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(46.053f, 14.495f);
    float zoom = 0.2f;
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = coordinate;
    mapRegion.span.latitudeDelta = zoom;
    mapRegion.span.longitudeDelta = zoom;
    [self.mapView setRegion:mapRegion animated:animated];
}

- (void)moveCameraToCurrentLocationAnimated:(BOOL)animated
{
    CLLocationCoordinate2D coordinate = self.mapView.userLocation.coordinate;
    float zoom = 0.2f;
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = coordinate;
    mapRegion.span.latitudeDelta = zoom;
    mapRegion.span.longitudeDelta = zoom;
    [self.mapView setRegion:mapRegion animated:animated];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[LPAnnotation class]])
    {
        LPAnnotation *annotationObject = (LPAnnotation*)annotation;
        
        if(annotationObject) {
            NSString* annotationIdentifier = @"StationMarker";
            
            LPAnnotationView *annotationView = [[LPAnnotationView alloc] initWithAnnotation:annotationObject reuseIdentifier:annotationIdentifier];
            
            // Background image
            
            UIImage *bgImage = [UIImage imageNamed:@"AnnotationPin"];
            
            annotationView.frame = CGRectMake(0.0f, 0.0f, bgImage.size.width, bgImage.size.height);
            
            if(!annotationView.imageView) {
                annotationView.imageView = [UIImageView new];
                [annotationView addSubview:annotationView.imageView];
            }
            
            annotationView.imageView.backgroundColor = [UIColor clearColor];
            annotationView.imageView.frame=  CGRectMake(0.0f, 0.0f, annotationView.frame.size.width, annotationView.frame.size.height);
            [annotationView.imageView setImage:bgImage];
            
            annotationView.centerOffset = CGPointMake(0.0f, -(bgImage.size.height/2.0f));
            annotationView.backgroundColor=[UIColor clearColor];
            
            // Top label
            
            if(!annotationView.topLabel)
            {
                annotationView.topLabel = [UILabel new];
                [annotationView addSubview:annotationView.topLabel];
            }
            
            int freeCount = annotationObject.stationMarker.stationDetails.free;
            
            NSString *topText = [NSString stringWithFormat:@"%d", freeCount];
            
            annotationView.topLabel.backgroundColor = [UIColor clearColor];
            annotationView.topLabel.textColor = [UIColor redColor];
            annotationView.topLabel.font = [UIFont boldSystemFontOfSize:12.0f];
            annotationView.topLabel.textAlignment = NSTextAlignmentCenter;
            
            NSDictionary *attributes = @{NSFontAttributeName: annotationView.topLabel.font};
            CGRect rect = [topText boundingRectWithSize:CGSizeMake(annotationView.frame.size.width, MAXFLOAT)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:attributes
                                                context:nil];
            
            annotationView.topLabel.frame = CGRectMake(0.0f, 10.0f, annotationView.frame.size.width, rect.size.height);
            
            annotationView.topLabel.text = topText;
  
            // Center label
            
            if(!annotationView.bottomLabel)
            {
                annotationView.bottomLabel = [UILabel new];
                [annotationView addSubview:annotationView.bottomLabel];
            }
            
            NSString *centerText = [NSString stringWithFormat:@"%d", annotationObject.stationMarker.stationDetails.total];
            
            annotationView.bottomLabel.backgroundColor = [UIColor clearColor];
            annotationView.bottomLabel.textColor = [UIColor blackColor];
            annotationView.bottomLabel.font = [UIFont boldSystemFontOfSize:12.0f];
            annotationView.bottomLabel.textAlignment = NSTextAlignmentCenter;
            
            attributes = @{NSFontAttributeName: annotationView.bottomLabel.font};
            rect = [centerText boundingRectWithSize:CGSizeMake(annotationView.frame.size.width, MAXFLOAT)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:attributes
                                                   context:nil];
            
            annotationView.bottomLabel.frame = CGRectMake(0.0f, 22.0f, annotationView.frame.size.width, rect.size.height);
            
            annotationView.bottomLabel.text = centerText;
            
            return annotationView;
        }
    }
    
    return nil;
}

- (void)removeAllBicikeljStations
{
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
    if (self.mapView.userLocation) {
        [pins removeObject:self.mapView.userLocation];
    }
    [self.mapView removeAnnotations:pins];
}

- (void)refreshBicikeljStationsPins
{
    [self removeAllBicikeljStations];
    
    for(LPBicikeljStationMarker *stationMarker in self.bicikeljStationsFunctions.stationsList) {
        LPAnnotation *annotation = [LPAnnotation annotationWithStationMarker:stationMarker];
        
        [self.mapView addAnnotation:annotation];
    }
}

#pragma mark - LPBicikeljStationsFunctions Delegate

- (void)bicikeljStationsFunctionsWillLoadStations:(LPBicikeljStationsFunctions *)bicikeljStationsFunctions
{
    NSLog(@"bicikeljStationsFunctionsWillLoadStations");
    
    [self moveCameraToCenterAnimated:YES];
}

- (void)bicikeljStationsFunctions:(LPBicikeljStationsFunctions *)bicikeljStationsFunctions didLoadStations:(NSMutableArray *)stationsList
{
    NSLog(@"bicikeljStationsFunctions - didLoadStations");
    
    [self refreshBicikeljStationsPins];
}

- (void)bicikeljStationsFunctionsWillLoadStationsDetails:(LPBicikeljStationsFunctions *)bicikeljStationsFunctions
{
    NSLog(@"bicikeljStationsFunctionsWillLoadStationsDetails");
}

- (void)bicikeljStationsFunctions:(LPBicikeljStationsFunctions *)bicikeljStationsFunctions didLoadStationsDetails:(NSMutableArray *)stationsList
{
    NSLog(@"bicikeljStationsFunctions - didLoadStationsDetails");

    [self refreshBicikeljStationsPins];
}

- (void)bicikeljStationsFunctions:(LPBicikeljStationsFunctions *)bicikeljStationsFunctions errorLoadingStations:(NSError *)error
{
    NSLog(@"bicikeljStationsFunctions - errorLoadingStations: %@", error);
}

@end
