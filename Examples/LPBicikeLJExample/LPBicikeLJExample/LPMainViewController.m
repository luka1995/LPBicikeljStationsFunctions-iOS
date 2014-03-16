//
//  LPMainViewController.m
//  LPBicikeLJExample
//
//  Created by Luka Penger on 8/21/13.
//  Copyright (c) 2013 Luka Penger. All rights reserved.
//

#import "LPMainViewController.h"


@interface LPMainViewController ()

@end


@implementation LPMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initBicikeljStationsFunctions];
}

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

#pragma mark - GCBicikeljStationsFunctions Delegate

- (void)bicikeljStationsFunctionsWillLoadStations:(LPBicikeljStationsFunctions *)bicikeljStationsFunctions
{
    NSLog(@"bicikelj stations will load markers");
}

- (void)bicikeljStationsFunctions:(LPBicikeljStationsFunctions *)bicikeljStationsFunctions didLoadStations:(NSMutableArray *)stationsList
{
    NSLog(@"bicikelj stations did load markers");
}

- (void)bicikeljStationsFunctionsWillLoadStationsDetails:(LPBicikeljStationsFunctions *)bicikeljStationsFunctions
{
    NSLog(@"bicikelj stations will load stations details");
}

- (void)bicikeljStationsFunctions:(LPBicikeljStationsFunctions *)bicikeljStationsFunctions didLoadStationsDetails:(NSMutableArray *)stationsList
{
    NSLog(@"bicikelj stations did load stations details");
    
    self.textView.text = stationsList.description;
}

@end
