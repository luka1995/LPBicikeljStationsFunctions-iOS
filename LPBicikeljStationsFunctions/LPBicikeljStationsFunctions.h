//
//  LPGoogleFunctions.h
//
//  Created by Luka Penger on 7/3/13.
//  Copyright (c) 2013 Luka Penger. All rights reserved.
//

// This code is distributed under the terms and conditions of the MIT license.

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

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "LPBicikeljStationMarker.h"
#import "LPBicikeljArrondissement.h"
#import <CoreLocation/CoreLocation.h>


@protocol LPBicikeljStationsFunctionsDelegate;

@interface LPBicikeljStationsFunctions : NSObject <NSXMLParserDelegate, LPBicikeljStationDetailsDelegate>
{
    int loadingStationsDetails;
    int loadingStationsDetailsCount;
}

@property (nonatomic, weak) id <LPBicikeljStationsFunctionsDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *stationsList;
@property (nonatomic, strong) NSMutableArray *arrondissementsList;

- (void)loadStations;
- (void)loadStationsDetails;
- (void)loadSavedStations;
- (void)saveStations;
- (LPBicikeljStationMarker*)nearestStationForStartLocation:(CLLocationCoordinate2D)location;
- (LPBicikeljStationMarker*)nearestStationForEndLocation:(CLLocationCoordinate2D)location;

@end


#pragma mark - Delegate Protocol
@protocol LPBicikeljStationsFunctionsDelegate <NSObject>

@optional

- (void)bicikeljStationsFunctionsWillLoadStations:(LPBicikeljStationsFunctions *)bicikeljStationsFunctions;
- (void)bicikeljStationsFunctions:(LPBicikeljStationsFunctions *)bicikeljStationsFunctions didLoadStations:(NSMutableArray*)stationsList;
- (void)bicikeljStationsFunctionsWillLoadStationsDetails:(LPBicikeljStationsFunctions *)bicikeljStationsFunctions;
- (void)bicikeljStationsFunctions:(LPBicikeljStationsFunctions *)bicikeljStationsFunctions didLoadStationsDetails:(NSMutableArray*)stationsList;

@end