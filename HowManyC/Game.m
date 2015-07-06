//
//  Game.m
//  HowManyC
//
//  Created by Max on 05/07/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

#import "Game.h"

@implementation Game
- (instancetype) init {
    self = [super init];
    
    if(self) {
        self.itemsCount = 2;
        self.score = 0;
        self.success = false;
    }
    
    
    return self;
}

@end
