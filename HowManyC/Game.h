//
//  Game.h
//  HowManyC
//
//  Created by Max on 05/07/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject
@property (nonatomic) NSInteger itemsCount;
@property (nonatomic) NSInteger answer;
@property (nonatomic) BOOL success;
@property (nonatomic) NSInteger score;
@property (nonatomic) double minimum;
@property (nonatomic) double maximum;

@end
