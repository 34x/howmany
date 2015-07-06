//
//  BoardViewController.h
//  HowManyC
//
//  Created by Max on 04/07/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

#import "ViewController.h"
#import "Game.h"

@interface BoardViewController : ViewController
@property (readwrite) Game *game;
- (void) initGame;
@end
