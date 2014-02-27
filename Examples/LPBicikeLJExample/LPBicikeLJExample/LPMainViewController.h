//
//  LPMainViewController.h
//  LPBicikeLJExample
//
//  Created by Luka Penger on 8/21/13.
//  Copyright (c) 2013 Luka Penger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPBicikeljStationsFunctions.h"


@interface LPMainViewController : UIViewController <LPBicikeljStationsFunctionsDelegate>

@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) LPBicikeljStationsFunctions *bicikeljStationsFunctions;

@end
