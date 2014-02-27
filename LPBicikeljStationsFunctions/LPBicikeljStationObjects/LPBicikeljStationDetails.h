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

@protocol LPBicikeljStationDetailsDelegate;

@interface LPBicikeljStationDetails : NSObject <NSCoding,NSXMLParserDelegate>
{
    int waitingCharacters;
}

@property (nonatomic, weak) id <LPBicikeljStationDetailsDelegate> delegate;

@property (nonatomic, assign) int available;
@property (nonatomic, assign) int free;
@property (nonatomic, assign) int total;
@property (nonatomic, assign) int ticket;
@property (nonatomic, assign) int open;
@property (nonatomic, assign) int updated;
@property (nonatomic, assign) int connected;

+ (id)stationDetailsWithObjects:(NSDictionary*)dictionary;

- (NSDictionary*)dictionary;

- (id)copyWithZone:(NSZone *)zone;

+ (id)stationDetailsForNumber:(int)number;
- (void)loadStationDetailsForNumber:(int)number;

@end;

#pragma mark - Delegate Protocol
@protocol LPBicikeljStationDetailsDelegate<NSObject>

@optional

- (void)bicikeljStationDetailsWillLoadDetails:(LPBicikeljStationDetails *)bicikeljStationDetails;
- (void)bicikeljStationDetailsDidLoadDetails:(LPBicikeljStationDetails *)bicikeljStationDetails;

@end