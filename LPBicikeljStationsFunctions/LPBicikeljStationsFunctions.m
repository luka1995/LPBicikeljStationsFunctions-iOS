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

#import "LPBicikeljStationsFunctions.h"

@implementation LPBicikeljStationsFunctions

NSString *const bicikeljServiceStationsURL = @"http://www.bicikelj.si/service/carto";

NSString *const savedStationsListUserDefaultsKey = @"savedStationsList";
NSString *const savedArrondissementsListUserDefaultsKey = @"savedArrondissementsList";

#pragma mark - Lifecycle

- (id)init {
    if (self = [super init])
    {
        if(!self.stationsList)
            self.stationsList = [NSMutableArray new];
        
        if(!self.arrondissementsList)
            self.arrondissementsList = [NSMutableArray new];
    }
    return self;
}

#pragma mark - BicikeLJ Functions

- (void)loadStations
{
    if ([self.delegate respondsToSelector:@selector(bicikeljStationsFunctionsWillLoadStations:)])
    {
        [self.delegate bicikeljStationsFunctionsWillLoadStations:self];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:bicikeljServiceStationsURL]];
    AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
        XMLParser.delegate = self;
        [XMLParser parse];
    } failure:nil];
    [operation start];
}

- (void)loadStationsDetails
{
    if ([self.delegate respondsToSelector:@selector(bicikeljStationsFunctionsWillLoadStationsDetails:)])
    {
        [self.delegate bicikeljStationsFunctionsWillLoadStationsDetails:self];
    }
    
    loadingStationsDetails=0;
    loadingStationsDetailsCount=self.stationsList.count;
    
    for(int i=0;i<self.stationsList.count;i++)
    {
        LPBicikeljStationMarker *stationMarker = (LPBicikeljStationMarker*)[self.stationsList objectAtIndex:i];
        
        if(!stationMarker.stationDetails)
            stationMarker.stationDetails = [LPBicikeljStationDetails new];
        
        stationMarker.stationDetails.delegate=self;
        
        [stationMarker.stationDetails loadStationDetailsForNumber:stationMarker.number];
    }
}

- (void)loadSavedStations
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([userDefaults objectForKey:savedStationsListUserDefaultsKey]!=nil)
    {
        self.stationsList = [[NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:savedStationsListUserDefaultsKey]] mutableCopy];
    }
    
    if([userDefaults objectForKey:savedArrondissementsListUserDefaultsKey]!=nil)
    {
        self.arrondissementsList = [[NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:savedArrondissementsListUserDefaultsKey]] mutableCopy];
    }
}

- (void)saveStations
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.stationsList];
    [userDefaults setObject:encodedObject forKey:savedStationsListUserDefaultsKey];
    
    encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.arrondissementsList];
    [userDefaults setObject:encodedObject forKey:savedArrondissementsListUserDefaultsKey];

    [userDefaults synchronize];
}

#pragma mark - LPBicikeljStationDetails Delegate

- (void)bicikeljStationDetailsWillLoadDetails:(LPBicikeljStationDetails *)bicikeljStationDetails
{

}

- (void)bicikeljStationDetailsDidLoadDetails:(LPBicikeljStationDetails *)bicikeljStationDetails
{
    loadingStationsDetails++;
    
    if(loadingStationsDetails>=loadingStationsDetailsCount)
    {
        if ([self.delegate respondsToSelector:@selector(bicikeljStationsFunctions:didLoadStationsDetails:)])
        {
            [self.delegate bicikeljStationsFunctions:self didLoadStationsDetails:self.stationsList];
        }
    }
    
    [self saveStations];
}

#pragma mark - XML Parser

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    if(!self.stationsList)
        self.stationsList = [NSMutableArray new];
    
    if(!self.arrondissementsList)
        self.arrondissementsList = [NSMutableArray new];
    
    [self.stationsList removeAllObjects];
    [self.arrondissementsList removeAllObjects];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if ([self.delegate respondsToSelector:@selector(bicikeljStationsFunctions:didLoadStations:)])
    {
        [self.delegate bicikeljStationsFunctions:self didLoadStations:self.stationsList];
    }
    
    [self loadStationsDetails];
    
    [self saveStations];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"marker"])
    {
        LPBicikeljStationMarker *stationMarker = [LPBicikeljStationMarker stationMarkerWithObjects:attributeDict];

        [self.stationsList addObject:stationMarker];
    }
    else if([elementName isEqualToString:@"arrondissement"])
    {
        LPBicikeljArrondissement *arrondissement = [LPBicikeljArrondissement arrondissementWithObjects:attributeDict];

        [self.arrondissementsList addObject:arrondissement];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    //NSLog(@"Parser error");
}

- (LPBicikeljStationMarker*)nearestStationForStartLocation:(CLLocationCoordinate2D)location {
    __block CLLocationDistance minDistance = CLLocationDistanceMax;
    __block NSUInteger minDistanceNumber = NSUIntegerMax;
    
    //StartLocation Station
	[[self stationsList] enumerateObjectsUsingBlock:^(LPBicikeljStationMarker *station, NSUInteger i, BOOL *stop) {
		CLLocation *pointA = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
        CLLocation *pointB = [[CLLocation alloc] initWithLatitude:station.latitude longitude:station.longitude];
        CLLocationDistance distance = [pointA distanceFromLocation:pointB];
        
        if(distance <= minDistance && station.open > 0 && station.stationDetails.available > 0) {
            minDistance = distance;
            minDistanceNumber = i;
        }
	}];

	if (minDistanceNumber != NSUIntegerMax) {
		return [[self stationsList][minDistanceNumber] copy];
	}
    return nil;
}

- (LPBicikeljStationMarker*)nearestStationForEndLocation:(CLLocationCoordinate2D)location {
    __block CLLocationDistance minDistance = CLLocationDistanceMax;
    __block NSUInteger minDistanceNumber = NSUIntegerMax;
    
    //EndLocation Station
	[[self stationsList] enumerateObjectsUsingBlock:^(LPBicikeljStationMarker *station, NSUInteger i, BOOL *stop) {
		CLLocation *pointA = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
        CLLocation *pointB = [[CLLocation alloc] initWithLatitude:station.latitude longitude:station.longitude];
        CLLocationDistance distance = [pointA distanceFromLocation:pointB];
        
        if(distance <= minDistance && station.open > 0 && station.stationDetails.free > 0) {
            minDistance = distance;
            minDistanceNumber = i;
        }
	}];
	
    if (minDistanceNumber != NSUIntegerMax) {
		return [[self stationsList][minDistanceNumber] copy];
	}
    return nil;
}

@end
