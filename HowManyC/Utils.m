//
//  Utils.m
//  HowManyC
//
//  Created by Max on 05/07/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(double) rnd:(double)from to:(double)to {

    double val = ((double)arc4random() / 0x100000000) * (to-from) + from;
    
    return val;
}

@end