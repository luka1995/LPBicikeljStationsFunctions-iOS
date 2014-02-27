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

#import "LPBicikeljStationDetails.h"

@implementation LPBicikeljStationDetails

NSString *const bicikeljServiceStationDetailsURL = @"http://www.bicikelj.si/service/stationdetails/ljubljana/%d";

#pragma mark - Coder

- (id)initWithCoder:(NSCoder *)coder
{
	self = [LPBicikeljStationDetails new];
    if (self != nil)
	{
        self.available = [coder decodeIntegerForKey:@"available"];
        self.free = [coder decodeIntegerForKey:@"free"];
        self.total = [coder decodeIntegerForKey:@"total"];
        self.ticket = [coder decodeIntegerForKey:@"ticket"];
        self.open = [coder decodeIntegerForKey:@"open"];
        self.updated = [coder decodeIntegerForKey:@"updated"];
        self.connected = [coder decodeIntegerForKey:@"connected"];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInteger:self.available forKey:@"available"];
    [coder encodeInteger:self.free forKey:@"free"];
    [coder encodeInteger:self.total forKey:@"total"];
    [coder encodeInteger:self.ticket forKey:@"ticket"];
    [coder encodeInteger:self.open forKey:@"open"];
    [coder encodeInteger:self.updated forKey:@"updated"];
    [coder encodeInteger:self.connected forKey:@"connected"];
}

#pragma mark - Class

+ (id)stationDetailsWithObjects:(NSDictionary *)dictionary
{
    LPBicikeljStationDetails *new = [LPBicikeljStationDetails new];
    
    if(![dictionary isKindOfClass:[NSNull class]])
    {
        if (![[dictionary objectForKey:@"available"] isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"available"] != nil) {
            new.available = [[dictionary objectForKey:@"available"] intValue];
        }
        
        if (![[dictionary objectForKey:@"free"] isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"free"] != nil) {
            new.free = [[dictionary objectForKey:@"free"] intValue];
        }
        
        if (![[dictionary objectForKey:@"total"] isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"total"] != nil) {
            new.total = [[dictionary objectForKey:@"total"] intValue];
        }
        
        if (![[dictionary objectForKey:@"ticket"] isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"ticket"] != nil) {
            new.ticket = [[dictionary objectForKey:@"ticket"] intValue];
        }
        
        if (![[dictionary objectForKey:@"open"] isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"open"] != nil) {
            new.open = [[dictionary objectForKey:@"open"] intValue];
        }
        
        if (![[dictionary objectForKey:@"updated"] isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"updated"] != nil) {
            new.updated = [[dictionary objectForKey:@"updated"] intValue];
        }
        
        if (![[dictionary objectForKey:@"connected"] isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"connected"] != nil) {
            new.connected = [[dictionary objectForKey:@"connected"] intValue];
        }
    }
    
	return new;
}

+ (id)stationDetailsForNumber:(int)number
{
    LPBicikeljStationDetails *new = [LPBicikeljStationDetails new];
    
    [new loadStationDetailsForNumber:number];
    
    return new;
}

- (id)copyWithZone:(NSZone *)zone
{
    LPBicikeljStationDetails *new = [LPBicikeljStationDetails new];
    [new setAvailable:[self available]];
    [new setFree:[self free]];
    [new setTotal:[self total]];
    [new setTicket:[self ticket]];
    [new setOpen:[self open]];
    [new setUpdated:[self updated]];
    [new setConnected:[self connected]];
    return new;
}

#pragma mark - Debug

- (NSDictionary*)dictionary
{
    NSDictionary *dictionary = [self dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"available",@"free",@"total",@"ticket",@"open",@"updated",@"connected", nil]];
    
    return dictionary;
}

- (NSString*)description
{
    return [self dictionary].description;
}

#pragma mark - Load Data Functions

- (void)loadStationDetailsForNumber:(int)number
{
    if ([self.delegate respondsToSelector:@selector(bicikeljStationDetailsWillLoadDetails:)])
    {
        [self.delegate bicikeljStationDetailsWillLoadDetails:self];
    }
    
    NSString *URL = [NSString stringWithFormat:bicikeljServiceStationDetailsURL,number];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
        XMLParser.delegate = self;
        [XMLParser parse];
    } failure:nil];
    [operation start];
}

#pragma mark - XML Parser

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    waitingCharacters=0;
    
    //NSLog(@"Parser start");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    waitingCharacters=0;
    
    if ([self.delegate respondsToSelector:@selector(bicikeljStationDetailsDidLoadDetails:)])
    {
        [self.delegate bicikeljStationDetailsDidLoadDetails:self];
    }
    
    //NSLog(@"%@",self.description);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"available"])
    {
        waitingCharacters=1;
    }
    else if([elementName isEqualToString:@"free"])
    {
        waitingCharacters=2;
    }
    else if([elementName isEqualToString:@"total"])
    {
        waitingCharacters=3;
    }
    else if([elementName isEqualToString:@"ticket"])
    {
        waitingCharacters=4;
    }
    else if([elementName isEqualToString:@"open"])
    {
        waitingCharacters=5;
    }
    else if([elementName isEqualToString:@"updated"])
    {
        waitingCharacters=6;
    }
    else if([elementName isEqualToString:@"connected"])
    {
        waitingCharacters=7;
    }
    else
    {
        waitingCharacters=0;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    switch (waitingCharacters) {
        case 1:
            self.available=[string intValue];
            waitingCharacters=0;
            break;
        case 2:
            self.free=[string intValue];
            waitingCharacters=0;
            break;
        case 3:
            self.total=[string intValue];
            waitingCharacters=0;
            break;
        case 4:
            self.ticket=[string intValue];
            waitingCharacters=0;
            break;
        case 5:
            self.open=[string intValue];
            waitingCharacters=0;
            break;
        case 6:
            self.updated=[string intValue];
            waitingCharacters=0;
            break;
        case 7:
            self.connected=[string intValue];
            waitingCharacters=0;
            break;
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    waitingCharacters=0;
    
    //NSLog(@"Parser error");
}

@end