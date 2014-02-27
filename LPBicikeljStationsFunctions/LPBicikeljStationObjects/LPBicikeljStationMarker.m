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

#import "LPBicikeljStationMarker.h"

@implementation LPBicikeljStationMarker

#pragma mark - Coder

- (id)initWithCoder:(NSCoder *)coder
{
	self = [LPBicikeljStationMarker new];
    if (self != nil)
	{
        self.name = [coder decodeObjectForKey:@"name"];
        self.number = [coder decodeIntegerForKey:@"number"];
        self.address = [coder decodeObjectForKey:@"address"];
        self.fullAddress = [coder decodeObjectForKey:@"fullAddress"];
        self.latitude = [coder decodeDoubleForKey:@"latitude"];
        self.longitude = [coder decodeDoubleForKey:@"longitude"];
        self.open = [coder decodeIntegerForKey:@"open"];
        self.bonus = [coder decodeIntegerForKey:@"bonus"];
        self.stationDetails = [coder decodeObjectForKey:@"stationDetails"];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeInteger:self.number forKey:@"number"];
    [coder encodeObject:self.address forKey:@"address"];
    [coder encodeObject:self.fullAddress forKey:@"fullAddress"];
    [coder encodeDouble:self.latitude forKey:@"latitude"];
    [coder encodeDouble:self.longitude forKey:@"longitude"];
    [coder encodeInteger:self.open forKey:@"open"];
    [coder encodeInteger:self.bonus forKey:@"bonus"];
    [coder encodeObject:self.stationDetails forKey:@"stationDetails"];
}

#pragma mark - Class

+ (id)stationMarkerWithObjects:(NSDictionary *)dictionary
{
    LPBicikeljStationMarker *new = [LPBicikeljStationMarker new];
    
    if(![dictionary isKindOfClass:[NSNull class]])
    {
        if (![[dictionary objectForKey:@"name"] isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"name"] != nil) {
            new.name = [dictionary objectForKey:@"name"];
        }
        
        if (![[dictionary objectForKey:@"number"] isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"number"] != nil) {
            new.number = [[dictionary objectForKey:@"number"] intValue];
        }
        
        if (![[dictionary objectForKey:@"address"] isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"address"] != nil) {
            new.address = [dictionary objectForKey:@"address"];
        }
        
        if (![[dictionary objectForKey:@"fullAddress"] isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"fullAddress"] != nil) {
            new.fullAddress = [dictionary objectForKey:@"fullAddress"];
        }
        
        if (![[dictionary objectForKey:@"lat"] isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"lat"] != nil) {
            new.latitude = [[dictionary objectForKey:@"lat"] doubleValue];
        }
        
        if (![[dictionary objectForKey:@"lng"] isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"lng"] != nil) {
            new.longitude = [[dictionary objectForKey:@"lng"] doubleValue];
        }
        
        if (![[dictionary objectForKey:@"open"] isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"open"] != nil) {
            new.open = [[dictionary objectForKey:@"open"] intValue];
        }
        
        if (![[dictionary objectForKey:@"bonus"] isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"bonus"] != nil) {
            new.bonus = [[dictionary objectForKey:@"bonus"] doubleValue];
        }
        
        if (![[dictionary objectForKey:@"stationDetails"] isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"stationDetails"] != nil) {
            new.stationDetails = [LPBicikeljStationDetails stationDetailsWithObjects:[dictionary objectForKey:@"stationDetails"]];
        }
    }
    
	return new;
}

- (id)copyWithZone:(NSZone *)zone
{
    LPBicikeljStationMarker *new = [LPBicikeljStationMarker new];
    [new setName:[self name]];
    [new setNumber:[self number]];
    [new setAddress:[self address]];
    [new setFullAddress:[self fullAddress]];
    [new setLatitude:[self latitude]];
    [new setLongitude:[self longitude]];
    [new setOpen:[self open]];
    [new setBonus:[self bonus]];
    [new setStationDetails:[self stationDetails]];
    return new;
}

#pragma mark - Debug

- (NSDictionary*)dictionary
{
    NSDictionary *dictionary = [self dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"name",@"number",@"address",@"fullAddress",@"latitude",@"longitude",@"open",@"bonus", nil]];
 
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    
    if(self.stationDetails!=nil && ![self.stationDetails isKindOfClass:[NSNull class]])
    {
        [mutableDictionary setObject:self.stationDetails.dictionary forKey:@"stationDetails"];
    }
    
    return mutableDictionary;
}

- (NSString*)description
{
    return [self dictionary].description;
}

@end