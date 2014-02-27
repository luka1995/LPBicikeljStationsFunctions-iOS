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

#import "LPBicikeljArrondissement.h"

@implementation LPBicikeljArrondissement

#pragma mark - Coder

- (id)initWithCoder:(NSCoder *)coder
{
	self = [LPBicikeljArrondissement new];
    if (self != nil)
	{
        self.number = [coder decodeIntegerForKey:@"number"];
        self.minLatitude = [coder decodeDoubleForKey:@"minLatitude"];
        self.minLongitude = [coder decodeDoubleForKey:@"minLongitude"];
        self.maxLatitude = [coder decodeDoubleForKey:@"maxLatitude"];
        self.maxLongitude = [coder decodeDoubleForKey:@"maxLongitude"];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInteger:self.number forKey:@"number"];
    [coder encodeDouble:self.minLatitude forKey:@"minLatitude"];
    [coder encodeDouble:self.minLongitude forKey:@"minLongitude"];
    [coder encodeDouble:self.maxLatitude forKey:@"maxLatitude"];
    [coder encodeDouble:self.maxLongitude forKey:@"maxLongitude"];
}

#pragma mark - Class

+ (id)arrondissementWithObjects:(NSDictionary*)dictionary
{
    LPBicikeljArrondissement *new = [LPBicikeljArrondissement new];

    if(![dictionary isKindOfClass:[NSNull class]])
    {
        if (![[dictionary objectForKey:@"number"] isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"number"] != nil) {
            new.number = [[dictionary objectForKey:@"number"] intValue];
        }
        
        if (![[dictionary objectForKey:@"minLat"] isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"minLat"] != nil) {
            new.minLatitude = [[dictionary objectForKey:@"minLat"] doubleValue];
        }
        
        if (![[dictionary objectForKey:@"minLng"] isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"minLng"] != nil) {
            new.minLongitude = [[dictionary objectForKey:@"minLng"] doubleValue];
        }
        
        if (![[dictionary objectForKey:@"maxLat"] isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"maxLat"] != nil) {
            new.maxLatitude = [[dictionary objectForKey:@"maxLat"] doubleValue];
        }
        
        if (![[dictionary objectForKey:@"maxLng"] isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"maxLng"] != nil) {
            new.maxLongitude = [[dictionary objectForKey:@"maxLng"] doubleValue];
        }
    }
    
	return new;
}

- (id)copyWithZone:(NSZone *)zone
{
    LPBicikeljArrondissement *new = [LPBicikeljArrondissement new];
    [new setNumber:[self number]];
    [new setMinLatitude:[self minLatitude]];
    [new setMinLongitude:[self minLongitude]];
    [new setMaxLatitude:[self maxLatitude]];
    [new setMaxLongitude:[self maxLongitude]];
    return new;
}

#pragma mark - Debug

- (NSDictionary*)dictionary
{
    NSDictionary *dictionary = [self dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"number",@"minLatitude",@"minLongitude",@"maxLatitude",@"maxLongitude", nil]];
    
    return dictionary;
}

- (NSString*)description
{
    return [self dictionary].description;
}

@end
